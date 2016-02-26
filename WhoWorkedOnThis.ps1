<#
    WhoWorkedOnThis.ps1
    -------------------

    Scans the current git repository (recursively to a depth of 2 or the value given for the -Depth parameter) and
    returns a list of all commit author email addresses, excluding merge commits. Use -DomainFilter to only return
    author email addresses from a particular domain (include the @).
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$DomainFilter = ".*",
    [Parameter(Mandatory=$False)]
    [int]$Depth = 2
)
RoboCopy . NULL /L /S /NDL /XX /NC /NS /NJH /NJS /FP /XA:H /XD .git /Lev:$Depth |
ForEach {
	git --no-pager log --no-merges -- $_ |
	ForEach {
		If ($_ -Match "^Author: (.*) <(.*)>$") {
			$matches[2]
		}
	}
} |
Sort-Object |
Get-Unique |
Select-String -Pattern $DomainFilter