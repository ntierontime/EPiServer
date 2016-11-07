CREATE PROCEDURE dbo.netContentEnsureVersions
(
	@ContentID			INT
)
AS
BEGIN
	DECLARE @LangBranchID INT
	DECLARE @LanguageBranch NCHAR(17)
	DECLARE @NewWorkContentID INT
	DECLARE @UserName NVARCHAR(255)
	CREATE TABLE #ContentLangsWithoutVersion
		(fkLanguageBranchID INT)
	/* Get a list of page languages that do not have an entry in tblWorkContent for the given page */
	INSERT INTO #ContentLangsWithoutVersion
		(fkLanguageBranchID)
	SELECT 
		tblContentLanguage.fkLanguageBranchID
	FROM 
		tblContentLanguage
	WHERE	
		fkContentID=@ContentID AND
		NOT EXISTS(
			SELECT * 
			FROM 
				tblWorkContent 
			WHERE 
				tblWorkContent.fkContentID=tblContentLanguage.fkContentID AND 
				tblWorkContent.fkLanguageBranchID=tblContentLanguage.fkLanguageBranchID)
	/* Get the first language to create a page version for */
	SELECT 
		@LangBranchID=Min(fkLanguageBranchID) 
	FROM 
		#ContentLangsWithoutVersion
	WHILE NOT @LangBranchID IS NULL
	BEGIN
		/* Get language name and user name to set for page version that we are about to create */
		SELECT 
			@LanguageBranch=LanguageID 
		FROM 
			tblLanguageBranch 
		WHERE 
			pkID=@LangBranchID
		SELECT 
			@UserName=ChangedByName 
		FROM 
			tblContentLanguage 
		WHERE 
			fkContentID=@ContentID AND 
			fkLanguageBranchID=@LangBranchID
		/* Create a new page version for the given page and language */
		EXEC @NewWorkContentID = editCreateContentVersion 
			@ContentID=@ContentID, 
			@WorkContentID=NULL, 
			@UserName=@UserName,
			@LanguageBranch=@LanguageBranch
		/* TODO - check if we should mark page version as published... */
		UPDATE 
			tblWorkContent 
		SET 
			Status = 5
		WHERE 
			pkID=@NewWorkContentID
		UPDATE 
			tblContentLanguage 
		SET 
			[Version]=@NewWorkContentID 
		WHERE 
			fkContentID=@ContentID AND 
			fkLanguageBranchID=@LangBranchID
		/* Get next language for the loop */
		SELECT 
			@LangBranchID=Min(fkLanguageBranchID) 
		FROM 
			#ContentLangsWithoutVersion 
		WHERE 
			fkLanguageBranchID > @LangBranchID
	END
	DROP TABLE #ContentLangsWithoutVersion
END
