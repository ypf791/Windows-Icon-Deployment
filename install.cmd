;@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
pushd .
set target_dir=%1
if "%target_dir%"=="" set target_dir=..
if exist %target_dir%\__icon_resources (
	echo Please run uninstall first before installing the icons.
) else (
	md %target_dir%\__icon_resources
	md %target_dir%\__icon_resources\icon_src
	echo Copy icons to %target_dir%\__icon_resources\icon_src ...
	pushd .
	cd %target_dir%\__icon_resources\icon_src
	copy "%~p0icon_src\*"
	popd
	attrib +S +H %target_dir%\__icon_resources
	md %target_dir%\__icon_resources\old_desktop_ini
	for /f "usebackq tokens=1,2,3 delims=:" %%i in ("%~p0config") do (
		echo Installing %target_dir%\%%i\Desktop.ini ...
		if not exist %target_dir%\%%i (
			call echo:    %target_dir%\%%i not found, thus omitted.
		) else (
			if exist %target_dir%\%%i\Desktop.ini (
				echo Found %target_dir%\%%i\Desktop.ini
				call echo:    Backup old file ...
				md %target_dir%\__icon_resources\old_desktop_ini\%%i
				attrib -S -H %target_dir%\%%i\Desktop.ini
				move "%target_dir%\%%i\Desktop.ini" "%target_dir%\__icon_resources\old_desktop_ini\%%i\Desktop.ini" >nul
				call echo:    Try to append IconResource to section [.ShellClassInfo] ...
				set __append_stage=0
				for /f "usebackq tokens=*" %%a in ("%target_dir%\__icon_resources\old_desktop_ini\%%i\Desktop.ini") do (
					if !__append_stage! EQU 0 (
						echo %%a >> %target_dir%\%%i\Desktop.ini
						if "%%a"=="[.ShellClassInfo]" set __append_stage=1
					) else (
						if !__append_stage! EQU 1 (
							for /f "tokens=1,2,3 delims==," %%p in ("%%a") do (
								if "%%p"=="IconResource" (
									call echo:    IconResource already exists. Override the value.
									echo IconResource=%target_dir%\__icon_resources\icon_src\%%j,%%k >> %target_dir%\%%i\Desktop.ini
									set __append_stage=2
								) else (
									set tmp_var=%%p
									if "!tmp_var:~0,1!"=="[" (
										call echo:    IconResource not found. Append as new key.
										echo IconResource=%target_dir%\__icon_resources\icon_src\%%j,%%k >> %target_dir%\%%i\Desktop.ini
										set __append_stage=2
									)
									echo %%a >> %target_dir%\%%i\Desktop.ini
								)
							)
							set __append_stage=2
						) else (
							echo %%a >> %target_dir%\%%i\Desktop.ini
						)
					)
				)
			) else (
				echo [.ShellClassInfo] >> %target_dir%\%%i\Desktop.ini
				echo IconResource=%target_dir%\__icon_resources\icon_src\%%j,%%k >> %target_dir%\%%i\Desktop.ini
				attrib +S +H %target_dir%\%%i\Desktop.ini
			)
			attrib +R %target_dir%\%%i
		)
	)
)
for %%i in (%*) do (
	if "%%i"=="-s" goto :end
)
call echo:
pause
goto :end

:end
popd
ENDLOCAL