<powershell>
# This script is used for configuring an x86 Windows machine as a salt minion through user data.
# Requires the urls: repo.saltstack.com and onegetcdn.azureedge.net to be allowed on a URL Allowlist.

# User Set Variables
$SaltVersion = "Salt-Minion-3003.2-Py3-x86-Setup.exe"  # This is the version of Salt for Windows to install, taken from the Salt website.

# Proxy Variables - Set if you are working from behind a corperate HTTP proxy.

$BehindProxy = "True"  # Set to True if working behind a proxy.
$ProxyAddressAndPort = ""  # Set in the format my.web.proxy:0000 where 0000 is the port number.
$ProxyOverride = "localhost;127.0.0.1;10.*;.eu-west-2.amazonaws.com;169.254.169.254;169.254.169.253;169.254.169.123;<local>" 


# Automatic Variables
$SaltSource = "https://repo.saltstack.com/windows/$saltversion"
$SaltDestination = "c:\Salt\$saltversion"

### Code ###

if ($BehindProxy = "True") {
    Set-ItemProperty "HKCU:\Software\Windows\CurrentVersion\Internet Settings" -name AutoDetect -value 1
    Set-ItemProperty "HKCU:\Software\Windows\CurrentVersion\Internet Settings" -name ProxyEnable -value 1
    Set-ItemProperty "HKCU:\Software\Windows\CurrentVersion\Internet Settings" -name ProxyServer -value $ProxyAddressAndPort
    Set-ItemProperty "HKCU:\Software\Windows\CurrentVersion\Internet Settings" -name ProxyOverride -value $ProxyOverride
    
}

# Configure Windows Time Service
w32tm /config /manualpeerlist:169.254.168.123 /syncfromflags:manual /update

# Install NuGet & Python3
Install-PackageProvider NuGet -Force
Install-Package Python3 -Force

# Install Salt Minion
Set-Location C:\temp
wget $SaltSource -OutFile c:\temp\$saltversion
iex '$SaltDestination /S /master=salt-master /minion-name=$env:computername'

</powershell>
