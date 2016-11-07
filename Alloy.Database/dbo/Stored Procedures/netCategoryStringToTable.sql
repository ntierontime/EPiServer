CREATE PROCEDURE dbo.netCategoryStringToTable
(
	@CategoryList	NVARCHAR(2000)
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE		@DotPos INT
	DECLARE		@Category NVARCHAR(255)
	DECLARE @CategoryResult TABLE(fkCategoryID INT)
	
	WHILE (DATALENGTH(@CategoryList) > 0)
	BEGIN
		SET @DotPos = CHARINDEX(N',', @CategoryList)
		IF @DotPos > 0
			SET @Category = LEFT(@CategoryList,@DotPos-1)
		ELSE
		BEGIN
			SET @Category = @CategoryList
			SET @CategoryList = NULL
		END
		IF LEN(@Category) > 0 AND @Category NOT LIKE '%[^0-9]%'
		    INSERT INTO @CategoryResult SELECT pkID FROM tblCategory WHERE pkID = CAST(@Category AS INT)
		ELSE
			INSERT INTO @CategoryResult SELECT pkID FROM tblCategory WHERE CategoryName = @Category
			
		IF (DATALENGTH(@CategoryList) > 0)
			SET @CategoryList = SUBSTRING(@CategoryList,@DotPos+1,255)
	END
	SELECT * FROM @CategoryResult
END
