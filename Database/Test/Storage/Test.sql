/*
	增加文件组，建表时根据需要选择合适的文件组
*/
ALTER DATABASE [$(DataBaseName)]
ADD FILE
(
	NAME = [Test],
	FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix).mdf',
	SIZE = 10 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024kb
)
TO FILEGROUP [PRIMARY]