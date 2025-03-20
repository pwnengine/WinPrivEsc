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

echo Script completed.
pause
