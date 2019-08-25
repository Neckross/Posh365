function New-MWMailboxMove {
    <#
    .SYNOPSIS
    Sync Mailboxes from On-Premises Exchange to Exchange Online
    Either CSV or Excel file from SharePoint can be used

    .DESCRIPTION
    Sync Mailboxes from On-Premises Exchange to Exchange Online
    Either CSV or Excel file from SharePoint can be used

    .PARAMETER SharePointURL
    Sharepoint url ex. https://fabrikam.sharepoint.com/sites/Contoso

    .PARAMETER ExcelFile
    Excel file found in "Shared Documents" of SharePoint site specified in SharePointURL
    ex. "Batchex.xlsx"
    Minimum headers required are: BatchName, UserPrincipalName

    .PARAMETER MailboxCSV
    Path to csv of mailboxes. Minimum headers required are: BatchName, UserPrincipalName

    .PARAMETER RemoteHost
    This is the on-premises endpoint where the source mailboxes reside ex. mail.contoso.com

    .PARAMETER Tenant
    This is the tenant domain - where you are migrating to. Ex. if tenant is contoso.mail.onmicrosoft.com use contoso

    .PARAMETER GroupsToAddUserTo
    Provide one or more Active Directory Groups to add each user chosen to. -GroupsToAddUserTo "Human Resources", "Accounting"
    Requires AD Module. This is optional

    .EXAMPLE
    New-MWMailboxMove -RemoteHost mail.contoso.com -Tenant Contoso -MailboxCSV c:\scripts\batches.csv -GroupsToAddUserTo "Office 365 E3"

    .EXAMPLE
    New-MWMailboxMove -SharePointURL 'https://fabrikam.sharepoint.com/sites/Contoso' -ExcelFile 'Batches.xlsx' -RemoteHost mail.contoso.com -Tenant Contoso

    .NOTES
    General notes
    #>

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
        $Project,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $TargetEmailSuffix
    )
    end {
        switch ($PSCmdlet.ParameterSetName) {
            'SharePoint' {
                $SharePointSplat = @{
                    SharePointURL = $SharePointURL
                    ExcelFile     = $ExcelFile
                    Tenant        = $Project
                }
                $UserChoice = Import-BTSharePointExcelDecision @SharePointSplat
            }
            'CSV' {
                $UserChoice = Import-MailboxCsvDecision -MailboxCSV $MailboxCSV
            }
        }
        if ($UserChoice -ne 'Quit' ) {
            $Sync = @{
                TargetEmailSuffix = $TargetEmailSuffix
            }
            $UserChoice | Invoke-NewMWMailboxMove @Sync | Out-GridView -Title "Results of MigrationWiz New Mailbox Move"
        }
    }
}