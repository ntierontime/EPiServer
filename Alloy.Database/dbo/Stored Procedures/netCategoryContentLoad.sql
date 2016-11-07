CREATE PROCEDURE [dbo].[netCategoryContentLoad]
(
	@ContentID			INT,
	@VersionID		INT,
	@CategoryType	INT,
	@LanguageBranch	NCHAR(17) = NULL,
	@ScopeName NVARCHAR(450)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LangBranchID NCHAR(17);
	DECLARE @LanguageSpecific INT;
	IF(@VersionID = 0)
			SET @VersionID = NULL;
	IF @VersionID IS NOT NULL AND @LanguageBranch IS NOT NULL
	BEGIN
		IF NOT EXISTS(	SELECT
							LanguageID
						FROM
							tblWorkContent 
						INNER JOIN
							tblLanguageBranch
						ON
							tblWorkContent.fkLanguageBranchID = tblLanguageBranch.pkID
						WHERE
							LanguageID = @LanguageBranch
						AND
							tblWorkContent.pkID = @VersionID)
			RAISERROR('@LanguageBranch %s is not the same as Language Branch for page version %d' ,16,1, @LanguageBranch,@VersionID)
	END
	
	IF(@LanguageBranch IS NOT NULL)
		SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch;
	ELSE
		SELECT @LangBranchID = fkLanguageBranchID FROM tblWorkContent WHERE pkID = @VersionID;
	
	IF(@CategoryType <> 0)
		SELECT @LanguageSpecific = LanguageSpecific FROM tblPageDefinition WHERE pkID = @CategoryType;
	ELSE
		SET @LanguageSpecific = 0;
	IF @LangBranchID IS NULL AND @LanguageSpecific > 2
		RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
	IF @LanguageSpecific < 3 AND @VersionID IS NOT NULL
	BEGIN
		IF EXISTS(SELECT pkID FROM tblContent WHERE pkID=@ContentID AND fkMasterLanguageBranchID<>@LangBranchID)
		BEGIN
			SELECT @VersionID = tblContentLanguage.Version 
				FROM tblContentLanguage 
				INNER JOIN tblContent ON tblContent.pkID=tblContentLanguage.fkContentID
				WHERE tblContent.pkID=@ContentID AND tblContentLanguage.fkLanguageBranchID=tblContent.fkMasterLanguageBranchID			
		END
	END
	IF (@VersionID IS NOT NULL)
	BEGIN
		/* Get info from tblWorkContentCategory */
		SELECT
			fkCategoryID AS CategoryID
		FROM
			tblWorkContentCategory
		WHERE
			ScopeName=@ScopeName AND
			fkWorkContentID=@VersionID
	END
	ELSE
	BEGIN
		/* Get info from tblContentcategory */
		SELECT
			fkCategoryID AS CategoryID
		FROM
			tblContentCategory
		WHERE
			ScopeName=@ScopeName AND
			fkContentID=@ContentID AND
			(fkLanguageBranchID=@LangBranchID OR @LanguageSpecific < 3)
	END
	
	RETURN 0
END
