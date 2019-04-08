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
        Write-Host "��Ҫ��װ DACFramework.msi..."
        Write-Host "��������˳�..."
        [System.Console]::ReadKey() | Out-Null
        return ""
    }
}

Write-Host "�������ݿ�洢·��:" -NoNewline
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

Write-Host "�Ƿ��ṩ���ݿ��˺�����[Y/N]:" -NoNewline
$check=[system.console]::ReadLine()

if($check -eq "Y")
{
    Write-Host "�������ݿ��ַ(ip or host):" -NoNewline
    $dbServer_S=[System.Console]::ReadLine()
    Write-Host "�����û�:" -NoNewline
    $dbUserName=[System.Console]::ReadLine()
    Write-Host "��������:" -NoNewline
    $dbPassword_P=[System.Console]::ReadLine()

    $dbLoginParams=" /TargetServerName:""$dbServer_S"""+" /TargetUser: ""$dbUserName"""+" /TargetPassword:""$dbPassword_P"""
    $sqlcmdLoginParams=" -S ""$dbServer_S"""+" -U ""$dbUserName"""+" -P ""$dbPassword_P"""
}

$isLog=$false
$logFilePath=[System.IO.Path]::Combine((Get-Location).ToString(),"log.txt")
$isScript=$false

Write-Host "�Ƿ������־���ļ���[Y/N]:" -NoNewline
$check=[System.Console]::ReadLine()

if($check -eq "Y")
{
    $isLog=$true
}

Write-Host "�Ƿ�����ɽű�[Y/N]:" -NoNewline
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
    Write-Host "��ʼִ��..."
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
    Write-Host "$execBatPath �ļ�������"
}

Write-Host "�������"
Write-Host "���������..." -NoNewline
$temp=[System.Console]::ReadLine()


