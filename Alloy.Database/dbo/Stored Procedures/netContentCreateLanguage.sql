CREATE PROCEDURE [dbo].[netContentCreateLanguage]
(
	@ContentID			INT,
	@WorkContentID		INT,
	@UserName NVARCHAR(255),
	@MaxVersions	INT = NULL,
	@SavedDate		DATETIME,
	@LanguageBranch	NCHAR(17)
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @LangBranchID		INT
	DECLARE @NewVersionID		INT
	
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		RAISERROR (N'netContentCreateLanguage: LanguageBranchID is null, possibly empty table tblLanguageBranch', 16, 1, @WorkContentID)
		RETURN 0
	END
	IF NOT EXISTS( SELECT * FROM tblContentLanguage WHERE fkContentID=@ContentID )
		UPDATE tblContent SET fkMasterLanguageBranchID=@LangBranchID WHERE pkID=@ContentID
	
	INSERT INTO tblContentLanguage(fkContentID, CreatorName, ChangedByName, Status, fkLanguageBranchID, Created, Changed, Saved)
	SELECT @ContentID, @UserName, @UserName, 2, @LangBranchID, @SavedDate, @SavedDate, @SavedDate 
	FROM tblContent
	INNER JOIN tblContentType ON tblContentType.pkID=tblContent.fkContentTypeID
	WHERE tblContent.pkID=@ContentID
			
	INSERT INTO tblWorkContent
		(fkContentID,
		ChangedByName,
		ContentLinkGUID,
		fkFrameID,
		ArchiveContentGUID,
		Name,
		LinkURL,
		ExternalURL,
		VisibleInMenu,
		LinkType,
		Created,
		Saved,
		StartPublish,
		StopPublish,
		ChildOrderRule,
		PeerOrder,
		fkLanguageBranchID,
		CommonDraft)
	SELECT 
		@ContentID,
		COALESCE(@UserName, tblContentLanguage.CreatorName),
		tblContentLanguage.ContentLinkGUID,
		tblContentLanguage.fkFrameID,
		tblContent.ArchiveContentGUID,
		tblContentLanguage.Name,
		tblContentLanguage.LinkURL,
		tblContentLanguage.ExternalURL,
		tblContent.VisibleInMenu,
		CASE tblContentLanguage.AutomaticLink 
			WHEN 1 THEN 
				(CASE
					WHEN tblContentLanguage.ContentLinkGUID IS NULL THEN 0	/* EPnLinkNormal */
					WHEN tblContentLanguage.FetchData=1 THEN 4				/* EPnLinkFetchdata */
					ELSE 1												/* EPnLinkShortcut */
				END)
			ELSE
				(CASE 
					WHEN tblContentLanguage.LinkURL=N'#' THEN 3			/* EPnLinkInactive */
					ELSE 2												/* EPnLinkExternal */
				END)
		END AS LinkType ,
		tblContentLanguage.Created,
		@SavedDate,
		tblContentLanguage.StartPublish,
		tblContentLanguage.StopPublish,
		tblContent.ChildOrderRule,
		tblContent.PeerOrder,
		@LangBranchID,
		0
	FROM tblContentLanguage
	INNER JOIN tblContent ON tblContent.pkID=tblContentLanguage.fkContentID
	WHERE 
		tblContentLanguage.fkContentID=@ContentID AND tblContentLanguage.fkLanguageBranchID=@LangBranchID
		
	SET @NewVersionID = SCOPE_IDENTITY()	
	
	UPDATE tblContentLanguage SET Version = @NewVersionID
	WHERE fkContentID = @ContentID AND fkLanguageBranchID = @LangBranchID
		
	RETURN  @NewVersionID 
END
