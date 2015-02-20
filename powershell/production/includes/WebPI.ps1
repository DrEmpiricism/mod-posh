﻿try
{
    $ErrorActionPreference = "Stop";
    $Error.Clear();
    Write-Verbose "Loading Microsoft.Web.Platforminstaller assembly";
    [reflection.assembly]::LoadWithPartialName("Microsoft.Web.PlatformInstaller") |Out-Null;
    Write-Verbose "Creating a global ProductManager object";
    $Global:WebPIProductManager = New-Object Microsoft.Web.PlatformInstaller.ProductManager;
    Write-Verbose "Loading the ProductManager, this may take a few secongs";
    $Global:WebPIProductManager.Load();
    }
catch
{
    Write-Error $Error[0];
    Write-Error "Please install WebPI from here : http://www.microsoft.com/web/downloads/platform.aspx";
    break;
    }
Function Get-WebPiProduct
{
    <#
        .SYNOPSIS
            Get one or more products from WebPI
        .DESCRIPTION
            This function will return one or more or all products that are avaialble through
            WebPI. If the All switch is present the function will return everything, otherwise
            the function will attempt to get the product requested or find matches via
            wildcard. The function tries to match the product entered against the title property.
        .PARAMETER Title
            Get one or more products that match the Title provided
        .PARAMETER ProductId
            Get the product that has the provided ProductId
        .PARAMETER ListKeywords
            Get a list of available keywords associated with products
        .PARAMETER Keyword
            Get one or more products associated with the Keyword
        .PARAMETER All
            Get all products
        .EXAMPLE
            Get-WebPiProduct -All


            AllDependencies       : {}
            Author                : Microsoft / Trustwave Spiderlabs
            AuthorUri             : https://github.com/SpiderLabs/ModSecurity
            FeedId                : http://www.microsoft.com/web/webpi/4.2/WebProductList.xml
            Summary               : Open source web application firewall.
            External              : False
            ExternalWarningShown  : False
            IconUrl               : http://www.modsecurity.org/g/webpi_icon.png
            ...

            Description
            -----------
            This will return all products that are available from WebPI. This can be filtered with a where
            clause if needed.            
        .EXAMPLE
            Get-WebPiProduct -Title "Windows Azure"


            AllDependencies       : {http://www.microsoft.com/web/webpi/4.2/WebProductList.xml,
                                    http://www.microsoft.com/web/webpi/4.2/WebProductList.xml,
                                    http://www.microsoft.com/web/webpi/4.2/WebProductList.xml,
                                    http://www.microsoft.com/web/webpi/4.2/WebProductList.xml...}
            Author                : Microsoft Corporation
            AuthorUri             : http://www.microsoft.com/
            FeedId                : http://www.microsoft.com/web/webpi/4.2/WebProductList.xml
            Summary               : The Windows Azure Pack - Admin Site provides management services for administrators and
                                    tenants.
            External              : False
            ExternalWarningShown  : False
            IconUrl               : http://go.microsoft.com/?linkid=9851985
            ...

            Description
            -----------            
            This will return any product that matches "Windows Azure" unless there is a single product called that.
        .EXAMPLE
            Get-WebPiProduct -ProductId watk-PRESENTATION-WindowsAzureStorage


            AllDependencies       : {}
            Author                : Microsoft Developer & Platform Evangelism
            AuthorUri             : http://www.microsoft.com/
            FeedId                : http://www.microsoft.com/web/webpi/4.2/WebProductList.xml
            Summary               :
                                          This presentation covers the Windows Azure storage services.  Blobs, tables, queues,
                                    drives, and the CDN are discussed in this presentation.

            External              : False
            ExternalWarningShown  : False
            IconUrl               : http://dpetrainingkits.blob.core.windows.net/shared/watk-logo.png
            Incompatibilities     : {}
            IncompatibleProcesses : {}
            IsApplication         : False
            IsIisComponent        : False
            IsUpdate              : False
            Keywords              : {}
            LongDescription       :
                                          This presentation covers the Windows Azure storage services.  Blobs, tables, queues,
                                    drives, and the CDN are discussed in this presentation.

            Link                  : https://github.com/windowsazure-trainingkit/presentation-windowsazurestorage
            ProductId             : watk-PRESENTATION-WindowsAzureStorage
            Published             : 3/23/2014 12:00:00 AM
            RelatedProducts       : {}
            SelectedInstaller     :
            Terms                 : {}
            Title                 : Windows Azure Storage
            Updates               : {}
            FeedLocation          : https://go.microsoft.com/?linkid=9842185
            Version               : 1.0.4
            Installers            : {Microsoft.Web.PlatformInstaller.Installer}
            DependencySets        : {}
            ExternalPackages      : {}

            Description
            -----------
            This returns a single matching product
        .EXAMPLE
            Get-WebPiProduct -ListKeywords

            Id
            --
            Server
            FrameworkRuntime
            Database
            ProductTools
            ProductSpotlight
            WindowsAzure
            Sharepoint
            Office
            Lightswitch
            Blogs
            ContentMgmt
            eCommerce
            Galleries
            Tools
            Wiki
            Forums
            ASPNET
            ASPNET4
            PHP
            SQL
            MySQL
            VistaDB
            SQLite
            FlatFile
            SQLCE
            AzureReady
            KatalReady
            AppFrameworks

            Description
            -----------
            Get a list of keywords that are associated with products. This list is case-sensitive.
        .EXAMPLE
            Get-WebPiProduct -Keyword KatalReady |Select-Object -Property Title, ProductId, Keywords

            Title                                   ProductId                               Keywords
            -----                                   ---------                               --------
            Drupal Commerce Kickstart               drupalcommercesql                       {eCommerce, ContentMgmt, PHP, SQL...}
            DasBlog                                 DasBlog                                 {AzureReady, KatalReady, Blogs}

            Description
            -----------
            Return a list of products related to a keyword, the keyword is case-sensitive
        .NOTES
            FunctionName : Get-WebPiProduct
            Created by   : Jeffrey
            Date Coded   : 02/20/2015 08:55:09

            This function requires WebPI to be installed
        .LINK
            https://github.com/jeffpatton1971/mod-posh/wiki/WebPI#Get-WebPiProduct
    #>
    [CmdletBinding()]
    Param
        (
        [Parameter(ParameterSetName='title')]
        [string]$Title,
        [Parameter(ParameterSetName='productid')]
        [string]$ProductId,
        [Parameter(ParameterSetName='listkeywords')]
        [switch]$ListKeywords,
        [Parameter(ParameterSetName='keyword')]
        [string]$Keyword,
        [Parameter(ParameterSetName='all')]
        [switch]$All
        )
    Begin
    {
        }
    Process
    {
        if ($All)
        {
            Write-Verbose "Return all the products available";
            $Global:WebPIProductManager.Products;
            }
        if ($Title)
        {
            Write-Verbose "Return all the products that match Title = $($Title)";
            $Global:WebPIProductManager.Products |Where-Object -Property Title -Like "*$($Title)*";
            }
        if ($ProductId)
        {
            Write-Verbose "Return the product with ProductId = $($ProductId)";
            $Global:WebPIProductManager.GetProduct($ProductId);
            }
        if ($ListKeywords)
        {
            Write-Verbose "Return a list of keywords for products";
            $Global:WebPIProductManager.Keywords |Select-Object -Property Id;
            }
        if ($Keyword)
        {
            Write-Verbose "Return all the products that match Keyword = $($Keyword)";
            $Global:WebPIProductManager.GetKeyword($Keyword) |Select-Object -ExpandProperty Products;
            }
        }
    End
    {
        }
    }
Function Install-WebPiProduct
{
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .NOTES
            FunctionName : Install-WebPiProduct
            Created by   : Jeffrey
            Date Coded   : 02/20/2015 09:45:37
        .LINK
            https://github.com/jeffpatton1971/mod-posh/wiki/WebPI#Install-WebPiProduct
    #>
    [CmdletBinding()]
    Param
        (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [Microsoft.Web.PlatformInstaller.Product]$Product,
        [ValidateSet('en', 'fr', 'es', 'de', 'it', 'ja', 'ko', 'ru', 'zh-cn', 'zh-tw', 'cs', 'pl', 'tr', 'pt-br', 'he', 'zh-hk', 'pt-pt')]
        [string]$LanguageID
        )
    Begin
    {
        Write-Verbose "Create InstallManager object";
        $InstallManager = New-Object Microsoft.Web.PlatformInstaller.InstallManager;
        Write-Verbose "Get a Language for installation";
        $Language = $Global:WebPIProductManager.GetLanguage($LanguageID);
        }
    Process
    {
        foreach ($p in $Product)
        {
            Write-Verbose "Set product language for install";
            $ProductInstall = $p.GetInstaller($Language);
            if (($p.Installers |Select-Object -ExpandProperty InstallerFile) -eq $null)
            {
                throw "No InstallerFile found";
                }
            Write-Verbose "Create an Installer object";
            $ProductInstaller = New-Object 'System.Collections.Generic.List[Microsoft.Web.PlatformInstaller.Installer]';
            Write-Verbose "Add product to installer";
            $ProductInstaller.Add($ProductInstall);
            Write-Verbose "Load the product installer";
            $InstallManager.Load($ProductInstaller);

            Show-WebPiInstallerContextStatus -InstallManager $InstallManager;
            [System.Management.Automation.PSReference]$Reference = $null;
            foreach ($InstallerContext in $InstallManager.InstallerContexts)
            {
                Write-Verbose "Download installer";
                $InstallManager.DownloadInstallerFile($InstallerContext, $Reference)
                }
            Show-WebPiInstallerContextStatus -InstallManager $InstallManager;
            [Microsoft.Web.PlatformInstaller.InstallationState]$preStatus = $InstallManager.InstallerContexts.InstallationState
            Write-Verbose "Start Installation";
            $InstallManager.StartInstallation();
            if (Test-WebPiInstallationStatus -ProductId $p.ProductId -InstallManager $InstallManager -PreStatus $preStatus -PostStatus $InstallManager.InstallerContexts.InstallationState)
            {
                return;
                }
            else
            {
                Write-Verbose "Start Application Installation";
                $InstallManager.StartApplicationInstallation();
                if (Test-WebPiInstallationStatus -ProductId $p.ProductId -InstallManager $InstallManager -PreStatus $preStatus -PostStatus $InstallManager.InstallerContexts.InstallationState)
                {
                    return;
                    }
                else
                {
                    Write-Verbose "Start Synchronous Installation";
                    $InstallManager.StartSynchronousInstallation();
                    if (Test-WebPiInstallationStatus -ProductId $p.ProductId -InstallManager $InstallManager -PreStatus $preStatus -PostStatus $InstallManager.InstallerContexts.InstallationState)
                    {
                        return;
                        }
                    }
                }
            }
        }
    End
    {
        }
    }

function Show-WebPiInstallerContextStatus
{
    [CmdletBinding()]
    param
    (
    [Microsoft.Web.PlatformInstaller.InstallManager]$InstallManager
    )
    if ($InstallManager.InstallerContexts)
    {
        $InstallManager.InstallerContexts | Out-String -Stream | Write-Verbose
        }
    }
function Test-WebPiInstallationStatus
{
    [OutputType([bool])] 
    [CmdletBinding()]
    param
    (
    [parameter(Mandatory = 0, Position = 0, ValueFromPipelineByPropertyName = 1)]
    [string]$ProductId,
    [Microsoft.Web.PlatformInstaller.InstallManager]$InstallManager,
    [parameter(Mandatory = 0, Position = 0, ValueFromPipelineByPropertyName = 1)]
    [Microsoft.Web.PlatformInstaller.InstallationState]$PreStatus,
    [parameter(Mandatory = 0, Position = 0, ValueFromPipelineByPropertyName = 1)]
    [Microsoft.Web.PlatformInstaller.InstallationState]$PostStatus
    )
    # Skip
    if ($postStatus -eq $preStatus)
    {
        Write-Verbose "Installation not begin"
        return $false
        }

    # Monitor
    Show-WebPiInstallerContextStatus -InstallManager $InstallManager
    while($postStatus -ne [Microsoft.Web.PlatformInstaller.InstallationState]::InstallCompleted)
    {
        Start-Sleep -Milliseconds 100
        $postStatus = $InstallManager.InstallerContexts.InstallationState
        }
    Show-WebPiInstallerContextStatus -InstallManager $InstallManager
    if ($postStatus -eq [Microsoft.Web.PlatformInstaller.InstallationState]::InstallCompleted)
    {
        if ($InstallManager.InstallerContexts.Installer.LogFiles)
        {
            $LogFiles = $InstallManager.InstallerContexts.Installer.LogFiles
            $LogPath = ($LogFiles | Select-Object -Last 1)
            New-Object -TypeName psobject -Property @{
                ProductId = $ProductId
                Status = "Installation Completed"
                Log = $LogPath
                } |Select-Object -Property ProductId, Status, Log
            Write-Verbose ("Latest Log file is '{0}'." -f (Get-Content -Path $LogPath -Encoding UTF8 -Raw))
            }
        Write-Verbose "No logfiles found";
        return $true
        }
    else
    {
        return $false
        }
    }