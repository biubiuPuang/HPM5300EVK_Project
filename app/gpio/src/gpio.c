/*
 * 功能：UART0 监听看门狗 + 5 秒超时点亮 LED
 *
 * 上位机通过 J8 (USB → FT2232 → UART0) 发送串口数据，
 * 单片机只管监听，不处理数据内容。
 * 如果连续 5 秒没有收到任何数据，点亮板载 LED（永久锁定）。
 */

/* ===== 抑制 board_init() 的自动打印 ===== */
#define BOARD_SHOW_CLOCK  0
#define BOARD_SHOW_BANNER 0

#include "board.h"
#include "hpm_uart_drv.h"
#include "hpm_gpio_drv.h"
#include "hpm_gptmr_drv.h"
#include "hpm_clock_drv.h"

/* ================================================================
 * 用户自定义启动打印（在这里写你想打印的内容）
 * ================================================================ */
static const char *const USER_BOOT_MSG =
    "\r\n"
    "========================================\r\n"
    "  UART Watchdog Demo\r\n"
    "  监听 UART0，5 秒无数据则点亮 LED\r\n"
    "========================================\r\n"
    "\r\n";

/* ===== 超时配置 ===== */
#define TIMEOUT_MS        5000U
#define GPTMR_TICK_MS     10U
#define TIMEOUT_TICKS     (TIMEOUT_MS / GPTMR_TICK_MS)   /* 500 */

/* ===== GPTMR1 配置 ===== */
#define WDT_GPTMR         HPM_GPTMR1
#define WDT_GPTMR_CLK     clock_gptmr1
#define WDT_GPTMR_IRQ     IRQn_GPTMR1
#define WDT_GPTMR_CH      0

/* ===== LED 配置 (PA23, 低电平有效) ===== */
#define LED_GPIO_CTRL     HPM_GPIO0
#define LED_GPIO_INDEX    GPIO_DI_GPIOA
#define LED_GPIO_PIN      23

/* ===== 全局状态 ===== */
static volatile uint32_t wdt_ticks;       /* 超时滴答计数          */
static volatile bool     led_locked;      /* LED 锁定标志          */


/* ==================================================================
 * GPTMR1 ISR — 每 10ms 触发一次
 * ================================================================== */
SDK_DECLARE_EXT_ISR_M(WDT_GPTMR_IRQ, isr_gptmr1)
void isr_gptmr1(void)
{
    if (gptmr_check_status(WDT_GPTMR, GPTMR_CH_RLD_STAT_MASK(WDT_GPTMR_CH))) {
        gptmr_clear_status(WDT_GPTMR, GPTMR_CH_RLD_STAT_MASK(WDT_GPTMR_CH));

        if (!led_locked) {
            wdt_ticks++;
            if (wdt_ticks >= TIMEOUT_TICKS) {
                /* 5 秒无数据 → 点亮 LED，永久锁定 */
                gpio_write_pin(LED_GPIO_CTRL, LED_GPIO_INDEX,
                               LED_GPIO_PIN, 0);
                led_locked = true;
            }
        }
    }
}


/* ==================================================================
 * UART0 RX ISR — 收到数据时触发
 * ================================================================== */
SDK_DECLARE_EXT_ISR_M(IRQn_UART0, isr_uart0)
void isr_uart0(void)
{
    /*
     * 一次性清空 RX FIFO 中所有字节，
     * 否则 uart_intr_rx_data_avail_or_timeout 不会自动清除
     */
    while (uart_check_status(HPM_UART0, uart_stat_data_ready)) {
        (void)uart_read_byte(HPM_UART0);   /* 读走数据，不做处理 */
    }

    /* ─── 用户数据处理 ────────────────────────────────── */
    /* 如果你需要处理接收到的数据，请在下面添加自己的逻辑    */
    /* 比如：解析协议、回显、写入缓冲区等                   */
    /* ─────────────────────────────────────────────────── */

    /* 收到数据 → 清零超时计数器 */
    wdt_ticks = 0;
}


/* ==================================================================
 * 主函数
 * ================================================================== */
int main(void)
{
    /*
     * board_init() 做了:
     *   - 配 PLL: CPU 480MHz, AHB 160MHz
     *   - 配 UART0: PA00=TX, PA01=RX, 波特率 115200
     *   (时钟/LOGO 打印已被 #define 抑制)
     */
    board_init();

    /* ─── 用户自定义启动打印（可修改 USER_BOOT_MSG 内容）─── */
    printf("%s", USER_BOOT_MSG);

    /* ===== 初始化 LED (PA23) ===== */
    init_led_pins_as_gpio();
    gpio_set_pin_output_with_initial(LED_GPIO_CTRL, LED_GPIO_INDEX,
                                     LED_GPIO_PIN,
                                     board_get_led_gpio_off_level());

    /* ===== 配置 GPTMR1 10ms 定时中断 ===== */
    clock_add_to_group(WDT_GPTMR_CLK, 0);

    uint32_t gptmr_freq = clock_get_frequency(WDT_GPTMR_CLK);
    gptmr_channel_config_t gptmr_cfg;
    gptmr_channel_get_default_config(WDT_GPTMR, &gptmr_cfg);
    gptmr_cfg.reload = gptmr_freq / 1000 * GPTMR_TICK_MS;

    gptmr_channel_config(WDT_GPTMR, WDT_GPTMR_CH, &gptmr_cfg, false);
    gptmr_enable_irq(WDT_GPTMR, GPTMR_CH_RLD_IRQ_MASK(WDT_GPTMR_CH));
    intc_m_enable_irq_with_priority(WDT_GPTMR_IRQ, 1);
    gptmr_start_counter(WDT_GPTMR, WDT_GPTMR_CH);

    /* ===== 使能 UART0 接收中断 ===== */
    uart_enable_irq(HPM_UART0, uart_intr_rx_data_avail_or_timeout);
    intc_m_enable_irq_with_priority(IRQn_UART0, 1);

    /* 主循环空闲 — 所有逻辑由两个 ISR 协作完成 */
    while (1) {
        __asm volatile("wfi");
    }

    return 0;
}
