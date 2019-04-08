#
# Deploy.ps1
#
.(".\DeployFunction.ps1")

if([System.String]::IsNullOrEmpty($DBRootPath))
{
	Write-Host "������Deploy_Setup.ps1..."
	Write-Host "��������˳�"
	[System.Console]::ReadKey() | Out-Null
	return ""
}

$nowDir=Get-Location
Write-Host "��ʼ����/�������ݿ�ű�..."


Write-Host "����Test��"
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

