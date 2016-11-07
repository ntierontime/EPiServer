CREATE PROCEDURE dbo.netContentTrimVersions
(
	@ContentID		INT,
	@MaxVersions	INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @ObsoleteVersions	INT
	DECLARE @DeleteWorkContentID	INT
	DECLARE @retval		INT
	DECLARE @CurrentLanguage 	INT
	DECLARE @FirstLanguage	BIT
	SET @FirstLanguage = 1
	
	IF (@MaxVersions IS NULL OR @MaxVersions=0)
		RETURN 0
		
		CREATE TABLE #languages (fkLanguageBranchID INT)
		INSERT INTO #languages SELECT DISTINCT(fkLanguageBranchID) FROM tblWorkContent WITH(INDEX(IDX_tblWorkContent_fkContentID)) WHERE fkContentID = @ContentID 
		SET @CurrentLanguage = (SELECT MIN(fkLanguageBranchID) FROM #languages)
		
		WHILE (NOT @CurrentLanguage = 0)
		BEGIN
			DECLARE @PublishedVersion INT
			SELECT @PublishedVersion = [Version] FROM tblContentLanguage WHERE fkContentID=@ContentID AND fkLanguageBranchID=@CurrentLanguage AND Status = 4
			SELECT @ObsoleteVersions = COUNT(pkID)+CASE WHEN @PublishedVersion IS NULL THEN 0 ELSE 1 END FROM tblWorkContent  WITH(NOLOCK) WHERE fkContentID=@ContentID AND Status = 5 AND fkLanguageBranchID=@CurrentLanguage AND pkID<>@PublishedVersion
			WHILE (@ObsoleteVersions > @MaxVersions)
			BEGIN
				SELECT TOP 1 @DeleteWorkContentID=pkID FROM tblWorkContent   WITH(NOLOCK) WHERE fkContentID=@ContentID AND Status = 5 AND fkLanguageBranchID=@CurrentLanguage AND pkID<>@PublishedVersion ORDER BY pkID ASC
				EXEC @retval=editDeleteContentVersion @WorkContentID=@DeleteWorkContentID
				IF (@retval <> 0)
					BREAK
				SET @ObsoleteVersions=@ObsoleteVersions - 1
			END
			IF EXISTS(SELECT fkLanguageBranchID FROM #languages WHERE fkLanguageBranchID > @CurrentLanguage)
			    SET @CurrentLanguage = (SELECT MIN(fkLanguageBranchID) FROM #languages WHERE fkLanguageBranchID > @CurrentLanguage)
		    ELSE
		        SET @CurrentLanguage = 0
		END
		
		DROP TABLE #languages
	
	RETURN 0
END
