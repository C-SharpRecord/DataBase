/*
请不要更改数据库路径或名称变量。在生
成和部署过程中，将会对 sqlcmd 变量
进行适当的替换。
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [FG2_File],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_FG2_File.ndf',
	    SIZE = 10 MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	)
 TO FILEGROUP [FG2]
--ALTER DATABASE [Test]  REMOVE FILE [FG2_File]	删除文件