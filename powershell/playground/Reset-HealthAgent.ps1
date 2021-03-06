<#
    .SYNOPSIS
        Reset HealthAgent on a computer that is showing 'Not Monitored'
    .DESCRIPTION
        This script was created to resolve an issue where several servers
        that are agent managed show up as 'Not Monitored' after an extended
        maintenance window. The script performs three actions:
            - Stop the HealthService
            - Delete the Heatlh Service Store folder and contents
            - Start the HealthService
        This should reset things so the computer will show up again. The
        code was based off a blog post I read. See the Link section for the URL.
    .PARAMETER ComputerName
        One or more computers to perform this action on.
    .EXAMPLE
        .\Reset-HealthAgent.ps1 -ComputerName server-01
        
        Description
        -----------
        This is the basic syntax
    .EXAMPLE
        "Server-01","Server-02" |.\Reset-HealthAgent.ps1 -Verbose
        
        Description
        -----------
        This example shows piping multiple objects into the script, as
        well as using the -Verbose flag to have the script report on it's 
        progress.
    .NOTES
        ScriptName : Reset-HealthAgent.ps1
        Created By : jspatton
        Date Coded : 12/28/2011 09:17:32
        ScriptName is used to register events for this script
        LogName is used to determine which classic log to write to
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
    .LINK
        http://scripts.patton-tech.com/wiki/PowerShell/Production/Reset-HealthAgent.ps1
    .LINK
        http://www.shockwave.me.uk/?p=73
#>
[cmdletbinding()]
Param
    (
    [Parameter(ValueFromPipeline=$true)]
    [string]$ComputerName
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
        $Credentials = Get-Credential
        }
Process
    {
        foreach ($Computer in $ComputerName)
        {
            $Computer
            try
            {
                Write-Verbose "Stopping HealthService"
                $Retval = (Get-WmiObject -ComputerName $Computer -Credential $Credentials -ErrorAction Stop -Class Win32_Service `
                    -Filter "Name='HealthService'").InvokeMethod("StopService",$null)
                if ($RetVal -eq 0)
                {
                    Write-Verbose "HealthService Stopped"
                    }
                }
            catch
            {
                $Message = $Error[0].Exception
                Write-Verbose $Message
                Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                }
            try
            {
                Write-Verbose "Removing Health Service Store"
                Remove-Item -Path "\\$($Computer)\c$\Program Files\System Center Operations Manager 2007\Health Service State\Health Service Store" `
                    -Recurse -ErrorAction Stop
                Write-Verbose "Health Service Store Removed"
                }
            catch
            {
                $Message = $Error[0].Exception
                Write-Verbose $Message
                Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                }
            try
            {
                Write-Verbose "Starting HealthService"
                $Retval = (Get-WmiObject -ComputerName $Computer -Credential $Credentials -ErrorAction Stop  -Class Win32_Service `
                    -Filter "Name='HealthService'").InvokeMethod("StartService",$null)
                if ($RetVal -eq 0)
                {
                    Write-Verbose "HealthService Started"
                    }
                }
            catch
            {
                $Message = $Error[0].Exception
                Write-Verbose $Message
                Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                }
            }
        }
 End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message	
        }
