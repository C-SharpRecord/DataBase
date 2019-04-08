#
# DeployFunction.ps1
#
function CheckRootPath($rootPath)
{
    if([System.String]::IsNullOrEmpty($rootPath))
    {
        Write-Host "存储路径不能为空..."
        Write-Host "任意键退出..."
        [System.Console]::ReadLine() | Out-Null
        return $false
    }

    if(![System.IO.Directory]::Exists($rootPath))
    {
        try
        {
            [System.IO.Directory]::CreateDirectory($rootPath)
        }
        catch
        {
            Write-Host "路径不是有效路径..."
            Write-Host "任意键退出..."
            [System.Console]::ReadLine() | Out-Null
            return $false
        }
    }
    return $true
}

function ExecuteInitData($logFilePath,$isLog,$isScript)
{
    $rootPath = [System.IO.Path]::Combine((Get-Location).ToString(),"Initial Data")

    if(![System.IO.Directory]::Exists($rootPath))
    {
        return ""
    }

    $files=[System.IO.Directory]::GetFiles($rootPath,"*.Table.sql",[System.IO.SearchOption]::AllDirectories)

    foreach($item in $files)
    {
        $fi=[System.IO.FileInfo]$item
        $dbName=$fi.Directory.Name
        
        if($dbServer_S -ne "" -and $dbUserName -ne "" -and $dbPassword_P -ne "")
        {
            $result=& sqlcmd -S "$dbServer_S" -U "$dbUserName" -P "$dbPassword_P" -Q ":Exit(select count(*) from sys.databases where name='$dbName')"
        }
        else
        {
            $result=& sqlcmd -Q ":Exit(select count(*) from sys.databases where name='$dbName')"
        }
		
        if($result[2].Trim(' ') -ne 1)
        {
            continue
        }

        if(!$isScript)
        {
            if($dbServer_S -ne "" -and $dbUserName -ne "" -and $dbPassword_P -ne "")
            {
                & sqlcmd -S "$dbServer_S" -U "$dbUserName" -P "$dbPassword_P" /i $item
            }
            else
            {
                & sqlcmd /i $item
            }
        }

    }
}