import argparse
import time
from TestchipUARTTSI import TestchipUARTTSI

# TODO: The TestchipUartTsi class should also have done, switch_to_host, and exit_code methods

def main():
    print("Starting UART-based TSI")
    print("Usage: ./uart_tsi +tty=/dev/pts/xx <PLUSARGS> <bin>")
    print("       ./uart_tsi +tty=/dev/ttyxx  <PLUSARGS> <bin>")
    print("       ./uart_tsi +tty=/dev/ttyxx  +no_hart0_msip +init_write=0x80000000:0xdeadbeef none")
    print("       ./uart_tsi +tty=/dev/ttyxx  +no_hart0_msip +init_read=0x80000000 none")
    print("       ./uart_tsi +tty=/dev/ttyxx  +selfcheck <bin>")
    print("       ./uart_tsi +tty=/dev/ttyxx  +baudrate=921600 <bin>")

    parser = argparse.ArgumentParser()
    parser.add_argument("+tty", type=str, help="Specify a tty")
    parser.add_argument("+verbose", action="store_true", help="Enable verbose mode")
    parser.add_argument("+selfcheck", action="store_true", help="Perform self check")
    parser.add_argument("+baudrate", type=int, default=115200, help="Specify baud rate")
    args = parser.parse_args()

    if args.tty is None:
        print("ERROR: Must use +tty=/dev/ttyxx to specify a tty")
        exit(1)

    print(f"Attempting to open TTY at {args.tty}")
    tsi = TestchipUARTTSI(args.tty, args.baudrate, args.verbose, args.selfcheck)
    print(f"Checking connection status with {args.tty}")
    if not tsi.check_connection():
        print("Connection failed")
        exit(1)
    else:
        print("Connection succeeded")

    while not tsi.done():
        tsi.switch_to_host()
        tsi.handle_uart()

    print("Done, shutting down, flushing UART")
    while tsi.handle_uart():
        tsi.switch_to_host()  # flush any inflight reads or writes

    print("WARNING: You should probably reset the target before running this program again")
    return tsi.exit_code()

if __name__ == "__main__":
    main()
