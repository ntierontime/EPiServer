CREATE PROCEDURE dbo.netPageLanguageSettingUpdate
(
	@PageID				INT,
	@LanguageBranch		NCHAR(17),
	@ReplacementBranch	NCHAR(17) = NULL,
	@LanguageBranchFallback NVARCHAR(1000) = NULL,
	@Active				BIT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LangBranchID INT
	DECLARE @ReplacementBranchID INT
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		RAISERROR('Language branch "%s" is not defined',16,1, @LanguageBranch)
		RETURN 0
	END
	IF NOT @ReplacementBranch IS NULL
	BEGIN
		SELECT @ReplacementBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @ReplacementBranch
		IF @ReplacementBranchID IS NULL
		BEGIN
			RAISERROR('Replacement language branch "%s" is not defined',16,1, @ReplacementBranch)
			RETURN 0
		END
	END
	
	IF EXISTS(SELECT * FROM tblPageLanguageSetting WHERE fkPageID=@PageID AND fkLanguageBranchID=@LangBranchID)
		UPDATE tblPageLanguageSetting SET
			fkReplacementBranchID	= @ReplacementBranchID,
			LanguageBranchFallback  = @LanguageBranchFallback,
			Active					= @Active
		WHERE fkPageID=@PageID AND fkLanguageBranchID=@LangBranchID
	ELSE
		INSERT INTO tblPageLanguageSetting(
				fkPageID,
				fkLanguageBranchID,
				fkReplacementBranchID,
				LanguageBranchFallback,
				Active)
		VALUES(
				@PageID, 
				@LangBranchID,
				@ReplacementBranchID,
				@LanguageBranchFallback,
				@Active
			)
		
	RETURN 0
END
