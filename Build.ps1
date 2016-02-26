<#
    Build.ps1
    ----------

    Calls the specified version of MSBuild.exe against the targeted solutions. Build options can be passed to
    MSBuild via the -BuildOptions parameter. If the ResetIIS flag is set, then IIS will be reset after the
    build(s) complete.
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True)]
    [string]$MSBuildPath = $(throw "Please specify the full path to MSBuild.exe with the -MSBuildPath parameter."),
    [Parameter(Mandatory=$True)]
    [string[]]$TargetSolutions = $(throw "Please specify the target solution(s) to be built with the -TargetSolutions parameter."),
    [Parameter(Mandatory=$False)]
    [string]$BuildOptions = "",
    [Parameter(Mandatory=$False)]
    [switch]$ResetIIS = $False
)

ForEach ($solution in $TargetSolutions) {
    If ($BuildOptions -Eq "") {
        $buildCommand = "& " + $MSBuildPath + " " + $solution
    } Else {
        $buildCommand = "& " + $MSBuildPath + " " + $BuildOptions + " " + $solution
    }
    
    Write-Host "[BUILD $solution]" -ForegroundColor "Green"

    Invoke-Expression $buildCommand
}

If ($ResetIIS) {
    Write-Host "[RESET IIS]" -ForegroundColor "Green"
    iisreset
}
