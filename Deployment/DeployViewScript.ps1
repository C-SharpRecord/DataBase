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
	& "$SqlPackagePath" /a:Script /sourcefile:"$nowDir\DACPAC\Test.dacpac" /Profile:"$nowDir\Profile\Test.publish.xml" /TargetDatabaseName:Test /p:CommentOutSetVarDeclarations=True /OutputPath:"$nowDir\Preview\Test.publish.xml"

