import requests
import json
from collections import Counter
from tabulate import tabulate

# Define App Registration details
tenant_id = "2bf0f2d8-74f9-4288-b5d9-266cd13cc4ce"
client_id = "0793c007-1053-45a5-9c28-2ee21c193d3a"
client_secret = ""

# Azure Management API endpoints
token_url = f"https://login.microsoftonline.com/{tenant_id}/oauth2/token"
subscriptions_url = "https://management.azure.com/subscriptions?api-version=2022-12-01"
resource_url_template = "https://management.azure.com/subscriptions/{}/resources?api-version=2021-04-01"

# Get authentication token
token_data = {
    "grant_type": "client_credentials",
    "client_id": client_id,
    "client_secret": client_secret,
    "resource": "https://management.azure.com/"
}

response = requests.post(token_url, data=token_data)
access_token = response.json().get("access_token")

if not access_token:
    print("Failed to obtain access token.")
    exit()

print("Access Token obtained successfully")

# Get all subscriptions
headers = {"Authorization": f"Bearer {access_token}"}
subscriptions_response = requests.get(subscriptions_url, headers=headers)
subscriptions = subscriptions_response.json().get("value", [])

if not subscriptions:
    print("No subscriptions found or insufficient permissions.")
    exit()

print(f"Subscriptions Found: {len(subscriptions)}")

# Fetch resources for each subscription
all_resources = []
for subscription in subscriptions:
    sub_id = subscription["subscriptionId"]
    print(f"Fetching resources for Subscription: {sub_id}")

    resource_url = resource_url_template.format(sub_id)
    resources_response = requests.get(resource_url, headers=headers)
    resources = resources_response.json().get("value", [])

    all_resources.extend(resources)

if not all_resources:
    print("No resources found.")
    exit()

# Count resources by location
location_counts = Counter(resource["location"] for resource in all_resources if "location" in resource)

# Display summary
print("\nResource Count by Region:")
table_data = [[location, count] for location, count in location_counts.items()]
print(tabulate(table_data, headers=["Region", "Resource Count"], tablefmt="grid"))
