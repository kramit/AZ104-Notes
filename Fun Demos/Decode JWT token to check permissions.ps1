# Decode JWT token to check permissions
$tokenParts = $accessToken -split "\."
$tokenPayload = $tokenParts[1] # Base64 encoded payload
$decodedPayload = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($tokenPayload + ("=" * ((4 - $tokenPayload.Length % 4) % 4))))
$decodedPayload | ConvertFrom-Json | Format-List
