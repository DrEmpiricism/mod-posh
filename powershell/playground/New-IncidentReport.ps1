Write-Verbose "Get local hostname"
$hostname = (&hostname)

Write-Verbose "Get details for all network adapter objects"
$Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration

Write-Verbose "Get Netstat -ano output"
$Netstat = Get-Netstat

Write-Verbose "Get ipv4 Routes"
$IPv4Routes = Get-IPv4Route

Write-Verbose "Get ipv6 Routes"
$IPv6Routes = Get-IPv6Route

Write-Verbose "Get NbtStat output"
$NbtStat = Get-NbtStat

Write-Verbose "Get shared folders"
$Shares = Get-WmiObject Win32_Share

Write-Verbose "Get open files"
$Files = Get-OpenFiles

Write-Verbose "Get arp cache"
$ArpCache = Get-ArpCache

Write-Verbose "Get DNS Cache"
$DnsCache = Get-DNSClientCache

Write-Verbose "Get new view"
$NetView = Get-NetView

