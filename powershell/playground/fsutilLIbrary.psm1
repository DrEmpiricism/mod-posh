Function Get-ReparsePoints
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
            FunctionName : Get-ReparsePoints
            Created by   : jspatton
            Date Coded   : 07/23/2012 10:26:36
        .LINK
            https://code.google.com/p/mod-posh/wiki/Untitled2#Get-ReparsePoints
    #>
    [CmdletBinding()]
    Param
        (
        [string]$FilePath
        )
    Begin
    {
        if (!$principal.IsInRole("Administrators")) 
        {
            $Message = 'You need to run this from an elevated prompt'
            Write-Error $Message
            break
            }
        [bool]$isDir = $false
        Write-Verbose "Check to see if $($FilePath) exists"
        if ((Test-Path $FilePath))
        {
            Write-Verbose "Check to see if $($FilePath) is a folder"
            if ((Get-Item $FilePath).PSIsContainer)
            {
                Write-Verbose "$($FilePath) is a folder"
                [bool]$isDir = $true
                }
            }
        else
        {
            Write-Error $Error[0]
            break
            }
        if (!(Test-Path C:\Windows\System32\fsutil.exe))
        {
            Write-Error $Error[0]
            break
            }
        }
    Process
    {
        if ($isDir)
        {
            Write-Verbose "Grab all subfolders inside $($FilePath)"
            $ReparseItems = Get-ChildItem -Path $FilePath
            }
        else
        {
            Write-Verbose "Grab $($FilePath)"
            $ReparseItems = Get-Item -Path $FilePath
            }
        Write-Verbose "Checking each folder inside of $($FilePath)"
        foreach ($Item in $ReparseItems)
        {
            Write-Debug $Item.FullName
            $Output = ([string](& fsutil reparsepoint query $Item.FullName))
            if ($Output.IndexOf('Error') -eq -1)
            {
                Write-Host $Output
                }
            else
            {
                Write-Debug $Output
                }
            }
        }
    End
    {
        }
    }
Function Get-FsInfo
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
            FunctionName : Get-FsInfo
            Created by   : jspatton
            Date Coded   : 07/23/2012 11:11:13
        .LINK
            https://code.google.com/p/mod-posh/wiki/Untitled2#Get-FsInfo
    #>
    [CmdletBinding()]
    Param
        (
        [string]$FilePath,
        [ValidateSet('volumeinfo','ntfsinfo','statistics')]
        [Parameter(Mandatory=$true)]
        [string]$Command
        )
    Begin
    {
        if (!$principal.IsInRole("Administrators")) 
        {
            $Message = 'You need to run this from an elevated prompt'
            Write-Error $Message
            break
            }
        [bool]$isVol = $false
        Write-Verbose "Check to see if $($FilePath) exists"
        if ((Test-Path $FilePath))
        {
            Write-Verbose "Check to see if $($FilePath) is a folder"
            if ((Get-Item $FilePath).PSIsContainer)
            {
                Write-Verbose "$($FilePath) is a folder"
                [bool]$isVol = $true
                [string]$VolRoot = ((Get-Item $FilePath).PSDrive).Root
                }
            }
        else
        {
            Write-Error $Error[0]
            break
            }
        if (!(Test-Path C:\Windows\System32\fsutil.exe))
        {
            Write-Error $Error[0]
            break
            }
        }
    Process
    {
        if ($isVol)
        {
            $Output = (& fsutil fsinfo $Command $VolRoot)
            switch ($Command)
            {
                'statistics'
                {
                    foreach ($Item in $Output)
                    {
                        if ($Item -ne "")
                        {
                            $Report += @{$Item.Substring(0,($Item.IndexOf(' :'))).Trim() = `
                                        $item.Substring(23,$Item.Length -23)}
                            }
                        }
                    }
                'ntfsinfo'
                {
                    foreach ($Item in $Output)
                    {
                        if ($Item -ne "")
                        {
                            if ($Item.IndexOf('RM Identifier:') -ne 0)
                            {
                                $Report += @{$Item.Substring(0,($Item.IndexOf(' :'))).Trim() = `
                                            $item.Substring(34,$Item.Length -34)}
                                }
                            else
                            {
                                $Report += @{$Item.Substring(0,($Item.IndexOf(':'))).Trim() = `
                                            $item.Substring(22,$Item.Length -22)}
                                }
                            }
                        }
                    }
                'volumeinfo'
                {
                    foreach ($Item in $Output)
                    {
                        if ($Item -ne "")
                        {
                            if ($Item.IndexOf(':') -ne -1)
                            {
                                $Report += @{$Item.Substring(0,$Item.IndexOf(' :')).Trim() = `
                                            $Item.Substring($Item.indexof(': ')+2,$Item.Length-($Item.indexof(': ')+2))}
                                }
                            else
                            {
                                if ($Item.IndexOf('&') -eq -1)
                                {
                                    $Report += @{$Item.Substring($Item.IndexOf(' '),$Item.Length-$Item.IndexOf(' ')).Trim() = `
                                                $Item.Substring(0,$Item.IndexOf(' ')).Trim()}
                                    }
                                else
                                {
                                    $Report += @{$Item.Substring($Item.IndexOf('&')+1,$Item.Length-$Item.IndexOf('&')-1).Trim() = `
                                                $Item.Substring(0,$Item.IndexOf('&')).Trim()}
                                    }
                                }
                            }
                        }
                    }
                default
                {
                    Write-Error $Error[0]
                    break
                    }
                }
            }
        }
    End
    {
        Return $Report
        }
    }