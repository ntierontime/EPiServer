CREATE PROCEDURE dbo.netPageDefinitionConvertSave
(
	@PageDefinitionID INT,
	@PageID INT = NULL,
	@WorkPageID INT = NULL,
	@LanguageBranchID INT = NULL,
	@Type INT,
	@ScopeName NVARCHAR(450) = NULL,
	@Boolean BIT = NULL,
	@IntNumber INT = NULL,
	@FloatNumber FLOAT = NULL,
	@PageType INT = NULL,
	@LinkGuid uniqueidentifier = NULL,
	@PageReference INT = NULL,
	@DateValue DATETIME = NULL,
	@String NVARCHAR(450) = NULL,
	@LongString NVARCHAR(MAX) = NULL,
	@DeleteProperty BIT = 0
)
AS
BEGIN
	IF NOT @WorkPageID IS NULL
	BEGIN		
		IF @DeleteProperty=1 OR (@Type=0 AND @Boolean=0) OR @Type > 7
			DELETE FROM tblWorkProperty 
			WHERE fkPageDefinitionID=@PageDefinitionID AND fkWorkPageID=@WorkPageID AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
		ELSE
		BEGIN
			UPDATE tblWorkProperty
				SET
					Boolean=@Boolean,
					Number=@IntNumber,
					FloatNumber=@FloatNumber,
					PageType=@PageType,
					LinkGuid = @LinkGuid,
					PageLink=@PageReference,
					Date=@DateValue,
					String=@String,
					LongString=@LongString
			WHERE fkPageDefinitionID=@PageDefinitionID AND fkWorkPageID=@WorkPageID AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
		END
	END
	ELSE
	BEGIN
		IF @DeleteProperty=1 OR (@Type=0 AND @Boolean=0) OR @Type > 7
			DELETE FROM tblProperty 
			WHERE fkPageDefinitionID=@PageDefinitionID AND fkPageID=@PageID AND fkLanguageBranchID = @LanguageBranchID AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
		ELSE
		BEGIN
			UPDATE tblProperty
				SET
					Boolean=@Boolean,
					Number=@IntNumber,
					FloatNumber=@FloatNumber,
					PageType=@PageType,
					PageLink=@PageReference,
					LinkGuid = @LinkGuid,
					Date=@DateValue,
					String=@String,
					LongString=@LongString
			WHERE fkPageDefinitionID=@PageDefinitionID AND fkPageID=@PageID AND fkLanguageBranchID = @LanguageBranchID AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
		END
	END
END
