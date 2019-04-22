# Deploy_Infra_In_One_Click
This repository contains the ARM code to deploy the below resources in one click. 

1. Vnet along with 3 subnets
2. Each subnet is associated with it’s own NSG
3. Three VM's deployement.
4. In Jump Subnet(SN) NSG, Allowed RDP from Internet to jump servers.
5. In AD SN, no internet is allowed and all AD servers will only be in Private SN. 
6. Connection to AD servers will only be allowed via Jump servers.
7. Deployment of Active Direcotry along with User creation with the help of DSC.
8. Deployment of Web Application along with SQL server.
9. Deployment of App Gateway in order to access Web App.
10. Created different slots for the web Application.

All above deployment will be done in one click.


