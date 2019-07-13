Function Resume-MailboxMove {
    <#
    .SYNOPSIS
    Resume Mailbox Move

    .DESCRIPTION
    Resume Mailbox Move

    .EXAMPLE
    Resume-MailboxMove

    .EXAMPLE
    Resume-MailboxMove -DontAutoComplete

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [switch]
        $DontAutoComplete
    )
    $UserChoice = Import-MailboxMoveDecision -NotCompleted
    if ($UserChoice -ne 'Quit' ) {
        $ResumeSplat = @{
            Confirm = $false
        }
        if ($DontAutoComplete) {
            $ResumeSplat.Add('SuspendWhenReadyToComplete', $True)
        }
        foreach ($User in $UserChoice) {
            Resume-MoveRequest -Identity $User.Guid @ResumeSplat
        }
    }
}