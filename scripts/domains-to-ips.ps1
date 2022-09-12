# Creates list of IPs in txt file when fed list of domains in txt file.
# Usage: Create txt file called domains.txt with a single domain on each line. Run script in directory containing domains.txt outputs ips.txt

$ips = @()

foreach ($domain in [System.IO.File]::ReadLines("$(PWD)\domains.txt")) {
    $tmpips = [System.Net.Dns]::GetHostEntry($domain).AddressList.IPAddressToString
    $ips += $tmpips
    }

Out-File -FilePath .\ips.txt -InputObject $ips -Encoding utf8