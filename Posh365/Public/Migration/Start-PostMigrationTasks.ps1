function Start-PostMigrationTasks {

    [CmdletBinding(DefaultParameterSetName = 'SharePoint')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'SharePoint')]
        [ValidateNotNullOrEmpty()]
        [string]
        $SharePointURL,

        [Parameter(Mandatory, ParameterSetName = 'SharePoint')]
        [ValidateNotNullOrEmpty()]
        [string]
        $ExcelFile,

        [Parameter(Mandatory, ParameterSetName = 'CSV')]
        [ValidateNotNullOrEmpty()]
        [string]
        $MailboxCSV,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Tenant,

        [Parameter()]
        [switch]
        $AddressBookPolicy

    )
    end {
        if ($Tenant -notmatch '.mail.onmicrosoft.com') {
            $Tenant = '{0}.mail.onmicrosoft.com' -f $Tenant
        }
        switch ($PSCmdlet.ParameterSetName) {
            'SharePoint' {
                $UserChoice = Import-SharePointExcelDecision -SharePointURL $SharePointURL -ExcelFile $ExcelFile -Tenant $Tenant
            }
            'CSV' {
                $UserChoice = Import-MailboxCsvDecision -MailboxCSV $MailboxCSV
            }
        }

        if ($UserChoice -ne 'Quit' ) {
            Connect-Cloud -Tenant $Tenant -ExchangeOnline
            if ($UserChoice) {
                if ($AddressBookPolicy) {
                    $UserChoice | Sync-AddressBookPolicy
                }
            }
        }
    }
}
