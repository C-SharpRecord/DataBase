#
# Deploy_Setup.ps1
#
.(".\DeployFunction.ps1")

$sqlPackageDir=[System.IO.Path]::Combine("${env:ProgramFiles(x86)}","Microsoft SQL Server")
$sqlPackagePath="";
foreach($item in [System.IO.Directory]::GetFiles($sqlPackageDir,"SqlPackage.exe",[System.IO.SearchOption]::AllDirectories))
{
    $sqlPackagePath = ([System.IO.FileInfo]$item).FullName
    break;
}

if(![System.IO.File]::Exists($sqlPackagePath))
{
    $sqlPackageDir=[System.IO.Path]::Combine("${env:ProgramFiles}","Microsoft SQL Server")
    foreach($item in [System.IO.Directory]::GetFiles($sqlPackageDir,"SqlPackage.exe",[System.IO.SearchOption]::AllDirectories))
    {
        $sqlPackagePath = ([System.IO.FileInfo]$item).FullName
        break;
    }
    if(![System.IO.File]::Exists($sqlPackagePath))
    {
        Write-Host "需要安装 DACFramework.msi..."
        Write-Host "按任意键退出..."
        [System.Console]::ReadKey() | Out-Null
        return ""
    }
}

Write-Host "输入数据库存储路径:" -NoNewline
$DBRootPath=[System.Console]::ReadLine()

if(!(CheckRootPath $DBRootPath))
{ 
    return ""
}

$dbServer_S=""
$dbUserName=""
$dbPassword_P=""

$dbLoginParams=""
$sqlcmdLoginParams=""

Write-Host "是否提供数据库账号密码[Y/N]:" -NoNewline
$check=[system.console]::ReadLine()

if($check -eq "Y")
{
    Write-Host "输入数据库地址(ip or host):" -NoNewline
    $dbServer_S=[System.Console]::ReadLine()
    Write-Host "输入用户:" -NoNewline
    $dbUserName=[System.Console]::ReadLine()
    Write-Host "输入密码:" -NoNewline
    $dbPassword_P=[System.Console]::ReadLine()

    $dbLoginParams=" /TargetServerName:""$dbServer_S"""+" /TargetUser: ""$dbUserName"""+" /TargetPassword:""$dbPassword_P"""
    $sqlcmdLoginParams=" -S ""$dbServer_S"""+" -U ""$dbUserName"""+" -P ""$dbPassword_P"""
}

$isLog=$false
$logFilePath=[System.IO.Path]::Combine((Get-Location).ToString(),"log.txt")
$isScript=$false

Write-Host "是否输出日志到文件中[Y/N]:" -NoNewline
$check=[System.Console]::ReadLine()

if($check -eq "Y")
{
    $isLog=$true
}

Write-Host "是否仅生成脚本[Y/N]:" -NoNewline
$check=[System.Console]::ReadLine()

if($check -eq "Y")
{
    $isScript=$true
}

$execBatPath=""

if($isScript)
{
    $execBatPath=[System.IO.Path]::Combine((Get-Location).ToString(),"DeployViewScript.ps1")
}
else
{
    $execBatPath=[System.IO.Path]::Combine((Get-Location).ToString(),"Deploy.ps1")
}

if([System.IO.File]::Exists($execBatPath))
{
    Write-Host "开始执行..."
    if($isLog)
    {
        & $execBatPath | Out-File -FilePath $logFilePath
    }
    else
    {
        & $execBatPath
    }
}
else
{
    Write-Host "$execBatPath 文件不存在"
}

Write-Host "操作完成"
Write-Host "任意键继续..." -NoNewline
$temp=[System.Console]::ReadLine()


