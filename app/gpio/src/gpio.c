#include "board.h"
#include "hpm_uart_drv.h"
#include "hpm_clock_drv.h"

int main(void)
{
    /*
     * board_init() :
     *   1. board_init_clock()      PLL  480MHz
     *   2. board_init_console()    init_uart0_pins()  PA00=UART0_TXD
     *                              UART0  115200
     */
    board_init();

    while (1) {
        uart_send_byte(HPM_UART0, 0x00);   /*  0x00 */
        clock_cpu_delay_ms(100);            /*  100ms */
    }

    return 0;
}