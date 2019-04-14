@echo off
rem debug asm
set NAME=%1
cd %NAME%
..\debug %NAME%.exe
cd ..
