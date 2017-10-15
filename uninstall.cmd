rem author:	ypf791
rem date:	2017/10/15

@echo off
pushd .

set config=%~p0config

if "%1"=="" ( cd .. ) else ( cd %1 )

if not exist __icon_resources (
	echo You did not install icons. Nothing to uninstall.
) else (
	for /f "usebackq delims=:" %%i in ("%config%") do (
		echo Removing %%i\Desktop.ini
		if exist %%i\Desktop.ini (
			attrib -S -H %%i\Desktop.ini
			del /f/q %%i\Desktop.ini
		) else (
			call echo:    %%i\Desktop.ini not found, thus omitted.
		)
		if exist __icon_resources\old_desktop_ini\%%i (
			call echo:    Restore old Desktop.ini ...
			move "__icon_resources\old_desktop_ini\%%i\Desktop.ini" "%%i\Desktop.ini" >nul
			attrib +S +H %%i\Desktop.ini
		)
	)
	attrib -S -H __icon_resources
	rd /q/s __icon_resources
)
for %%i in (%*) do (
	if "%%i"=="-s" goto :end
)
call echo:
pause
goto :end

:end
popd