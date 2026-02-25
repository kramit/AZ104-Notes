# Virtual Machines – Sample Windows Server VM (ARM, Terraform, Bicep)

This folder contains three equivalent templates that deploy a simple Windows Server virtual machine in Azure with:

- **Size**: `Standard_D4s_v3` (4 vCPUs, 16 GiB RAM)
- **OS**: Windows Server 2022 Datacenter
- **Network**: New virtual network, subnet, public IP, NIC, and NSG with RDP (TCP 3389) open from the internet (for lab/demo use only).
 - **Post-deploy software**: A custom script runs at creation time to install Docker Desktop, VLC, Visual Studio Code, Node.js/NPM, and the Codex CLI (best-effort) and writes a log file to the desktop.

Templates:

- **ARM template**: `azuredeploy.json`
- **Terraform template**: `main.tf`
- **Bicep template**: `main.bicep`
 - **Custom script**: `customscript.ps1` (invoked automatically by all three templates)

> **Important**: These are **lab/demo** templates. Do not use as‑is in production (for example, RDP is open to the internet and admin credentials are simple parameters).

**Custom script URL**: The templates download `customscript.ps1` from GitHub. The URL in all three templates is `https://raw.githubusercontent.com/kramit/AZ104-Notes/master/templates/virtualmachines/customscript.ps1`. If you use a fork or a different repo, update the script URL in `azuredeploy.json`, `main.bicep`, and `main.tf` to match your repo and branch (e.g. `main` instead of `master`).

---

## Prerequisites

- An Azure subscription.
- Azure CLI installed (`az` command).
- For Terraform: Terraform CLI installed (`terraform` command).
- A resource group name and region you want to use (for ARM/Bicep).

Example resource group:

```bash
az group create -n rg-vm-lab -l eastus
```

---

## 1. Deploying the ARM Template (`azuredeploy.json`)

### 1.1. Review the template

- Open `azuredeploy.json` and note the parameters:
  - **`vmName`**: VM name (default `vm-win-lab`).
  - **`adminUsername`**: Local admin username.
  - **`adminPassword`**: Local admin password (secure string).
  - **`location`**: Region (defaults to the resource group location).

### 1.2. Deploy from the CLI

From this `virtualmachines` folder:

```bash
az deployment group create \
  --resource-group rg-vm-lab \
  --template-file azuredeploy.json \
  --parameters adminUsername=<yourAdminUser> adminPassword=<yourStrongPassword>
```

Replace:

- `rg-vm-lab` with your resource group name (if different).
- `<yourAdminUser>` / `<yourStrongPassword>` with your chosen credentials.

### 1.3. Connect

After deployment:

- In the Azure Portal, go to your resource group and find:
  - The VM (`vmName`).
  - The public IP address.
- Use RDP (`mstsc` on Windows or an RDP client on macOS/Linux) to connect:
  - Host: public IP address.
  - Username/password: values you used for `adminUsername` and `adminPassword`.

Once logged in, check the **Public Desktop** for `LabSoftwareInstall.log` to see the results of the software installation script (Docker Desktop, VLC, VS Code, Node.js/NPM, Codex).

---

## 2. Deploying the Terraform Template (`main.tf`)

### 2.1. Initialize Terraform

From this `virtualmachines` folder:

```bash
terraform init
```

### 2.2. Set variables and plan

You can pass variables on the command line, or create a `terraform.tfvars` file. Example (command line):

```bash
terraform plan \
  -var "resource_group_name=rg-vm-lab" \
  -var "location=eastus" \
  -var "vm_name=vm-win-lab" \
  -var "admin_username=<yourAdminUser>" \
  -var "admin_password=<yourStrongPassword>"
```

Review the plan output to see what will be created.

### 2.3. Apply

```bash
terraform apply \
  -var "resource_group_name=rg-vm-lab" \
  -var "location=eastus" \
  -var "vm_name=vm-win-lab" \
  -var "admin_username=<yourAdminUser>" \
  -var "admin_password=<yourStrongPassword>"
```

Type `yes` when prompted to confirm.

### 2.4. Inspect outputs and connect

After a successful apply:

```bash
terraform output
```

Look for:

- `admin_username`
- `public_ip_address`

Use RDP to connect to the VM using these values.

On the VM, open the **Public Desktop** and review `LabSoftwareInstall.log` for details about the installed tools.

To tear down the lab:

```bash
terraform destroy
```

---

## 3. Deploying the Bicep Template (`main.bicep`)

### 3.1. (Optional) Build to ARM JSON

You can build the Bicep file into an ARM template to inspect it:

```bash
az bicep build --file main.bicep
```

This command generates a JSON template next to the Bicep file but is **not** required for deployment.

### 3.2. Deploy from the CLI

From this `virtualmachines` folder:

```bash
az deployment group create \
  --resource-group rg-vm-lab \
  --template-file main.bicep \
  --parameters adminUsername=<yourAdminUser> adminPassword=<yourStrongPassword>
```

As with the ARM template:

- `vmName` defaults to `vm-win-lab` but can be overridden via `--parameters vmName=<newName>`.
- `location` defaults to the resource group location.

### 3.3. Connect

After deployment, use the portal (or `az network public-ip show`) to find the public IP and connect via RDP using the credentials you provided.

On the VM, open the **Public Desktop** and review `LabSoftwareInstall.log` for details about the installed tools.

---

## Clean Up

When you are finished with the lab, delete the resource group to avoid ongoing costs:

```bash
az group delete -n rg-vm-lab --yes --no-wait
```

This removes all resources created by the ARM, Bicep, or Terraform examples in this folder (if they were deployed into that resource group).

