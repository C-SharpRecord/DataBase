CREATE TABLE [dbo].[Inf_Test2]
(
	[Id] bigint NOT NULL IDENTITY, 
	[Key]  nvarchar(50) not null,
    [Name] NVARCHAR(100) NOT NULL, 
	[Total] int null,
    [Desp] NVARCHAR(1024) NULL, 
    CONSTRAINT [PK_Inf_Test2] PRIMARY KEY ([Id]) 
) ON [Test_FileGroup]

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'描述',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test2',
    @level2type = N'COLUMN',
    @level2name = N'Desp'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'名称',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test2',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'测试表2',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test2',
    @level2type = NULL,
    @level2name = NULL
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'关键字',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test2',
    @level2type = N'COLUMN',
    @level2name = N'Key'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'个数',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test2',
    @level2type = N'COLUMN',
    @level2name = N'Total'