#include "uart.h"

//Dummy function for UART PRINTF for spike.  Baremetal spike does not support this
int uart_printf(const char* format, ...)
{
    return 0;
}
