<#List all things in all subs with api access using azure management api permissions required 
Azure RBAC Roles (Assign at Subscription Level)

    Reader – Allows the application to list resources in a subscription.

API Permissions (Application Type)

    Azure Service Management (user_impersonation) – Required for accessing the management.azure.com API.
#>


# Define App Registration details
$tenantId = "2bf0f2d8-74f9-4288-b5d9-266cd13cc4ce"
$clientId = "7af99afe-b8c2-418a-b002-48dd2e48a7bc"
$clientSecret = ""

# Define the resource for Azure Management API
$resource = "https://management.azure.com/"
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/token"

# Get authentication token using client credentials flow
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    resource      = $resource
}

$response = Invoke-RestMethod -Method Post -Uri $tokenUrl -ContentType "application/x-www-form-urlencoded" -Body $body
$accessToken = $response.access_token

# Validate token retrieval
if (-not $accessToken) {
    Write-Host "Failed to obtain access token" -ForegroundColor Red
    exit
}

Write-Host "Access Token obtained successfully" -ForegroundColor Green

# Get all subscriptions
$subscriptionsUri = "https://management.azure.com/subscriptions?api-version=2022-12-01"

$subscriptions = Invoke-RestMethod -Method Get -Uri $subscriptionsUri -Headers @{
    Authorization = "Bearer $accessToken"
} | Select-Object -ExpandProperty value

# Display Subscriptions
Write-Host "Subscriptions Found:" -ForegroundColor Cyan
$subscriptions | Format-Table id, displayName, state -AutoSize

# Fetch resources for each subscription
$allResources = @()
foreach ($subscription in $subscriptions) {
    $subId = $subscription.subscriptionId
    Write-Host "Fetching resources for Subscription: $subId" -ForegroundColor Yellow

    $resourcesUri = "https://management.azure.com/subscriptions/$subId/resources?api-version=2021-04-01"

    $resources = Invoke-RestMethod -Method Get -Uri $resourcesUri -Headers @{
        Authorization = "Bearer $accessToken"
    } | Select-Object -ExpandProperty value

    $allResources += $resources
}


# Display the results
Write-Host "Azure Resources Found:" -ForegroundColor Cyan
$allResources | Select-Object name, type, location, id | Format-Table -AutoSize

# Count resources by location and subscription
$resourceCount = $allResources | Group-Object -Property location | Sort-Object Count -Descending

# Display summary table
Write-Host "`nResource Count by Region:" -ForegroundColor Cyan
$resourceCount | Select-Object Name, Count | Format-Table -AutoSize

