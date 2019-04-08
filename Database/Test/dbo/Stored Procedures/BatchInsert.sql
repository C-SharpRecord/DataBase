CREATE PROCEDURE [dbo].[BatchInsert]
	@flag BIT  = 0
AS
BEGIN
	DECLARE @total BIGINT  = 1;
	DECLARE @result INT  = 0;
	DECLARE @index INT = 1;
	IF(@flag = 0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			WHILE(@total <= 5000000)
			BEGIN 
				IF(@index = 5000)
				BEGIN
					COMMIT  TRANSACTION 
					BEGIN TRANSACTION
					INSERT INTO Inf_Test_PS VALUES(CONVERT(NVARCHAR(100),@total))
					SET @index = 1;
				END
				ELSE 
				BEGIN
					INSERT INTO Inf_Test_PS VALUES(CONVERT(NVARCHAR(100),@total))
					SET  @index = @index + 1;
				END
				SET  @total = @total + 1;
			END 
			COMMIT  TRANSACTION 
		END TRY
		BEGIN CATCH 
			ROLLBACK  TRANSACTION 
			SET  @result=-1;
			GOTO  _result;
		END CATCH
	END    
	_result:
	SELECT  @result;
END