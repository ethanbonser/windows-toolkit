@echo off
:: Auto-Elevate to Admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator permissions...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title Ethan's Ultimate Windows Toolkit
color 0A

:menu
cls
echo ================================================
echo        ETHAN'S WINDOWS TOOLKIT MENU
echo ================================================
echo.
echo  1.  Deep System Cleaner
echo  2.  Empty Recycle Bin
echo  3.  Clear RAM Cache
echo  4.  Fix Network Issues
echo  5.  Run Disk Cleanup
echo  6.  Scan System Files (SFC)
echo  7.  Open Hidden Windows Tools
echo  8.  List Installed Programs
echo  9.  Force Close Unresponsive Tasks
echo 10.  Flush DNS Cache Only
echo 11.  Toggle Dark/Light Mode
echo 12.  Lock PC
echo  0.  Exit
echo.

set /p choice=Enter your choice (0-12): 

if "%choice%"=="1" goto cleaner
if "%choice%"=="2" goto recycle
if "%choice%"=="3" goto ram
if "%choice%"=="4" goto network
if "%choice%"=="5" goto diskcleanup
if "%choice%"=="6" goto sfc
if "%choice%"=="7" goto wintools
if "%choice%"=="8" goto listprograms
if "%choice%"=="9" goto forceclose
if "%choice%"=="10" goto flushdns
if "%choice%"=="11" goto darkmode
if "%choice%"=="12" goto lock
if "%choice%"=="0" exit

goto menu

:cleaner
echo Running Deep System Cleaner...
del /s /f /q %temp%\*
rd /s /q %temp%
md %temp%
del /s /f /q C:\Windows\Temp\*
del /s /f /q C:\Windows\Prefetch\*
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*"
echo off | clip
rd /s /q C:\$Recycle.Bin
ipconfig /flushdns
echo Done!
pause
goto menu

:recycle
rd /s /q C:\$Recycle.Bin
echo Recycle Bin emptied.
pause
goto menu

:ram
%windir%\System32\rundll32.exe advapi32.dll,ProcessIdleTasks
echo RAM cache cleared (background tasks flushed).
pause
goto menu

:network
ipconfig /release
ipconfig /renew
ipconfig /flushdns
netsh winsock reset
netsh int ip reset
echo Network stack reset. Restart may be required.
pause
goto menu

:diskcleanup
cleanmgr /sagerun:1
pause
goto menu

:sfc
sfc /scannow
pause
goto menu

:wintools
start msinfo32
start perfmon
start eventvwr
start taskmgr
start cleanmgr
pause
goto menu

:listprograms
wmic product get name > "%userprofile%\Desktop\Installed_Programs.txt"
echo Installed program list saved to Desktop.
pause
goto menu

:forceclose
taskkill /f /fi "status eq not responding"
echo Unresponsive tasks closed.
pause
goto menu

:flushdns
ipconfig /flushdns
echo DNS cache flushed.
pause
goto menu

:darkmode
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme | find "0x0" >nul
if %errorlevel%==0 (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f
  echo Switched to Light Mode.
) else (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f
  echo Switched to Dark Mode.
)
taskkill /f /im explorer.exe & start explorer.exe
pause
goto menu

:lock
rundll32.exe user32.dll,LockWorkStation
goto menu
