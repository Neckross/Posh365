using namespace System.Management.Automation.Host
function Add-X500FromContact {
    [CmdletBinding()]
    param (
        [Parameter()]
        $OnPremExchangeServer,

        [Parameter()]
        [switch]
        $DeleteExchangeCreds,

        [Parameter()]
        [switch]
        $DontViewEntireForest
    )

    if ($DeleteExchangeCreds) {
        Connect-Exchange -DeleteExchangeCreds:$true
        continue
    }
    while (-not $OnPremExchangeServer ) {
        Write-Host "Enter the name of the Exchange Server. Example: ExServer01.domain.com" -ForegroundColor Cyan
        $OnPremExchangeServer = Read-Host "Exchange Server Name"
    }
    while (-not $ConfirmExServer) {
        $Yes = [ChoiceDescription]::new('&Yes', 'ExServer: Yes')
        $No = [ChoiceDescription]::new('&No', 'ExServer: No')
        $Options = [ChoiceDescription[]]($Yes, $No)
        $Title = 'Specified Exchange Server: {0}' -f $OnPremExchangeServer
        $Question = 'Is this correct?'
        $YN = $host.ui.PromptForChoice($Title, $Question, $Options, 1)
        switch ($YN) {
            0 { $ConfirmExServer = $true }
            1 {
                Write-Host "`r`nEnter the name of the Exchange Server. Example: ExServer01.domain.com" -ForegroundColor Cyan
                $OnPremExchangeServer = Read-Host "Exchange Server Name"
            }
        }
    }
    Get-PSSession | Remove-PSSession
    Write-Host "`r`nConnecting to Exchange On-Premises: $OnPremExchangeServer`r`n" -ForegroundColor Cyan
    Connect-Exchange -Server $OnPremExchangeServer -DontViewEntireForest:$DontViewEntireForest

    Get-DestinationRemoteMailboxHash

    $PoshPath = (Join-Path -Path ([Environment]::GetFolderPath('Desktop')) -ChildPath Posh365 )

    if (-not ($null = Test-Path $PoshPath)) {
        $null = New-Item $PoshPath -type Directory -Force:$true -ErrorAction SilentlyContinue
    }
    $TargetHash = Join-Path -Path $PoshPath -ChildPath 'TargetHash.xml'
    $SourceHash = Join-Path -Path $PoshPath -ChildPath 'SourceHash.xml'
    if (-not (Test-Path $TargetHash) -or -not (Test-Path $SourceHash)) {
        Write-Host "Missing one or both files" -ForegroundColor Red
        Write-Host "1) $TargetHash" -ForegroundColor Cyan
        Write-Host "2) $SourceHash" -ForegroundColor Cyan
        return
    }
    else {
        $Target = Import-Clixml $TargetHash
        $Source = Import-Clixml $SourceHash
    }

    $MatchingPrimaryCSV = Join-Path -Path $PoshPath -ChildPath 'MatchingPrimary.csv'
    $ResultObject = Compare-AddX500FromContact -Target $Target -Source $Source

    $ResultObject | Out-GridView -Title "Results of comparison between source and target"
    $ResultObject | Export-Csv $MatchingPrimaryCSV -NoTypeInformation -Encoding UTF8
    Write-Host "Results have been exported to: " -ForegroundColor Cyan -NoNewline
    Write-Host "$MatchingPrimaryCSV" -ForegroundColor Green

    $Yes = [ChoiceDescription]::new('&Yes', 'WriteX500: Yes')
    $No = [ChoiceDescription]::new('&No', 'WriteX500: No')
    $Options = [ChoiceDescription[]]($Yes, $No)
    $Title = 'The results comparing source ?'
    $Question = 'Please make a selection'
    $YesNo = $host.ui.PromptForChoice($Title, $Question, $Options, 1)
    switch ($YesNo) {
        0 {
            $AddProxyList = Invoke-Addx500FromContact -MatchingPrimary $ResultObject | Out-GridView -OutputMode Multiple -Title "Choose Recipients to add X500s"
            Add-ProxyToRemoteMailbox -AddProxyList $AddProxyList
        }
        1 { return }
    }
}
