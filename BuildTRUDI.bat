@ECHO OFF
ECHO(
ECHO Building TRUDI...
ECHO(
PowerShell.exe -Command "Build.ps1 -MSBuildPath \"'C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe'\" -TargetSolutions 'C:\Code\TRUDI\sourcenew\UI\UI.sln','C:\Code\TRUDI\sourcenew\Authorization\Authorization.sln','C:\Code\TRUDI\sourcenew\TechObjects\TechObjects.sln' -ResetIIS"
ECHO(
ECHO Complete.
ECHO(