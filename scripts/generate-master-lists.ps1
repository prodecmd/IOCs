$masterdomainlist = "$(pwd)\masterdomainlist.txt"
$masteriplist = "$(pwd)\masteriplist.txt"

# Check for presence of masterdomainlist.txt and create if not exist.

Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - Checking for presence of [$masterdomainlist]."    
if (-not(Test-Path $masterdomainlist -PathType Leaf)) {
    try {
        $null = New-Item -ItemType File -Path $masterdomainlist -Force -ErrorAction Stop
        Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - The file [$masterdomainlist] has been created."
    }
    catch {
        throw $_.Exception.Message
    }
}
else {
    Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$masterdomainlist] already exists."
}

# Check for presence of masteriplist.txt and create if not exist.
Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - Checking for presence of [$masteriplist]."   

if (-not(Test-Path $masteriplist -PathType Leaf)) {
    try {
        $null = New-Item -ItemType File -Path $masteriplist -Force -ErrorAction Stop
        Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$masteriplist] has been created."
    }
    catch {
        throw $_.Exception.Message
    }
}
else {
    Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$masteriplist] already exists."
}


# Merge domains.txt and ips.txt of child folders in to master lists.

# Get child directories of working directory, ignoring scripts and test directories.
$iocDirectories = Get-ChildItem -Directory -Exclude scripts,test

Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - Attempting to merge all [domains.txt] into [$masterdomainlist]"

# Check for presence of domains.txt in each child directory, if exists, append to master domain list.
foreach ($directory in $iocDirectories) {
    if (Test-Path $directory\domains.txt -PathType Leaf) {
        try {
            $newmasterdomainlist = Get-Content $masterdomainlist, $directory\domains.txt -Force -ErrorAction Stop
            $newmasterdomainlist | Set-Content $masterdomainlist -Force -ErrorAction Stop
            Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$directory\domains.txt] has been merged into [$masterdomainlist]."
        }
        catch {
            throw $_.Exception.Message
        }
    }
    else {
        Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$directory\domains.txt] does not exist"
    }
}

Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - All [domains.txt] have been merged into [$masterdomainlist]"

Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - Attempting to merge all [ips.txt] into [$masteriplist]"

# Check for presence of ips.txt in each child directory, if exists, append to master domain list.
foreach ($directory in $iocDirectories) {
    if (Test-Path $directory\ips.txt -PathType Leaf) {
        try {
            $newmasteriplist = Get-Content $masteriplist, $directory\ips.txt -Force -ErrorAction Stop
            $newmasteriplist | Set-Content $masteriplist -Force -ErrorAction Stop
            Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$directory\ips.txt] has been merged into [$masteriplist]."
        }
        catch {
            throw $_.Exception.Message
        }
    }
    else {
        Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - [$directory\ips.txt] does not exist"
    }
}

Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - All [ips.txt] have been merged into [$masteriplist]"

Write-Host "$(get-date -Format "yyyy-mm-dd hh:MM:ss") - All child lists have been merged into master lists"