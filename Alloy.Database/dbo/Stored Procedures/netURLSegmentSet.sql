CREATE PROCEDURE [dbo].[netURLSegmentSet]
(
	@URLSegment			NCHAR(255),
	@PageID				INT,
	@LanguageBranch		NCHAR(17) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LangBranchID NCHAR(17);
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
	UPDATE tblPageLanguage
	SET URLSegment = RTRIM(@URLSegment)
	WHERE fkPageID = @PageID
	AND (@LangBranchID=-1 OR fkLanguageBranchID=@LangBranchID)
	
	UPDATE tblWorkPage
	SET URLSegment = RTRIM(@URLSegment)
	WHERE fkPageID = @PageID
	AND (@LangBranchID=-1 OR fkLanguageBranchID=@LangBranchID)
END
