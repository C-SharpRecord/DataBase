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


Write-Host "创建Test库"
$dbPath=[System.IO.Path]::Combine($DBRootPath,"Test")
if(![System.IO.Directory]::Exists($dbPath))
{
	[System.IO.Directory]::CreateDirectory($dbPath)
}
$env:DatabaseName="Test"
$env:DefaultFilePrefix="Test"
$env:DefaultDataPath=$dbPath+"\"
$env:SpecifiedLogPath=$dbPath+"\"
if([System.String]::IsNullOrEmpty($dbLoginParams))
{
	& "$SqlPackagePath" /a:Publish /sourcefile:"$nowDir\DACPAC\Test.dacpac" /Profile:"$nowDir\Profile\Test.publish.xml" /TargetDatabaseName:Test /p:CommentOutSetVarDeclarations=True
}
else
{
	& "$SqlPackagePath" /TargetServerName:"$dbServer_S" /TargetUser:"$dbUserName" /TargetPassword:"$dbPassword_P" /a:Publish /sourcefile:"$nowDir\DACPAC\Test.dacpac" /Profile:"$nowDir\Profile\Test.publish.xml" /TargetDatabaseName:Test /p:CommentOutSetVarDeclarations=True
}
ExecuteInitData $logFilePath $isLog $isScript 

