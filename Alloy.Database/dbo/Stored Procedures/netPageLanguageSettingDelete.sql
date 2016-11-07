CREATE PROCEDURE dbo.netPageLanguageSettingDelete
(
	@PageID			INT,
	@LanguageBranch	NCHAR(17)
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @LangBranchID INT
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		RETURN 0
	END
	DELETE FROM tblPageLanguageSetting WHERE fkPageID=@PageID AND fkLanguageBranchID=@LangBranchID
	
END
