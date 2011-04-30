Function Get-RDPLoginEvents
{
    <#
        .SYNOPSIS
            Return Remote Desktop login attempts
        .DESCRIPTION
            This function returns login attempts from the Microsoft Windows TerminalServices RemoteConnectionManager 
            log. The specific events are logged as EventID 1149, and they are logged whether or not the user actually
            gets to the desktop.
        .PARAMETER ComputerName
            This is the NetBIOS name of the computer to pull events from.
        .PARAMETER Credentials
            A user account with the ability to retreive these events.
        .EXAMPLE
            Get-RDPLoginEvents -Credentials $Credentials |Export-Csv -Path C:\logfiles\RDP-Attempts.csv
            
            Description
            -----------
            This example show piping the output of the function to Export-Csv to create a file suitable for import
            into Excel, or some other spreadsheet software.
        .EXAMPLE
            Get-RDPLoginEvents -Credentials $Credentials -ComputerName MyPC |Format-Table

            SourceNetworkAddress        Domain           TimeCreated                User
            --------------------        ------           -----------                ----
            192.168.1.1                 MyPC...          4/30/2011 8:20:02 AM       Administrator...
            192.168.1.1                 MyPC...          4/28/2011 4:53:01 PM       Administrator...
            192.168.1.1                 MyPC...          4/21/2011 2:01:42 PM       Administrator...
            192.168.1.1                 MyPC...          4/19/2011 11:42:59 AM      Administrator...
            192.168.1.1                 MyPC...          4/19/2011 10:30:52 AM      Administrator...

            Description
            -----------
            This example shows piping the output to Format-Table
        .NOTES
            The Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational needs to be enabled
            The user account supplied in $Credentials needs to have permission to view this log
            No output is returned if the log is empty.
        .LINK
    #>
    
    Param
        (
            $ComputerName = (& hostname),
            $Credentials
        )
    If ((Get-WinEvent -ListLog Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational `
    -ComputerName $ComputerName -Credential $Credential).RecordCount -gt 0)
    {
        $Events = Get-WinEvent -LogName Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational `
        -ComputerName $ComputerName -Credential $Credential |Where-Object {$_.ID -eq 1149} |Select-Object -Property Message, TimeCreated

        $LoginAttempts = @()
        ForEach ($Message in $Events)
        {
            $Details = $Message.Message
            $Attempt = New-Object PSObject -Property @{
                User = $Details.Substring($Details.IndexOf("User:")+6,(($Details.IndexOf("`n",$Details.IndexOf("User:")))-($Details.IndexOf("User:")+6)))
                Domain = $Details.Substring($Details.IndexOf("Domain:")+8,(($Details.IndexOf("`n",$Details.IndexOf("Domain:")))-($Details.IndexOf("Domain:")+8)))
                SourceNetworkAddress = $Details.Substring($Details.IndexOf("Source Network Address:")+24)
                TimeCreated = $Message.TimeCreated
            }
            $LoginAttempts += $Attempt
        }
    }
    Return $LoginAttempts
}