function SendAlertEmail($Body) {

    $From = "derek.johnson01@mymail.champlain.edu"
    $To = "derek.johnson01@mymail.champlain.edu"
    $Subject = "Suspicious Activity"

    $Password = "lzkzgotwnnihwkrz" | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential

}