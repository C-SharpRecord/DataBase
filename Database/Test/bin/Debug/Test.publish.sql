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
:setvar SpecifiedLogPath "D:\DataBase\Log"
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
PRINT N'正在创建 [Test_Inf]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILEGROUP [Test_Inf];


GO
PRINT N'正在创建 [Test_Inf_File]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [Test_Inf_File], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFile1.ndf', SIZE = 10 MB, FILEGROWTH = 10 %) TO FILEGROUP [Test_Inf];


GO
PRINT N'正在创建 [Test_File]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [Test_File], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix).mdf', SIZE = 10 MB, FILEGROWTH = 1024 KB) TO FILEGROUP [PRIMARY];


GO
PRINT N'正在创建 [Test_Log_File]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD LOG FILE (NAME = [Test_Log_File], FILENAME = '$(SpecifiedLogPath)$(DefaultFilePrefix)_Log.ldf', SIZE = 10 MB, FILEGROWTH = 10 %);


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
PRINT N'正在创建 [dbo].[Inf_Db1]...';


GO
CREATE TABLE [dbo].[Inf_Db1] (
    [Id]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [Key]   NVARCHAR (50)   NOT NULL,
    [Name]  NVARCHAR (100)  NOT NULL,
    [Total] INT             NULL,
    [Desp]  NVARCHAR (1024) NULL,
    CONSTRAINT [PK_Inf_Db1] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Inf_Test2]...';


GO
CREATE TABLE [dbo].[Inf_Test2] (
    [Id]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [Key]   NVARCHAR (50)   NOT NULL,
    [Name]  NVARCHAR (100)  NOT NULL,
    [Total] INT             NULL,
    [Desp]  NVARCHAR (1024) NULL,
    CONSTRAINT [PK_Inf_Test2] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [Test_Inf];


GO
PRINT N'正在创建 [dbo].[trg_Db1_SysDb2]...';


GO

CREATE TRIGGER [dbo].[trg_Db1_SysDb2]
    ON [dbo].[Inf_Db1]
    FOR INSERT, UPDATE
    AS
		declare @sql nvarchar(2048)
		declare @table table([Id] bigint NOT NULL  IDENTITY, 
							 [Key]  nvarchar(50) not null,
							 [Name] NVARCHAR(100) NOT NULL, 
							 [Total] int null,
							 [Desp] NVARCHAR(1024) NULL)
		declare @total int
		declare @index int
		declare @key nvarchar(50)
		declare @name NVARCHAR(100)
		declare @desp NVARCHAR(1024)
		declare @totalCol int
    BEGIN
        SET NoCount ON
		if exists(select * from inserted)
		begin
			insert into @table select [key],[Name],[Total],[Desp] from inserted
			select @total=max(ID) from @table
			while (@index <= @total)
			begin
				select @key=[Key],@name=[Name],@totalCol=[Total],@desp=[Desp] from @table where Id=@index
				if exists(select [key] from [dbo].[Inf_Test2] where [Key]=@key)
				begin
					--执行update
					update [dbo].[Inf_Test2] set [Name]=@name, [Total]=@totalCol,[Desp]=@desp where [Key]=@key
					--动态sql执行
					--set @sql='update [dbo].[Inf_Test2] set [Name]='+@name+', [Total]='+@totalCol+',[Desp]='+@desp+' where [Key]='+@key+''
					--exec sp_executesql @sql  -- 有参数时exec sp_executesql @sql, N'@totalCol int out',@totalCol,如果为输入出参数省略out，多个参数分别用，号隔开
				end
				else
				begin
					--执行insert
					insert into [dbo].[Inf_Test2]([Key],[Name],[Total],[Desp]) values(@key,@name,@totalCol,@desp)
					--动态sql执行
					--set @sql='insert into [Test].[dbo].[Inf_Test2]([Key],[Name],[Desp]) values(N'+@key+',N'+Replace(@name,'''','''''')+','+Convert(nvarchar(50),@totalCol)+',N'+Replace(@desp,'''','''''')+')'
					--exec(@sql)
				end
			end
		end
		SET NoCount Off
    END
GO
PRINT N'正在创建 [dbo].[Inf_Db1].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'测试表1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Db1';


GO
PRINT N'正在创建 [dbo].[Inf_Db1].[Key].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'关键字', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Db1', @level2type = N'COLUMN', @level2name = N'Key';


GO
PRINT N'正在创建 [dbo].[Inf_Db1].[Name].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Db1', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'正在创建 [dbo].[Inf_Db1].[Total].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'个数', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Db1', @level2type = N'COLUMN', @level2name = N'Total';


GO
PRINT N'正在创建 [dbo].[Inf_Db1].[Desp].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Db1', @level2type = N'COLUMN', @level2name = N'Desp';


GO
PRINT N'正在创建 [dbo].[Inf_Test2].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'测试表2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Test2';


GO
PRINT N'正在创建 [dbo].[Inf_Test2].[Key].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'关键字', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Test2', @level2type = N'COLUMN', @level2name = N'Key';


GO
PRINT N'正在创建 [dbo].[Inf_Test2].[Name].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Test2', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'正在创建 [dbo].[Inf_Test2].[Total].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'个数', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Test2', @level2type = N'COLUMN', @level2name = N'Total';


GO
PRINT N'正在创建 [dbo].[Inf_Test2].[Desp].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Inf_Test2', @level2type = N'COLUMN', @level2name = N'Desp';


GO
PRINT N'更新完成。';


GO
