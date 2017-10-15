@echo off
pushd .
set target_dir=%1
if "%target_dir%"=="" set target_dir=..
if not exist %target_dir%\__icon_resources (
	echo You did not install icons. Nothing to uninstall.
) else (
	for /f "delims=:" %%i in (config) do (
		echo Removing %target_dir%\%%i\Desktop.ini
		if exist %target_dir%\%%i\Desktop.ini (
			attrib -S -H %target_dir%\%%i\Desktop.ini
			del /f/q %target_dir%\%%i\Desktop.ini
		) else (
			call echo:    %target_dir%\%%i\Desktop.ini not found, thus omitted.
		)
		if exist %target_dir%\__icon_resources\old_desktop_ini\%%i (
			call echo:    Restore old Desktop.ini ...
			move "%target_dir%\__icon_resources\old_desktop_ini\%%i\Desktop.ini" "%target_dir%\%%i\Desktop.ini" >nul
			attrib +S +H %target_dir%\%%i\Desktop.ini
		)
	)
	attrib -S -H %target_dir%\__icon_resources
	rd /q/s %target_dir%\__icon_resources
)
for %%i in (%*) do (
	if "%%i"=="-s" goto :end
)
call echo:
pause
goto :end

:end
popd