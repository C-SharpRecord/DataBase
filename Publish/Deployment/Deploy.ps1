#
# Deploy.ps1
#
.(".\DeployFunction.ps1")

if([System.String]::IsNullOrEmpty($DBRootPath))
{
	Write-Host "请运行Deploy_Setup.ps1..."
	Write-Host "按任意键退出"
	[System.Console]::ReadKey() | Out-Null
	return ""
}

$nowDir=Get-Location
Write-Host "开始创建/更新数据库脚本..."


