/*
Test 的部署脚本

此代码由工具生成。
如果重新生成此代码，则对此文件的更改可能导致
不正确的行为并将丢失。
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar SpecifiedLogPath "d:\database"
:setvar DatabaseName "Test"
:setvar DefaultFilePrefix "Test"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
请检测 SQLCMD 模式，如果不支持 SQLCMD 模式，请禁用脚本执行。
要在启用 SQLCMD 模式后重新启用脚本，请执行:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'要成功执行此脚本，必须启用 SQLCMD 模式。';
        SET NOEXEC ON;
    END


GO
PRINT N'正在创建 [FG1]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILEGROUP [FG1];


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [FG1_7DF55F19], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_FG1_7DF55F19.mdf') TO FILEGROUP [FG1];


GO
PRINT N'正在创建 [FG2]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILEGROUP [FG2];


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [FG2_24404C84], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_FG2_24404C84.mdf') TO FILEGROUP [FG2];


GO
PRINT N'正在创建 [FG3]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILEGROUP [FG3];


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [FG3_7BA2EE18], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_FG3_7BA2EE18.mdf') TO FILEGROUP [FG3];


GO
USE [$(DatabaseName)];


GO
PRINT N'更新完成。';


GO
