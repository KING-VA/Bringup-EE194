@echo off
echo FPGA Configure...


set project_jic="Agilex_SOM.jic"


REM ########################################################################
REM # Download sof file
REM ########################################################################
@ set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin
@ if not exist "%QUARTUS_BIN%" set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin64

if not exist "%QUARTUS_BIN%\\qpro.exe" (
	echo Your default Quartus specified by system variable QUARTUS_ROOT must be Quartus Pro. Edition for programming Agilex FPGA device.
	goto :Exit
)

%QUARTUS_BIN%\\quartus_pgm.exe -m jtag -c 1 -o "pvi;%project_jic%"

:Exit

pause

