CREATE PROCEDURE dbo.netQuickSearchByPath
(
	@Path	NVARCHAR(1000),
	@PageID	INT,
	@LanguageBranch	NCHAR(17) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Index INT
	DECLARE @LastIndex INT
	DECLARE @LinkURL NVARCHAR(255)
	DECLARE @Name NVARCHAR(255)
	DECLARE @LangBranchID NCHAR(17);
	
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
	SET @Index = CHARINDEX('/',@Path)
	SET @LastIndex = 0
	WHILE @Index > 0 OR @Index IS NULL
	BEGIN
		SET @Name = SUBSTRING(@Path,@LastIndex,@Index-@LastIndex)
		SELECT TOP 1 @PageID=pkID,@LinkURL=tblPageLanguage.LinkURL
		FROM tblPageLanguage
		LEFT JOIN tblPage AS tblPage ON tblPage.pkID=tblPageLanguage.fkPageID
		WHERE tblPageLanguage.Name LIKE @Name AND (tblPage.fkParentID=@PageID OR @PageID IS NULL)
		AND (tblPageLanguage.fkLanguageBranchID=@LangBranchID OR @LangBranchID=-1)
		IF @@ROWCOUNT=0
		BEGIN
			SET @Index=0
			SET @LinkURL = NULL
		END
		ELSE
		BEGIN
			SET @LastIndex = @Index + 1
			SET @Index = CHARINDEX('/',@Path,@LastIndex+1)
		END
	END	
		
	SELECT @LinkURL
END
