$mailboxes = Get-Mailbox -Filter {RecipientTypeDetails -eq 'UserMailbox'} -ResultSize Unlimited

$results = @()

foreach ($mailbox in $mailboxes) {
    $junkEmailPolicy = Get-MailboxJunkEmailConfiguration -Identity $mailbox.Identity
    if (-not $junkEmailPolicy.ContactsTrusted) {
        $results += [PSCustomObject]@{
            DisplayName = $mailbox.DisplayName
            UserPrincipalName = $mailbox.UserPrincipalName
            ContactsTrusted = $junkEmailPolicy.ContactsTrusted
        }
    }
}

$results

$results | Export-Csv -Path ".\TrustedContactsDisabledUsers.csv" -NoTypeInformation
