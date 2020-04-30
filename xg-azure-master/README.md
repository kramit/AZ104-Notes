# xg-azure
Deployment template to deploy Sophos XG firewall to Azure


Deployment via template
-----------------------
[![Deploy to Azure](https://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGoDeploy%2FAZ300%2Fmaster%2Fxg-azure-master%2FmainTemplate.json
)

Powershell
----------

start "https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGoDeploy%2FAZ300%2Fmaster%2Fxg-azure-master%2FmainTemplate.json"


**If invalid parameters are passed, the deployment will fail.**

Please note:
* The `adminPassword` has to be minimum 8 characters, **containing at least a lowercase letter, an uppercase letter, a number, and a special character.**

3) Deployment will start.

4) Wait until the deployment goes to state "Succeeded".

***

Connect to the VM instance
==========================

[https://full-dns-name:4444](https://full-dns-name:4444)

***

Registration
============

1) Get a demo license here: [Sophos - Free Trial](https://secure2.sophos.com/en-us/products/next-gen-firewall/free-trial.aspx).

2) Enter the serial number you received via e-mail on the admin UI of your XG Firewall and activate the device.

3) Register the device and follow the instructions.

4) Make sure the license is synchronized.

