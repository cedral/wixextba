@echo off

echo Configuring environment...
set MSBUILD="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
set WIX=D:\WiX\WiX3.7\
echo.

set outdir=%~dp0build

echo Removing release folder...
Call :DeleteDir "%outdir%"
Call :DeleteDir "ipch"

%MSBUILD% /p:MajorBuildNumber=3 /p:MinorBuildNumber=7 inc\Version.proj
%MSBUILD% BalExtensionExt.sln @build37.rsp /t:Rebuild /p:Configuration=Release /p:Platform="Mixed Platforms" /p:RunCodeAnalysis=false /p:DefineConstants="TRACE;WIX37" /p:OutDir="%outdir%\\" /l:FileLogger,Microsoft.Build.Engine;logfile=build.log
if %errorlevel% neq 0 (
	echo Build failed
	pause
	goto :EOF
)

pushd Examples
Call Build
popd

echo.

pause

goto :EOF

REM *****************************************************************
REM End of Main
REM *****************************************************************


REM *****************************************************************
REM Delete/create directory
REM *****************************************************************
:DeleteDir

rd %1% /q/s 2>nul 1>nul
md %1% 2>nul 1>nul
if exist %1% goto CREATED
echo Couldn't create %1% directory
pause
goto :EOF
:CREATED

goto :EOF