try
{
	# Stop Default Web Site, created as part of base image, to avoid conflict
	Stop-WebSite -Name "Default Web Site"

	# Setup the application
	Expand-Archive -Path 'C:\AppModnzData\MandatoryArtifacts.zip' -DestinationPath 'C:\AppModnzData\MandatoryArtifacts' -ErrorAction Stop
	$msdeployPath = " C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe";
	$setParams = "";
	$msdeployExpression = "&'$msdeployPath' --% -verb:sync -source:archiveDir='C:\AppModnzData\MandatoryArtifacts' -dest:auto $setParams";
	Invoke-Expression $msdeployExpression
	if ($LASTEXITCODE -ne 0)
	{
		throw 'Failed to deploy the application using web deploy'
	}

	# Start the web site
	Start-WebSite -Name "Default Web Site"

	# Updating ACLs for the artifacts
	$paths = @('C:\inetpub\wwwroot')
	ForEach ($path in $paths)
	{
		$acl = Get-ACL "$path"
		Set-ACL -Path "$path" -ACLObject $acl
		$acl = Get-ACL "$path"
		$acl.AddAccessRule($(New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\Authenticated Users", "Modify, Synchronize", "None", "None", "Allow")))
		$acl.AddAccessRule($(New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")))
		$acl.AddAccessRule($(New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "ReadAndExecute, Synchronize", "None", "None", "Allow")))
		if ($(Test-Path -Path $path -PathType Container))
		{
			$acl.AddAccessRule($(New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\Authenticated Users", "Modify, Synchronize", "ContainerInherit, ObjectInherit", "InheritOnly", "Allow")))
			$acl.AddAccessRule($(New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")))
			$acl.AddAccessRule($(New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "ReadAndExecute, Synchronize", "ContainerInherit, ObjectInherit", "InheritOnly", "Allow")))
		}
		Set-ACL -Path "$path" -ACLObject $acl
	}

	Remove-Item -Path 'C:\AppModnzData\' -Recurse -Force
}
catch
{
	echo $_.Exception
	throw 'Failed to setup the application'
}

.\ServiceMonitor.exe w3svc
