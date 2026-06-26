/*
 * HPM5300EVK clean driver template
 *
 * 说明：
 * 1. 不使用 board.h
 * 2. 不使用 board_init()
 * 3. 不使用 board_init_gpio_pins()
 * 4. 不使用 board_delay_ms()
 * 5. 不使用 BOARD_LED_GPIO_xxx 板级宏
 * 6. 只保留官方 GPIO 驱动头文件
 */

#include "hpm_gpio_drv.h"

int main(void)
{
    while (1) {
        /*
         * 用户代码写在这里
         *
         * 当前模板什么都不执行
         */
    }


    return 0;
}
