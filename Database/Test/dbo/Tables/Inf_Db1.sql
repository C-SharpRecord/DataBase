CREATE TABLE [dbo].[Inf_Db1]
(
	[Id] bigint NOT NULL  IDENTITY, 
	[Key]  nvarchar(50) not null,
    [Name] NVARCHAR(100) NOT NULL, 
	[Total] int null,
    [Desp] NVARCHAR(1024) NULL, 
    CONSTRAINT [PK_Inf_Db1] PRIMARY KEY ([Id])
) ON [PRIMARY]

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'名称',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Db1',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'描述',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Db1',
    @level2type = N'COLUMN',
    @level2name = N'Desp'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'测试表1',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Db1',
    @level2type = NULL,
    @level2name = NULL
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
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'关键字',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Db1',
    @level2type = N'COLUMN',
    @level2name = N'Key'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'个数',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Db1',
    @level2type = N'COLUMN',
    @level2name = N'Total'