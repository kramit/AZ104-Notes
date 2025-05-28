// commands to run this
// go mod init file.go
// go run file.go

package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"sort"
	"text/tabwriter"
)

// Structs for API responses
type TokenResponse struct {
	AccessToken string `json:"access_token"`
}

type Subscription struct {
	ID          string `json:"subscriptionId"`
	DisplayName string `json:"displayName"`
}

type Resource struct {
	Name     string `json:"name"`
	Type     string `json:"type"`
	Location string `json:"location"`
}

// App Registration details
const (
	tenantID     = "2bf0f2d8-74f9-4288-b5d9-266cd13cc4ce"
	clientID     = "3091deb9-2a1f-4ad0-bbf4-2a5da429fb83"
	clientSecret = "l728Q~13ZxwTa-FFXSG7MN7n4Bn5t2EXSyRTwaBI"
	resource     = "https://management.azure.com/"
	tokenURL     = "https://login.microsoftonline.com/" + tenantID + "/oauth2/token"
)

// Function to get an OAuth token
func getAccessToken() string {
	data := "grant_type=client_credentials&client_id=" + clientID + "&client_secret=" + clientSecret + "&resource=" + resource
	resp, err := http.Post(tokenURL, "application/x-www-form-urlencoded", bytes.NewBufferString(data))
	if err != nil {
		fmt.Println("Error getting access token:", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	var token TokenResponse
	json.Unmarshal(body, &token)
	return token.AccessToken
}

// Function to get all subscriptions
func getSubscriptions(token string) []Subscription {
	url := "https://management.azure.com/subscriptions?api-version=2022-12-01"
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error fetching subscriptions:", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	var result map[string][]Subscription
	json.Unmarshal(body, &result)

	return result["value"]
}

// Function to get all resources in a subscription
func getResources(token, subscriptionID string) []Resource {
	url := "https://management.azure.com/subscriptions/" + subscriptionID + "/resources?api-version=2021-04-01"
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error fetching resources:", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	var result map[string][]Resource
	json.Unmarshal(body, &result)

	return result["value"]
}

// Function to count resources by region
func countResourcesByRegion(resources []Resource) map[string]int {
	counts := make(map[string]int)
	for _, resource := range resources {
		counts[resource.Location]++
	}
	return counts
}

// Function to display results in a table
func printTable(data map[string]int) {
	w := tabwriter.NewWriter(os.Stdout, 10, 2, 2, ' ', 0)
	fmt.Fprintln(w, "Region\tResource Count")

	// Sort regions alphabetically
	var keys []string
	for k := range data {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	for _, region := range keys {
		fmt.Fprintf(w, "%s\t%d\n", region, data[region])
	}
	w.Flush()
}

func main() {
	fmt.Println("Fetching Azure access token...")
	token := getAccessToken()
	fmt.Println("Access token obtained successfully.")

	fmt.Println("Fetching subscriptions...")
	subscriptions := getSubscriptions(token)
	if len(subscriptions) == 0 {
		fmt.Println("No subscriptions found or insufficient permissions.")
		return
	}
	fmt.Printf("Subscriptions Found: %d\n", len(subscriptions))

	// Fetch and count resources
	allResources := []Resource{}
	for _, sub := range subscriptions {
		fmt.Printf("Fetching resources for subscription: %s (%s)\n", sub.ID, sub.DisplayName)
		resources := getResources(token, sub.ID)
		allResources = append(allResources, resources...)
	}

	// Count resources by region
	if len(allResources) == 0 {
		fmt.Println("No resources found.")
		return
	}

	resourceCounts := countResourcesByRegion(allResources)

	// Print summary table
	fmt.Println("\nResource Count by Region:")
	printTable(resourceCounts)
}
