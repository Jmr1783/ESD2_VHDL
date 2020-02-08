ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO PRESS 1-4 to select your task, or 5 to EXIT.
ECHO ...............................................
ECHO.
ECHO 1 - Compile VHDL
ECHO 2 - Simulate VHDL
ECHO 3 - Blow away temp files
ECHO 4 - Create BIN
ECHO 5 - EXIT
ECHO.
SET /P M=Type 1, 2, 3, 4, or 5 then press ENTER:
IF %M%==1 GOTO VIVADO
IF %M%==2 GOTO SIM
IF %M%==3 GOTO CLEAN
IF %M%==4 GOTO FLASH
IF %M%==4 GOTO EOF
:VIVADO
del vivado.jou
del vivado.log
vivado -notrace -mode batch -source project.tcl 
EXIT
:SIM
ECHO Not supported currently
GOTO MENU
:CLEAN
vivado -notrace -mode batch -source cleanup.tcl
EXIT
:FLASH
vivado -notrace -mode batch -source packup.tcl
EXIT

