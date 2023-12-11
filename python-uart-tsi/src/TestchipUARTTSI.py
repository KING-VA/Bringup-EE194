import serial
import time
from collections import deque
from TestchipTSI import TestchipTSI


class TestchipUARTTSI(TestchipTSI):

    BAUDRATES = [1200, 1800, 2400, 4800, 9600, 19200, 38400, 57600, 115200, 
                 230400, 460800, 500000, 576000, 921600, 1000000, 1152000,
                   1500000, 2000000, 2500000, 3000000, 4000000]
    DEFAULT_BAUDRATE = 921600

    def __init__(self, ttyfile, baud_rate, verbose=False, do_self_check=False):
        """
        Initialize the UART TSI. This will open the serial port and configure it for the given baud rate.
        """
        super().__init__()
        self.ttyfile = ttyfile
        self.baud_rate = baud_rate
        self.verbose = verbose
        self.in_load_program = False
        self.do_self_check = do_self_check
        self.read_bytes = deque()
        self.loaded_program = {}

        if baud_rate not in self.BAUDRATES:
            print(f"Unsupported baud rate {baud_rate}")
            exit(1)

        if baud_rate != self.DEFAULT_BAUDRATE:
            print("Warning: You selected a non-standard baudrate. This will only work if the HW was configured with this baud-rate")

        try:
            self.ser = serial.Serial(
                port=ttyfile,
                baudrate=baud_rate,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                bytesize=serial.EIGHTBITS,
                timeout=0
            )
        except Exception as e:
            print(f"Error from open: {str(e)}")
            exit(1)
    # TODO: Add the data_available, recv_word, and send_word methods
    # The data_available method should return a boolean indicating whether there is data available to read
    # The recv_word method should return the next word of data
    # The send_word method should send a word of data.

    def handle_uart(self):
        """
        Handle the UART. This should be called repeatedly in a loop.
        """
        to_write = []
        while self.data_available():
            d = self.recv_word()
            to_write.append(d)
            to_write.append(d >> 16)

        buf = bytes(to_write)
        write_size = len(to_write)
        written = 0
        remaining = write_size

        while remaining > 0:
            written = self.ser.write(buf[write_size - remaining:])
            remaining = remaining - written
        if self.verbose:
            for i in range(write_size):
                print(f"Wrote {buf[i]:x}")

        read_buf = self.ser.read(256)
        n = len(read_buf)
        if n < 0:
            print(f"Error from read: {str(n)}")
            exit(1)
        for i in range(n):
            self.read_bytes.append(read_buf[i])

        if len(self.read_bytes) >= 4:
            out_data = 0
            for i in range(4):
                out_data |= self.read_bytes.pop(0) << (i * 8)
            if self.verbose:
                print(f"Read {out_data:x}")
            self.send_word(out_data)
        return self.data_available() or n > 0
    
    def check_connection(self):
        """
        Check if the UART is connected to the testchip, and if so, return True. Otherwise, print error and exit.
        """
        if self.verbose:
            print("Checking connection")
        time.sleep(1)  # sleep for 1 second
        rdata = self.ser.read(1)
        if len(rdata) > 0:
            print(f"Error: Reading unexpected data {rdata} from UART. Abort.")
            exit(1)
        return True
    
    # TODO: replace the testchip_tsi, chunk_max_size, read_chunk, and loaded_program attributes
    # The testchip_tsi attribute should be an instance of a class that has a load_program method. 
    # The chunk_max_size method should return the maximum size of a chunk. 
    # The read_chunk method should read a chunk of data from a specified address into a buffer. 
    # The loaded_program attribute should be a dictionary where the keys are the addresses of the chunks and the values are the chunks of data.
    def load_program(self):
        self.in_load_program = True
        self.testchip_tsi.load_program()
        self.in_load_program = False

        rbuf = bytearray(self.chunk_max_size())
        if self.do_self_check:
            print("Performing self check")
            for addr, data in self.loaded_program.items():
                print(f"Self check chunk {addr:x} to {addr + len(data):x}")
                self.read_chunk(addr, len(data), rbuf)
                for i in range(len(data)):
                    if rbuf[i] != data[i]:
                        print(f"Self check failed at address {addr + i:x} {rbuf[i]:x} != {data[i]:x}")
                        exit(1)
                print(f"Self check succeeded chunk {addr:x} to {addr + len(data):x}")
            print("Self check success")

    # TODO: replace the testchip_tsi and loaded_program attributes
    # The testchip_tsi attribute should be an instance of a class that has a write_chunk method.
    # The loaded_program attribute should be a dictionary where the keys are the addresses of the chunks and the values are the chunks of data.
    def write_chunk(self, taddr, nbytes, src):
        self.testchip_tsi.write_chunk(taddr, nbytes, src)
        if self.in_load_program:
            eaddr = taddr + nbytes
            for addr, data in self.loaded_program.items():
                if ((taddr >= addr and taddr < addr + len(data)) or
                    (eaddr > addr and eaddr <= addr + len(data)) or
                    (taddr < addr and eaddr > addr + len(data))):
                    print("Error: Overlapping sections in loaded program.")
                    print(f"Write addr: {taddr:x} - {eaddr:x}")
                    print(f"Conflict addr: {addr:x} - {addr + len(data):x}")
                    exit(1)
            self.loaded_program[taddr] = bytearray(src[:nbytes])