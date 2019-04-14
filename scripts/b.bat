@echo off
rem build asm
set NAME=%1
cd %NAME%
..\masm %NAME%.asm;
..\link %NAME%.obj;
echo.
%NAME%.exe
echo.
cd ..
