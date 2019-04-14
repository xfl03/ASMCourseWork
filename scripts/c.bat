@echo off
rem create asm
set NAME=%1
md %NAME%
copy template.asm %NAME%\%NAME%.asm
