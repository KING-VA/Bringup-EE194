@echo off
echo FPGA Configure...

REM ########################################################################
REM # Download sof file
REM ########################################################################
@ set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin
@ if not exist "%QUARTUS_BIN%" set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin64

if not exist "%QUARTUS_BIN%\\qpro.exe" (
	echo Your default Quartus specified by system variable QUARTUS_ROOT must be Quartus Pro. Edition for programming Agilex FPGA device.
	goto :Exit
)
 
 %QUARTUS_BIN%\\quartus_pfg -c Agilex_SOM.sof Agilex_SOM.jic -o device=MT25QU01G -o flash_loader=AGFB014R24B2E2V -o mode=ASX4 
pause