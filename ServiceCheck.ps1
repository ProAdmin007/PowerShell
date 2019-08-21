#// Start of script
#//clear screen
cls
#// input AD
import-module activedirectory; 
$servers = get-adcomputer -filter {operatingsystem -like "*server*"};

#// Get year and month for csv export file
$DateTime = Get-Date -f "yyyy-MM-dd"

#//Promt for Tenant
$Tenants = Read-Host -Prompt 'Input Tenant'

#// Set CSV file name
$CSVFile = "C:\Users\Public\$Tenants-"+$DateTime+"-"+"Services Check"+".csv"

#// Create emy array for CSV data
$CSVOutput = @()

foreach ($server in $servers) {
Try{
    Write-Host $server.Name     
    $services = $null;
    $services = Get-WmiObject win32_service -computer $server.name -ErrorAction stop | Where-Object {($_.startname -like "*Administrator*")};
    }

    catch{
    Write-Host "failed to connect"
    $server |Export-Csv -path C:\Users\Public\$Tenants-Errors.csv -Append
}
     
    if ($services -ne $null) {
        foreach ($service in $services) {
            write-host $server.name - $service.caption - $service.startname;
        }
    }
    #// Set up hash table and add values
	$HashTab = $NULL
	$HashTab = [ordered]@{
		"Servers" = $server.Name
        "Service" = $service.caption       
	}
    $service = $NULL
	#// Add hash table to CSV data array
	$CSVOutput += New-Object PSObject -Property $HashTab
}



#// Export to CSV files
$CSVOutput | Sort-Object Name | Export-Csv $CSVFile -NoTypeInformation

Invoke-Item C:\users\Public

#// End of script