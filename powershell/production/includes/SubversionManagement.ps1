Function Update-Repo
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
        .LINK
    #>
    
    Param
    (
    [string]$WorkingPath
    )
    
    Begin
    {
        $TSvnCommand = "TortoiseProc.exe /command:update /path:$($WorkingPath)"
        $SvnCommand = "svn update $($WorkingPath)"
        }

    Process
    {
        
        }

    End
    {
        
        }
}

Function New-Repo
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
        .LINK
    #>
    
    Param
    (
    )
    
    Begin
    {
        
        }

    Process
    {
        
        }

    End
    {
        
        }
}

Function Add-RepoItem
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
        .LINK
    #>
    
    Param
    (
    )
    
    Begin
    {
        
        }

    Process
    {
        
        }

    End
    {
        
        }
}

Function Set-RepoProps
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
        .LINK
    #>
    
    Param
    (
    )
    
    Begin
    {
        
        }

    Process
    {
        
        }

    End
    {
        
        }
}

New-RepoRevision
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
        .LINK
    #>
    
    Param
    (
    )
    
    Begin
    {
        
        }

    Process
    {
        
        }

    End
    {
        
        }
}