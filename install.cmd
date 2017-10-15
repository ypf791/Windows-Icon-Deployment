@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
pushd .
set srcdir=%~p0icon_src
set config=%~p0config
set __use_copy=1
if "%1"=="" ( cd .. ) else ( cd %1 )
if exist __icon_resources (
	echo Found __icon_resources\
	echo Please run uninstall first before installing the icons.
) else (
	md __icon_resources
	if defined __use_copy (
		call echo Copy mode introduced. Create the folder for copies
		md __icon_resources\icon_src
	)
	md __icon_resources\old_desktop_ini
	for /f "usebackq tokens=1,2,3 delims=:" %%i in ("%~p0config") do (
		echo Installing %CD%\%%i\Desktop.ini ...
		if not exist %%i (
			call echo:    %%i not found, thus omitted.
		) else (
			call :install_one %%i %%j %%k
		)
	)
	attrib +S +H __icon_resources
)
for %%i in (%*) do (
	if "%%i"=="-s" goto :end
)
call echo:
pause
goto :end

:install_one
set icon_path=%srcdir%\%2
if defined __use_copy (
	copy "%srcdir%\%2" "__icon_resources\icon_src\%2" >nul
	set icon_path=..\__icon_resources\icon_src\%2
)
if exist %1\Desktop.ini (
	echo Found %CD%\%%i\Desktop.ini
	call echo:    Backup old file ...
	md __icon_resources\old_desktop_ini\%1
	attrib -S -H %1\Desktop.ini
	move "%1\Desktop.ini" "__icon_resources\old_desktop_ini\%1\Desktop.ini" >nul
	call echo:    Try to append IconResource to section [.ShellClassInfo] ...
	call :append_to_desktop_ini %1\Desktop.ini %icon_path%,%3
) else (
	echo [.ShellClassInfo] >> %1\Desktop.ini
	echo IconResource=%icon_path%,%3 >> %1\Desktop.ini
)
attrib +S +H %1\Desktop.ini
attrib +R %1
exit /b

:append_to_desktop_ini
set __append_stage=0
for /f "usebackq tokens=*" %%a in ("__icon_resources\old_desktop_ini\%1") do (
	if !__append_stage! EQU 0 (
		echo %%a >> %1
		if "%%a"=="[.ShellClassInfo]" set __append_stage=1
	) else (
		if !__append_stage! EQU 1 (
			for /f "tokens=1,2,3 delims==," %%p in ("%%a") do (
				if "%%p"=="IconResource" (
					call echo:    IconResource already exists. Override the value.
					echo IconResource=%2 >> %1
					set __append_stage=2
				) else (
					set tmp_var=%%p
					if "!tmp_var:~0,1!"=="[" (
						call echo:    IconResource not found. Append as new key.
						echo IconResource=%2 >> %1
						set __append_stage=2
					)
					echo %%a >> %1
				)
			)
			set __append_stage=2
		) else (
			echo %%a >> %1
		)
	)
)
exit /b

:end
popd
ENDLOCAL