Extend the UART TSI script to support bidirectional host to target TL
communication.  The script should be able to send and receive TL packets

Not fesvr but provides a way to read and write things to the target -- essentially if I tell it to run things then it calls the appropriate mem read/write to run the program
    Don't needed to call all of FESVR for the python library to work correctly
        Important Things
            1 - How to open TTY (See python libraries for how to do this -- copy over settings testchipui based on Jerry's work)
            2 - Format TSI messages (TSI - sequence of 32 bit words -- reference the source code for the protocol from Jerry)
                Review the code for the protocol -- https://github.com/riscv-software-src/riscv-isa-sim/blob/eeef09ebb894c3bb7e42b7b47aae98792b8eef79/fesvr/tsi.cc#L52-L79
                Write bytes in order to TTY which should send the approportiate signal into the target over the UART
                For reads do the same thing but in reverse -- little endian (Figure out the order of the bytes based on the memory system)

Jerry's suggestion for how to do this:
    Implement part of the system -- don't do the entire thing
        On the FPGA side -- loop rx and tx together so that we send and recieve the same value
        TSI.py -- send some info out verify that everything works (can use stdin and out as well to verify functionality first)
            If FPGA available No core arrty-100t -- just use the FPGA to test the TSI protocol -- send and receive data
    
    For FPGA -- set up the system so that you have a uart terminal that can be exposed to the host -- 
