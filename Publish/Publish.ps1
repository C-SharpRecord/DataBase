#
# Script.ps1
# Set-ExecutionPolicy -Scope CurrentUser
# remotesigned
.(".\CommonFun.ps1")
$vsdevCmdPath=[system.io.path]::Combine($env:VS140COMNTOOLS,"VsDevCmd.bat")
#${env:ProgramFiles(x86)}由于环境变量里有（）因此需要加{}
$msbuild=[System.IO.Path]::Combine(${env:ProgramFiles(x86)},"MSBuild\14.0\Bin","MSBuild.exe")

if([system.io.file]::Exists($vsdevCmdPath))
{
	Execute $vsdevCmdPath
}	
else
{
	Write-Host "未找到" + $vsdevCmdPath + "需要安装VS2015"
}

pause