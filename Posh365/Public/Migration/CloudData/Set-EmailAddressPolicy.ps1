function Set-EmailAddressPolicy {
    <#
    .SYNOPSIS
    Sets Email Address Policy of On-Prem Remote Mailboxes only (for now)
    Disables by default

    .DESCRIPTION
    Sets Email Address Policy of On-Prem Remote Mailboxes only (for now)
    Disables by default

    .PARAMETER OnPremExchangeServer
    Parameter description

    .PARAMETER DeleteExchangeCreds
    Parameter description

    .PARAMETER DontViewEntireForest
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Enable,

        [Parameter()]
        $OnPremExchangeServer,

        [Parameter()]
        [switch]
        $DeleteExchangeCreds,

        [Parameter()]
        [switch]
        $DontViewEntireForest
    )

    Connect-Exchange @PSBoundParameters -PromptConfirm
    Get-PSSession | Remove-PSSession

    $PoshPath = (Join-Path -Path ([Environment]::GetFolderPath('Desktop')) -ChildPath Posh365 )

    if (-not (Test-Path $PoshPath)) {
        $null = New-Item $PoshPath -type Directory -Force:$true -ErrorAction SilentlyContinue
    }
    $RemoteMailboxXML = Join-Path -Path $PoshPath -ChildPath 'RemoteMailbox.xml'

    if (-not (Test-Path $RemoteMailboxXML)) {
        Write-Host "Fetching Remote Mailboxes..." -ForegroundColor Cyan
        Get-RemoteMailbox -ResultSize unlimited | Select-Object * | Export-Clixml $RemoteMailboxXML
        $RemoteMailboxList = Import-Clixml $RemoteMailboxXML
        return
    }
    else {
        $RemoteMailboxList = Import-Clixml $RemoteMailboxXML | Sort-Object DisplayName, OnPremisesOrganizationalUnit
    }

    Write-Host "Choose the Remote Mailboxes to set their EmailAddressPolicyEnabled to $Enable" -ForegroundColor Black -BackgroundColor White
    Write-Host "To select use Ctrl/Shift + click (individual) or Ctrl + A (All)" -ForegroundColor Black -BackgroundColor White

    $Choice = Select-SetEmailAddressPolicy -RemoteMailboxList $RemoteMailboxList |
    Out-GridView -OutputMode Multiple -Title "Choose the Remote Mailboxes to set their EmailAddressPolicyEnabled to $Enable"
    $ChoiceCSV = Join-Path -Path $PoshPath -ChildPath ('Before set EmailAddressPolicyEnabled to {0} _ {1}.csv' -f $Enable, [DateTime]::Now.ToString('yyyy-MM-dd-hhmm'))
    $Choice | Export-Csv $ChoiceCSV -NoTypeInformation -Encoding UTF8

    if ($Choice) { Get-DecisionbyOGV } else { Write-Host "Halting as nothing was selected" ; continue }
    $Result = Invoke-SetEmailAddressPolicy $Choice

}