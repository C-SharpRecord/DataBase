#
# Publish_VS17.ps1
#
.(".\CommonFun.ps1")

$vswhere="C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
#vs2017�İ�װ·��D:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise
$vspath=& $vswhere -latest -products * -requires Microsoft.Component.MSBuild  -property installationPath

$vsdevCmdPath=[system.io.path]::Combine($vspath,"Common7\Tools","VsDevCmd.bat")
$msbuild=[System.IO.Path]::Combine($vspath,"MSBuild\15.0\Bin","MSBuild.exe")

if([system.io.file]::Exists($vsdevCmdPath))
{
	Execute $vsdevCmdPath
}	
else
{
	Write-Host "��Ҫ��װ VS 2017..." 
}
pause