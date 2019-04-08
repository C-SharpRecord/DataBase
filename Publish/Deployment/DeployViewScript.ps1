#
# DeployViewScript.ps1
#
if([System.String]::IsNullOrEmpty($DBRootPath))
{
	Write-Host "������Deploy_Setup.ps1..."
	Write-Host "��������˳�"
	[System.Console]::ReadKey() | Out-Null
	return ""
}

$nowDir=Get-Location
Write-Host "��ʼ�������ݿ�ű�..."

$previewDir=[System.IO.Path]::Combine($nowDir,"Preview")
if(![System.IO.Directory]::Exists($previewDir))
{
	[System.IO.Directory]::CreateDirectory($previewDir)
}

