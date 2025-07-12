param(
    [string]$MavenCommand = "clean"
)

$subfolders = @(
    "accounts",
    "cards",
    "configserver",
    "eurekaserver",
    "gatewayserver",
    "loans",
    "message"
)

$basePath = Get-Location

foreach ($folder in $subfolders) {
    $fullPath = Join-Path $basePath $folder
    $pomPath = Join-Path $fullPath "pom.xml"

    if (Test-Path $pomPath) {
        Write-Host "`nExecuting 'mvn $MavenCommand' in '$folder'..." -ForegroundColor Cyan
        Push-Location $fullPath

        # Properly run mvn with multiple goals
        Invoke-Expression "mvn $MavenCommand"

        Pop-Location
    } else {
        Write-Warning "Skipped '$folder' - pom.xml not found."
    }
}
