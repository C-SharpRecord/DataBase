CREATE TABLE [dbo].[Inf_Test_PS]
(
	[Id] BIGINT NOT NULL IDENTITY, 
    [Name] NVARCHAR(100) NULL, 
    CONSTRAINT [PK_Inf_Test_PS] PRIMARY KEY ([Id])
)
ON Ps_Test_Inf(Id)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'主键',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test_PS',
    @level2type = N'COLUMN',
    @level2name = N'Id'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'名称',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test_PS',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'测试分区表',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Inf_Test_PS',
    @level2type = NULL,
    @level2name = NULL