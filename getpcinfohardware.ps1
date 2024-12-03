# first get current username and hostname to later save the file using it

unblock-file -Path "\\arquivosdti.clickip.local\automacao_dados\pyinstall\getpcinfohardware.ps1" -WarningAction Ignore

$hostname = [System.Environment]::MachineName

#concatenating both values above:

$currentUser = "$hostname\$username"



########################################### CPU PROPERTIES LIST ###########################################################################################################



Write-Host "Getting CPU info"

$computerName = Get-CimInstance -ClassName Win32_Processor | Select-object -ExpandProperty name | Out-String

Write-Host "$computerName"

########################################### SYSTEM PROPERTIES LIST ########################################################################################################



Write-Host "Getting System info and current user"

$computersystemname = Get-CimInstance -ClassName win32_computersystem | Select-Object -ExpandProperty Name | Out-String

Write-Host "$computersystemname"

$computersystemmodel = Get-CimInstance -ClassName win32_computersystem | Select-Object -ExpandProperty model | Out-String

Write-Host "$computersystemmodel"

$computersystemmemory = Get-CimInstance -ClassName win32_computersystem | Select-Object -ExpandProperty totalphysicalmemory | Out-String

Write-Host "$computersystemmodel"

$computersystemusername = Get-CimInstance -ClassName win32_computersystem | Select-Object -ExpandProperty username | Out-String



######################################## NETWORK SETTINGS PROPERTIES LIST #######################################################################################################



# Uses ARP to get ipv4 and MAC addresses

Write-Host "Getting Ip settings info"

$ipsettingsdhcpenabled = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | Select-Object -ExpandProperty dhcpenabled | Out-String

Write-Host "$ipsettingsdhcpenabled"

$ipsettingsipaddress = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | Select-Object -ExpandProperty ipaddress | Out-String

Write-Host "$ipsettingsipaddress"

$ipsettingsdnsdomain = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | Select-Object -ExpandProperty dnsdomain | Out-String

Write-Host "$ipsettingsdnsdomain"

$ipsettingsdescription = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | Select-Object -ExpandProperty description | Out-String

Write-Host "$ipsettingsdescription"

$ipsettingsmacaddress = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | Select-Object -ExpandProperty MACaddress | Out-String

Write-Host "$ipsettingsmacaddress"



########################################### STORAGE PROPERTIES LIST ########################################################################################################



Write-Host "Getting disk current storage info"


$storagedataused = Get-PSDrive | Where-Object { $_.used}| Select-Object -ExpandProperty used | Out-String

$storagedatafree = Get-PSDrive | Where-Object { $_.free}| Select-Object -ExpandProperty free | Out-String

# Convert the strings to numbers (if they are not already)

$used = [int]($storagedataused / 1000000000)
$free = [int]($storagedatafree / 1000000000)

$totalstoragedata = ($used + $free)

Write-Host "$used" 
Write-Host "$free" 
Write-Host "$totalstoragedata" 




################################################## MEMORY PROPERTIES LIST ##################################################################################################



# Get information about memory usage

$memoryinfo = Get-WmiObject Win32_OperatingSystem

# Calculate used memory (Total - Free) and divided by 10^6 (converting to GB)

$freespacememory = [math]::Round(($memoryinfo.FreePhysicalMemory / 1000000), 2)

$usedMemory = [math]::Round((($memoryinfo.TotalVisibleMemorySize / 1000000) - ($memoryinfo.FreePhysicalMemory / 1000000)), 2)

$totalmemory = [math]::Round(($memoryinfo.TotalVisibleMemorySize / 1000000), 2)

# Display results

Write-Host "Getting memory usage..."
Write-Host "Free Memory: " $freespacememory "GB"
Write-Host "Used Memory: " $usedMemory "GB"
Write-Host "Total memory: " $totalmemory "GB"



################################# BASEBOARD SERIAL NUMBER ##########################################



Write-Host "Extracting BASEBOARD serialnumber info from $hostname"

$serialnumber = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object SerialNumber

Write-Host "$serialnumber"



################################## SAVING AND STORING FILE ON \\arquivosdti.clickip.local ##################################################################################



$outputFile = "\\arquivosdti.clickip.local\automacao_dados\coletadedadoshardware\collected-hardware-data-$hostname.csv"


if ($currentUser -and $computerName -and $computersystemname -and $computersystemmodel -and $computersystemmemory -and $computersystemusername -and $ipsettingsdhcpenabled -and $ipsettingsipaddress -and $ipsettingsdnsdomain -and $ipsettingsdescription -and $totalstoragedata -and $serialnumber) {

  # Write success message to file

  "O computador está ligado!" | Out-File -FilePath $outputFile -Encoding UTF8

  Write-Host "System information saved to $outputFile! Data collection successful."



} else {

  # Write failure message to file

  "O computador está desligado ou o usuário não tem acesso!" | Out-File -FilePath $outputFile -Encoding UTF8

  Write-Host "Failed to collect all necessary information. Check system and access."

}



#################################### collected computername data variable #########################################



write-host "Extracting and storing computername collected data on the network's arquivosdti.clickip.local folder"

$computerName | Out-File -FilePath $outputFile -Append



#################################### collected systeminfo data variables #########################################



write-host "Extracting and storing computersystem collected data on the network's arquivosdti.clickip.local folder"

$computersystemname | Out-File -FilePath $outputFile -Append

$computersystemmodel | Out-File -FilePath $outputFile -Append

$computersystememory | Out-File -FilePath $outputFile -Append

$computersystemusername | Out-File -FilePath $outputFile -Append

# collected ipsettings variables

write-host "Extracting and storing local ip settings collected data on the network's arquivosdti.clickip.local folder"

$ipsettingsdhcpenabled | Out-File -FilePath $outputFile -Append

$ipsettingsipaddress | Out-File -FilePath $outputFile -Append

$ipsettingsmemory | Out-File -FilePath $outputFile -Append

$ipsettingsusername | Out-File -FilePath $outputFile -Append

$ipsettingsmacaddress | Out-File -FilePath $outputFile -Append

$serialnumber | Out-File -FilePath $outputFile -Append


################################# collected storage data variables ##########################################



write-host "Extracting and storing current storage situation collected data on the network's arquivosdti.clickip.local folder"

$used | Out-File -FilePath $outputFile -Append

$free | Out-File -FilePath $outputFile -Append

$totalstoragedata | Out-File -FilePath $outputFile -Append



###################################### collected memory data variables ###############################################



write-host "Extracting and storing current memory situation collected data on the network's arquivosdti.clickip.local folder"

$usedMemory | out-file -FilePath $outputFile -Append

$freespacememory | out-file -FilePath $outputFile -Append

$totalmemory | out-file -FilePath $outputFile -Append



############################# WRITE ON THE OUTPUT IF THE DATA COLLECT WAS SUCCESSFUL #######################################################################################


Write-Host "System information saved to $outputFile!"


################################################## END ######################################################################################################################

Stop-Process -id $PID
