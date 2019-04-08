#
# DeployViewScript.ps1
#
if([System.String]::IsNullOrEmpty($DBRootPath))
{
	Write-Host "请运行Deploy_Setup.ps1..."
	Write-Host "按任意键退出"
	[System.Console]::ReadKey() | Out-Null
	return ""
}

$nowDir=Get-Location
Write-Host "开始生成数据库脚本..."

$previewDir=[System.IO.Path]::Combine($nowDir,"Preview")
if(![System.IO.Directory]::Exists($previewDir))
{
	[System.IO.Directory]::CreateDirectory($previewDir)
}

