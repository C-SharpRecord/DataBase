/*
  增加日志文件 unlimited 无限制增长 增长百分比10% 或者为大小10MB
*/
ALTER DATABASE [$(DataBaseName)]
ADD  LOG  FILE 
(
	NAME = [Test_Log],
	FILENAME = '$(SpecifiedLogPath)$(DefaultFilePrefix)_Log.ldf',
	SIZE = 10 MB,
	MAXSIZE = unlimited,
	FILEGROWTH = 10%
)