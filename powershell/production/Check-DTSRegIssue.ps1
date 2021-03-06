<#
    .SYNOPSIS
        Check for the existence of the RealTimeIsUniversal registry key
    .DESCRIPTION
        This script checks a given computer for the existence of the RealTimeIsUniversal
        registry key. This key if it exists could potentially cause a computer to
        become unresponsive.
        
        To resolve this issue please see the the additional links in this script for
        instructions.
    .PARAMETER Credentials
        The username and password of an accoun that has administrative rights on the remote computer
    .PARAMETER ComputerName
        The name of the computer to check.
    .EXAMPLE
        .\Check-DTSRegIssue.ps1 -ComputerName Server01
        
        Found ComputerName RealTimeIsUnviersal
        ----- ------------ -------------------
        False Server01                        
        
        Description
        -----------
        This shows the basic syntax of the script and sample output.
    .EXAMPLE
        'Server01','Server02' |.\Check-DTSRegIssue.ps1 -Credentials $Credentials

        Found ComputerName RealTimeIsUnviersal
        ----- ------------ -------------------
        False Server01                        
        False Server02                        
        
    .NOTES
        ScriptName : Check-DTSRegIssue.ps1
        Created By : jspatton
        Date Coded : 03/09/2012 16:00:01
        ScriptName is used to register events for this script
        LogName is used to determine which classic log to write to
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
    .LINK
        https://code.google.com/p/mod-posh/wiki/Production/Check-DTSRegIssue.ps1
    .LINK
        http://blogs.technet.com/b/askds/archive/2012/03/09/unresponsive-servers-due-to-dst-and-an-unsupported-registry-key.aspx
    .LINK
        http://support.microsoft.com/default.aspx?scid=kb;EN-US;2687252
#>
[CmdletBinding()]
Param
    (
    $Credentials = (Get-Credential),
    [Parameter(ValueFromPipeline=$true,Position=1)]$ComputerName
    )
Begin
    {
        $ScriptName = $MyInvocation.MyCommand.ToString()
        $LogName = "Application"
        $ScriptPath = $MyInvocation.MyCommand.Path
        $Username = $env:USERDOMAIN + "\" + $env:USERNAME
 
        New-EventLog -Source $ScriptName -LogName $LogName -ErrorAction SilentlyContinue
 
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
        
        #	Dotsource in the functions you need.
        $Found = $false
        }
Process
    {
        $ScriptBlock = {Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation |Select-Object RealTimeIsUniversal}
        $ReturnValue = Invoke-Command -ComputerName $ComputerName -Credential $Credentials -ScriptBlock $ScriptBlock
        if ($ReturnValue.RealTimeIsUniversal.Length -gt 0)
        {
            $Found = $true
            }
        
        New-Object -TypeName PSObject -Property @{
            ComputerName = $ReturnValue.PSComputerName
            Found = $Found
            RealTimeIsUnviersal = $ReturnValue.RealTimeIsUniversal
            }
        }
End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message	
        }