# Deploy_Infra_In_One_Click
This repository contains the ARM code to deploy the below resources in one click. 

1. Create one Vnet with name infosys-vnet and ip 10.0.0.0/16
2. Create subent with name jump-subnet and ip 10.0.1.0/24
3. Create subent with name AD-subnet and ip 10.0.2.0/24
4. Create subent with name tool-subnet and ip 10.0.3.0/24
5. Create NSG (Network Security Group) with name Jump-NSG.
6. Create NSG (Network Security Group) with name AD-NSG
7. Create NSG (Network Security Group) with name tool-NSG
8. Associate Jump-NSG with jump-subnet
9. Associate AD-NSG with AD-subnet
10. Associate tool-NSG with tool-subnet
11. In Jump-NSG allow the RDP from internet.
12. In AD-NSG no internet should be allowed and all AD server will only be in Private subnet.
13. Connection to AD server will only be allowed via Jump server.
14. Deploy Virtual Machine with name Jump-Server (Give public IP name as jum-server-ip and network interface name as jump-server-network-   interface)
15. Deploy Virtual Machine with name AD-Server (Give public IP name as AD-server-ip and network interface name as AD-server-network-   interface)
16. Deploy Virtual Machine with name Tool-Server (Give public IP name as tool-server-ip and network interface name as tool-server-network-   interface)
17. Deploy Active Directory along with user creation with help of powershell DSC on AD-Server.
18. Deploy one web application along with SQL server.
19. Deploy one App Gateway in order to access the Webapp.
20. Create different slots for the web application.
21. Make sure you are accessing webapp only with Azure AD account.

All above deployment will be done in one click.


