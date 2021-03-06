#
# TODO
#
# Need to add code to handle pulling the password and username from the credential variable
#
Function Enable-ApplicationServicesLog
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .LINK
            http://blogs.technet.com/b/sateesh-arveti/archive/2011/03/11/powershell-script-to-enable-iis-configuration-auditing.aspx
        .LINK
            http://technet.microsoft.com/en-us/library/cc732848(WS.10).aspx
    #>
    
    Param
    (
    [string]$AppServicesLog,
    [string]$ComputerName,
    [string]$Credentials
    )
    
    Begin
    {
        $ProcessStart = New-Object System.Diagnostics.ProcessStartInfo
        $ProcessStart.FileName = "C:\Windows\System32\wevtutil.exe"        
        $ProcessStart.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
        }
    Process
    {
        if ($ComputerName -eq $null)
        {
            $ProcessStart.Arguments = " set-log $($AppServicesLog) /e:true"
            }
        else
        {
            $ProcessStart.Arguments = " set-log $($AppServicesLog) /e:true /r:$($ComputerName) /u:$($UserName) /p:$($Password)"
            }
        $Process = [System.Diagnostics.Process]::Start($ProcessStart)
        }
    End
    {
        Return $Process
        }
}