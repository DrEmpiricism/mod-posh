<#
    .SYNOPSIS
        Template script
    .DESCRIPTION
        This script sets up the basic framework that I use for all my scripts.
    .PARAMETER
    .EXAMPLE
    .NOTES
        ScriptName : CreateLicensePortMonitors.ps1
        Created By : jspatton
        Date Coded : 12/07/2011 12:57:17
        ScriptName is used to register events for this script
        LogName is used to determine which classic log to write to
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
    .LINK
        http://scripts.patton-tech.com/wiki/PowerShell/Production/CreateLicensePortMonitors.ps1
#>
Param
    (
        $CsvFile = 'C:\TEMP\ports.csv'
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
        . 'C:\scripts\powershell\playground\FlexLMLibrary.ps1'
        $Licenses = Import-Csv $CsvFile
        $licenses = $licenses |Sort-Object -Property LocalPort -Unique
        }
Process
    {
        $Report = @()
        foreach ($item in $Licenses)
        {
            try
            {
                $Report += Get-FlexLMStatus -QueryPort $item.LocalPort -LicenseServer license1 -ErrorAction stop -Verbose
                }
            catch
            {
                #Write-Host $Error[0]
                }
            }
        $Report = $Report |Sort-Object -Property LicensePort -Unique
        foreach ($Item in $Report)
        {
            C:\TEMP\CreatePortMonitoring.ps1 -serverName $Item.LicenseServer -portNumber $Item.LicensePort -pollIntervalSeconds 120 -watcherNodes node0.soecs.ku.edu -displayName "$($Item.Daemon)_LicensePort" -targetMp 'Engineering_MP'
            }
        }
End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message	
        }