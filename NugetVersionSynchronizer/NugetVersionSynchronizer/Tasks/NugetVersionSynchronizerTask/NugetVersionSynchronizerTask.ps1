function GetMetadataValue
{
	Param ([System.Xml.XmlNode]$xml, [string]$nodeName)
	$node = $null
	$packageNode = $xml.ChildNodes | Where-Object { $_.GetType().ToString() -eq "System.Xml.XmlElement" } | Where-Object { $_.Name -eq "package" } | Select -First 1
	if (!($packageNode -eq $null))
	{
		if ([string]::IsNullOrEmpty($packageNode.NamespaceURI))
		{
			$node = Select-Xml -Xml $xml -XPath "/package/metadata/$nodeName";
		}
		else
		{
			$XmlNamespace = @{ ns = $packageNode.NamespaceURI; };
			$node = Select-Xml -Xml $xml -XPath "/ns:package/ns:metadata/ns:$nodeName" -Namespace $XmlNamespace;
		}
	}

	if ($node -eq $null)
	{
		echo "Can't find node $nodeName"
	}

	return $node.Node.Innertext
}

function SetMetadataValue
{
	Param ([string]$xmlFile, [string]$nodeName, [string]$value)

	Write-Host "Attempting to load file $xmlFile"
	$xmlObject = New-Object -TypeName 'System.XML.XMLDocument'
	$xmlObject.Load((Get-Item $xmlFile))

	$node = $null
	Write-Host "Attempting to get package node"
	$packageNode = $xmlObject.ChildNodes | Where-Object { $_.GetType().ToString() -eq "System.Xml.XmlElement" } | Where-Object { $_.Name -eq "package" } | Select -First 1
	if (!($packageNode -eq $null))
	{
		if ([string]::IsNullOrEmpty($packageNode.NamespaceURI))
		{
			$node = Select-Xml -Xml $xmlObject -XPath "/package/metadata/$nodeName";
		}
		else
		{
			$XmlNamespace = @{ ns = $packageNode.NamespaceURI; };
			$node = Select-Xml -Xml $xmlObject -XPath "/ns:package/ns:metadata/ns:$nodeName" -Namespace $XmlNamespace;
		}
	}

	if ($node -eq $null)
	{
		Write-Host "Can't find node $nodeName"
	}

	Write-Host "Set $nodeName value from $node.Node.InnerText to $value"
	$node.Node.InnerText = $value;
	Write-Host "Attempting to save file $xmlFile"
	$xmlObject.Save($xmlFile);
}

Trace-VstsEnteringInvocation $MyInvocation

$dropFolderPath = Get-VstsInput -Name dropFolderPath -Require
$nuspecFileName = Get-VstsInput -Name nuspecFileName -Require
$modelVersionFileName = Get-VstsInput -Name modelVersionFileName -Require
$forceToVersion = Get-VstsInput -Name forceToVersion

Write-Host "Parameters : nuspecFileName=$nuspecFileName, modelVersionFileName=$modelVersionFileName, forceToVersion=$forceToVersion"
Write-Host "Starting NugetVersionSynchronizerTask"

try {
	Write-Host "Location : $dropFolderPath"
	Set-Location "$dropFolderPath"
	$file = Get-Item "$modelVersionFileName"
	$nuspecFile = New-Object -TypeName 'System.XML.XMLDocument'
	$nuspecFile.Load((Get-Item "$dropFolderPath\$nuspecFileName"))

	if ($file -ne $null -and $nuspecFile -ne $null)
	{
		$nuspecVersion = [version](GetMetadataValue $nuspecFile "version")
		if (-not [string]::IsNullOrEmpty($forceToVersion))
		{
			# change nuspec version
			Write-Host "Attempting to force set version $forceToVersion to nuspec file $dropFolderPath\$nuspecFileName"
			SetMetadataValue "$dropFolderPath\$nuspecFileName" "version" $forceToVersion
		}
		else
		{
			# synchronize version from assembly to nuspec
			$assemblyVersion = [version]([System.Diagnostics.FileVersionInfo]::GetVersionInfo($file).FileVersion)
			Write-Host "Assembly version of $file is v.$assemblyVersion"
			Write-Host "Nuspec version of $nuspecFile is v.$nuspecVersion"

			if ($compareTo -ne 0)
			{
				# change nuspec version and checkin
				SetMetadataValue "$dropFolderPath\$nuspecFileName" "version" $assemblyVersion
				Write-Host "Set version $assemblyVersion to nuspec file $dropFolderPath\$nuspecFileName"
			}
		}
	}
	else
	{
		Write-Error "Can't reach files $modelVersionFileName or $dropFolderPath\$nuspecFileName"
	}
}
catch {
	Write-Error $_.Exception.Message
}
finally {
	Trace-VstsLeavingInvocation $MyInvocation
}

Write-Host "Ending NugetVersionSynchronizerTask"