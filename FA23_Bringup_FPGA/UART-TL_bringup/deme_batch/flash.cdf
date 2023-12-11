
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Cfg)
		Device PartName(AGFB014R24B2E2V) Path("./") File("Agilex_SOM.jic") MfrSpec(OpMask(1) SEC_Device(MT25QU01G) Child_OpMask(1 3));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
