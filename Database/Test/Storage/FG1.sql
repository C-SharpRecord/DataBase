/*
请不要更改数据库路径或名称变量。在生
成和部署过程中，将会对 sqlcmd 变量
进行适当的替换。
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILEGROUP [FG1]
