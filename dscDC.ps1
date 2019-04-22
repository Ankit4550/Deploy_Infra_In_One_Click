Configuration Main
{
	Param(
		[string] $NodeName,
 
		[Parameter(Mandatory)]
		[String]$FQDomainName,
 
		[Parameter(Mandatory)]
		[PSCredential]$DomainAdmin1Creds,
 
		[Parameter(Mandatory)]
		[PSCredential]$AdminUser1Creds,
 
		[Int]$RetryCount=5,
		[Int]$RetryIntervalSec=30
		)
 
Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xActiveDirectory, `
                                    xComputerManagement, `
                                    xNetworking,
									xStorage
 
Node $AllNodes.Where{$_.Role -eq "DC"}.Nodename
       {
		LocalConfigurationManager 
        {
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true  
			AllowModuleOverwrite = $true
        }
 
        xWaitforDisk Disk2
        {
             Diskid = 2
             RetryIntervalSec =$RetryIntervalSec
             RetryCount = $RetryCount
        }
 
        xDisk ADDataDisk
        {
            Diskid = 2
            DriveLetter = 'F'
        }
 
		# Add DNS
		WindowsFeature DNS
        {
            Ensure = "Present"
            Name = "DNS"
        }
 
        # Install the Windows Feature for AD DS
        WindowsFeature ADDSInstall {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
        }
 
        # Make sure the Active Directory GUI Management tools are installed
        WindowsFeature ADDSTools            
        {             
            Ensure = 'Present'             
            Name = 'RSAT-ADDS'             
        }           
 
        # Create the ADDS DC
        xADDomain FirstDC {
            DomainName = $FQDomainName
            DomainAdministratorCredential = $DomainAdmin1Creds
            SafemodeAdministratorPassword = $DomainAdmin1Creds
			DatabasePath = 'F:\NTDS'
            LogPath = 'F:\NTDS'
            SysvolPath = 'F:\SYSVOL'
            DependsOn = '[WindowsFeature]ADDSInstall'
        }   
        
        xWaitForADDomain DscForestWait
        {
            DomainName = $FQDomainName
            RetryCount = $RetryCount
            RetryIntervalSec = $RetryIntervalSec
            DependsOn = '[xADDomain]FirstDC'
        } 
 
        #
        xADRecycleBin RecycleBin
        {
           EnterpriseAdministratorCredential = $DomainAdmin1Creds
           ForestFQDN = $FQDomainName
           DependsOn = '[xADDomain]FirstDC'
        }
        
        # Create an admin user so that the default Administrator account is not used
        xADUser FirstUser
        {
            DomainAdministratorCredential = $DomainAdmin1Creds
            DomainName = $FQDomainName
            UserName = $AdminUser1Creds.UserName
            Password = $AdminUser1Creds
            Ensure = 'Present'
            DependsOn = '[xADDomain]FirstDC'
        }
		xADUser SecondUser
		   {
			    DomainAdministratorCredential = $DomainAdmin1Creds
				DomainName = $FQDomainName
				UserName = 'vikas.goyal'
				Password = $AdminUser1Creds
				Ensure = 'Present'
				DependsOn = '[xADDomain]FirstDC'
		   }
        xADUser ThirdUser
		   {
			   DomainAdministratorCredential = $DomainAdmin1Creds
				DomainName = $FQDomainName
				UserName = 'Aman.Singh'
				Password = $AdminUser1Creds
				Ensure = 'Present'
				DependsOn = '[xADDomain]FirstDC'
		   }
        xADGroup AddToDomainAdmins
        {
            GroupName = 'Domain Admins'
            MembersToInclude = $AdminUser1Creds.UserName,'vikas.goyal','Aman.Singh'
            Ensure = 'Present'
            DependsOn = '[xADUser]FirstUser'
        }     
    }
 
}