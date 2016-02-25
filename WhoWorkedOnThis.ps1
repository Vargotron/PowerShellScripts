[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$DomainFilter = ".*",
    [Parameter(Mandatory=$False)]
    [int]$Depth = 2
)
RoboCopy . NULL /L /S /NDL /XX /NC /NS /NJH /NJS /FP /XA:H /XD .git /Lev:$Depth |
ForEach {
	git --no-pager log -- $_ |
	ForEach {
		If ($_ -Match "^Author: (.*) <(.*)>$") {
			$matches[2]
		}
	}
} |
Sort-Object |
Get-Unique |
Select-String -Pattern $DomainFilter