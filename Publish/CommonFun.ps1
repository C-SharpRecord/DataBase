#
# CommonFun.ps1
#

function Execute([system.string]$vsdevCmdPath)
{
    Write-Host "初始化.."
    #执行脚本VsDevCmd.bat
	& $vsdevCmdPath

	$targetAcion="build"
	$UpdateDatebase="False"
	# D:\Prg\DatabasePrg\Publish
    $slnDir=Get-Location
    $location=$slnDir
    $slnDirInfo=New-Object -TypeName System.IO.DirectoryInfo $slnDir
	# D:\Prg\DatabasePrg\
	$slnDir=$slnDirInfo.Parent.FullName
	# D:\Prg\DatabasePrg\Deployment
	$dirName="Deployment"
    $desLocation=[System.IO.Path]::Combine($slnDir,$dirName)
	$location=[System.IO.Path]::Combine($location,$dirName)
    # 将生成的脚本和发布脚本拷贝到$location目录下
    if([System.IO.Directory]::Exists($desLocation))
    {
        [System.IO.Directory]::Delete($desLocation,$true)
    }
    Copy-Item -Path $location  -Destination $desLocation -Recurse -Force
	#将项目的数据库部署框架拷贝到输出目录
	$slnDir = [System.IO.Path]::Combine($slnDir,"Database")
    #调用函数
	CopyDataBaseItem $slnDir $desLocation $targetAcion $UpdateDatebase
}

### $slnDir 数据库项目路径
### $desLocation 生成目录路径
function CopyDataBaseItem([string]$slnDir,[string]$desLocation, $targetAcion, $UpdateDatebase)
{
	foreach($item in [System.IO.Directory]::EnumerateFiles($slnDir,"*.sqlproj",[System.IO.SearchOption]::AllDirectories))
	{
		$fi=[System.IO.FileInfo]$item
        Write-Host($item)

        $dbName=$fi.Directory.Name
        $nowDir=$fi.Directory.FullName

		Write-Host($msbuild)

		& $msbuild /t:$targetAcion /p:UpdateDatabase=$UpdateDatebase $item

		#拷贝DACPAC到目标路径
		$srcDacpac=[system.io.path]::Combine($nowDir,"bin\Debug","$dbName.dacpac")
		$desDacpac=[System.IO.Path]::Combine($desLocation,"DACPAC","$dbName.dacpac")
		Copy-Item -Path $srcDacpac -Destination $desDacpac -Recurse -Force

		#拷贝*publish.xml到目标路径
		$srcXml=[System.IO.Path]::Combine($nowDir,"$dbName.publish.xml")
		$desXml=[System.IO.Path]::Combine($desLocation,"Profile","$dbName.publish.xml")
		Copy-Item -Path $srcXml -Destination  $desXml -Recurse -Force

		$srcInit=[system.io.path]::Combine($nowDir,"Initial Data")
        if([System.IO.Directory]::Exists($srcInit))
        {
		    $desInit=[system.io.path]::Combine($desLocation,"Initial Data",$dbName)
		    Copy-Item -Path $srcInit -Destination $desInit -Recurse -Force
        }
		ModifyDeployScript $desLocation $dbName $nowDir

	}
}

### $desLocation目标Deployment文件路径
### $item数据库项目.sqlproj同级路径
### 修改部署脚本Deploy.ps1和日志生成脚本DeployViewScript.ps1
function ModifyDeployScript([System.String]$desLocation,[System.String]$dbName,[System.String]$nowDir)
{	
	$deployFile=[System.IO.Path]::Combine($desLocation,"Deploy.ps1")
	$deployViewScripyFile=[System.IO.Path]::Combine($desLocation,"DeployViewScript.ps1")

	$deployContent="Write-Host ""创建"+$dbName+"库"""
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='$dbPath=[System.IO.Path]::Combine($DBRootPath,"'+$dbName+'")'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='if(![System.IO.Directory]::Exists($dbPath))'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='{'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='	[System.IO.Directory]::CreateDirectory($dbPath)'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='}'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='$env:DatabaseName="'+$dbName+'"'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='$env:DefaultFilePrefix="'+$dbName+'"'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='$env:DefaultDataPath=$dbPath+"\"'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='$env:SpecifiedLogPath=$dbPath+"\"'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='if([System.String]::IsNullOrEmpty($dbLoginParams))'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='{'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='	& "$SqlPackagePath" /a:Publish /sourcefile:"$nowDir\DACPAC\'+$dbName+'.dacpac" /Profile:"$nowDir\Profile\'+$dbName+'.publish.xml" /TargetDatabaseName:'+$dbName+' /p:CommentOutSetVarDeclarations=True'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='}'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='else'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='{'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='	& "$SqlPackagePath" /TargetServerName:"$dbServer_S" /TargetUser:"$dbUserName" /TargetPassword:"$dbPassword_P" /a:Publish /sourcefile:"$nowDir\DACPAC\'+$dbName+'.dacpac" /Profile:"$nowDir\Profile\'+$dbName+'.publish.xml" /TargetDatabaseName:'+$dbName+' /p:CommentOutSetVarDeclarations=True'
	Add-Content -Path $deployFile -Value $deployContent	
	$deployContent='}'
	Add-Content -Path $deployFile -Value $deployContent	
    $deployContent='ExecuteInitData $logFilePath $isLog $isScript '
    Add-Content -Path $deployFile -Value $deployContent
    Add-Content -Path $deployFile -Value ""

    $viewContent="Write-Host ""创建"+$dbName+"库"""
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='$dbPath=[System.IO.Path]::Combine($DBRootPath,"'+$dbName+'")'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='if(![System.IO.Directory]::Exists($dbPath))'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='{'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='	[System.IO.Directory]::CreateDirectory($dbPath)'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='}'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='$env:DatabaseName="'+$dbName+'"'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='$env:DefaultFilePrefix="'+$dbName+'"'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='$env:DefaultDataPath=$dbPath+"\"'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='$env:SpecifiedLogPath=$dbPath+"\"'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
	$viewContent='	& "$SqlPackagePath" /a:Script /sourcefile:"$nowDir\DACPAC\'+$dbName+'.dacpac" /Profile:"$nowDir\Profile\'+$dbName+'.publish.xml" /TargetDatabaseName:'+$dbName+' /p:CommentOutSetVarDeclarations=True /OutputPath:"$nowDir\Preview\'+$dbName+'.publish.xml"'
	Add-Content -Path $deployViewScripyFile -Value $viewContent	
    Add-Content -Path $deployViewScripyFile -Value ""
}