# Define the list of subfolders
$subfolders = @(
    "accounts",
    "cards",
    "configserver",
    "eurekaserver",
    "gatewayserver",
    "loans",
    "message"
)



# Get the current directory
$basePath = Get-Location

foreach ($folder in $subfolders) {
    $fullPath = Join-Path $basePath $folder
    $pomPath = Join-Path $fullPath "pom.xml"

    if (Test-Path $pomPath) {
        Write-Host "`nRunning 'mvn clean' in $folder..." -ForegroundColor Cyan
        Push-Location $fullPath
        mvn clean
        Pop-Location
    } else {
        Write-Warning "Skipped '$folder' - pom.xml not found."
    }
}
