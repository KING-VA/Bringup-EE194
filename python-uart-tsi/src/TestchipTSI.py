
# TODO: Replace the TSI class and the load_mem_write, nad load_mem_read methods 
# The TSI class should be a base class that has write_chunk and read_chunk methods. 
# The load_mem_write method should write to load memory
# The load_mem_read method should read from load memory
class TestChipTSI(TSI):
    def __init__(self, args, can_have_loadmem=False):
        super().__init__(args)
        self.has_loadmem = False
        self.init_accesses = []
        self.write_hart0_msip = True
        self.is_loadmem = False
        self.cflush_addr = 0
        for arg in args:
            if arg.startswith("+loadmem="):
                self.has_loadmem = can_have_loadmem
            if arg.startswith("+cflush_addr=0x"):
                self.cflush_addr = int(arg[15:], 16)

        self.parse_htif_args(args)

    def flush_cache_lines(self, taddr, nbytes):
        if not self.cflush_addr:
            return
        cblock_bytes = 64
        base = taddr & ~(cblock_bytes-1)
        while base < taddr + nbytes:
            data = [base, base >> 32]
            self.write_chunk(self.cflush_addr, 8, data)
            base += cblock_bytes

    def write_chunk(self, taddr, nbytes, src):
        if self.is_loadmem:
            self.load_mem_write(taddr, nbytes, src)
        else:
            self.flush_cache_lines(taddr, nbytes)
            super().write_chunk(taddr, nbytes, src)

    def read_chunk(self, taddr, nbytes, dst):
        if self.is_loadmem:
            self.load_mem_read(taddr, nbytes, dst)
        else:
            self.flush_cache_lines(taddr, nbytes)
            super().read_chunk(taddr, nbytes, dst)

    def reset(self):
        self.perform_init_accesses()
        if self.write_hart0_msip:
            super().reset()

    def parse_htif_args(self, args):
        for arg in args:
            if arg.startswith("+init_write=0x"):
                d = arg.find(":0x")
                if d == -1:
                    raise ValueError("Improperly formatted +init_write argument")
                addr = int(arg[14:d], 16)
                val = int(arg[d + 3:], 16)
                access = {'address': addr, 'stdata': val, 'store': True}
                self.init_accesses.append(access)
            if arg.startswith("+init_read=0x"):
                addr = int(arg[13:], 16)
                access = {'address': addr, 'stdata': 0, 'store': False}
                self.init_accesses.append(access)
            if arg.startswith("+no_hart0_msip"):
                self.write_hart0_msip = False

    def perform_init_accesses(self):
        for p in self.init_accesses:
            if p['store']:
                print(f"Writing {p['address']:x} with {p['stdata']:x}")
                self.write_chunk(p['address'], 4, p['stdata'])
                print(f"Done writing {p['address']:x} with {p['stdata']:x}")
            else:
                print(f"Reading {p['address']:x} ...")
                rdata = self.read_chunk(p['address'], 4)
                print(f" got {rdata:x}")