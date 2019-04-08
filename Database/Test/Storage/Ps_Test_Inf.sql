CREATE PARTITION SCHEME [Ps_Test_Inf]
	AS PARTITION [Pf_Data]
	TO ([FG1], [FG2], [FG3],[FG3])

--归档数据将已经分区了的数据归档到历史数据中
--ALTER TABLE dbo.[Inf_Test_PS] SWITCH PARTITION 1 TO [dbo].[Inf_Test_PS_History] PARTITION 1 
--查询某个数据所在分区号数据库.$partition.分区函数(值)
--select  Test.$partition.pf_data(100000)
--查询某一个分区的数据
--select count(1) from [dbo].[Inf_Test_PS] where $partition.pf_data(id) =1 
--查询最大分区号
--select  max($partition.pf_data(id)) from [dbo].[Inf_Test_PS]
--添加分区
--指定新分区的数据存储在那个文件组
--ALTER PARTITION SCHEME [Ps_Test_Inf] NEXT USED FG1  
--ALTER PARTITION FUNCTION Pf_Data() SPLIT RANGE (40000) 
--删除分区又称为合并分区
--ALTER PARTITION FUNCTION Pf_Data() MERGE RANGE (10000) 
--select * from sys.partition_functions    
--select * from sys.partition_range_values 
--select * from sys.partition_schemes
