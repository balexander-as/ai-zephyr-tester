param (
    [string]$TestID
)

if ([string]::IsNullOrEmpty($TestID)) {
    Write-Error "Error: Test ID not provided."
    exit 1
}

if ($TestID -notmatch '^.+-T[0-9]+$') {
    Write-Error "Error: Invalid Test ID format. Expected format: PROJECT-T123 (e.g., AS-T123)"
    exit 1
}

$token = $env:ZEPHYR_API_TOKEN
if ([string]::IsNullOrEmpty($token)) {
    Write-Error "ZEPHYR_API_TOKEN environment variable not set."
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $token"
}

$url = "https://api.zephyrscale.smartbear.com/v2/testcases/$TestID/teststeps"

try {
    $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -UseBasicParsing

    if ($response.StatusCode -ne 200) {
        Write-Error "Error fetching test steps. Status: $($response.StatusCode), Body: $($response.Content)"
        exit 1
    }

    $data = $response.Content | ConvertFrom-Json

    $cleanedSteps = @()
    foreach ($step in $data.values) {
        $cleanedStep = [PSCustomObject]@{
            description    = ($step.inline.description -replace '<[^>]+>')
            testData       = ($step.inline.testData -replace '<[^>]+>')
            expectedResult = ($step.inline.expectedResult -replace '<[^>]+>')
        }
        $cleanedSteps += $cleanedStep
    }

    $output = @{
        steps = $cleanedSteps
    } | ConvertTo-Json -Depth 3

    Write-Output $output
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode) {
        Write-Error "Error fetching test steps. Status: $statusCode, Error: $_"
    } else {
        Write-Error "Error fetching test steps: $_"
    }
    exit 1
}
