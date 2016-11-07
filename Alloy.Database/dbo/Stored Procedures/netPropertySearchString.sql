CREATE PROCEDURE [dbo].[netPropertySearchString]
(
	@PageID				INT,
	@PropertyName 		NVARCHAR(255),
	@UseWildCardsBefore	BIT = 0,
	@UseWildCardsAfter	BIT = 0,
	@String				NVARCHAR(2000) = NULL,
	@LanguageBranch		NCHAR(17) = NULL
)
AS
BEGIN
	DECLARE @LangBranchID INT
	DECLARE @Path VARCHAR(7000)
	DECLARE @SearchString NVARCHAR(2002)
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
	SELECT @Path=PagePath + CONVERT(VARCHAR, @PageID) + '.' FROM tblPage WHERE pkID=@PageID
	SET @SearchString=CASE    
		WHEN @UseWildCardsBefore=0 AND @UseWildCardsAfter=0 THEN @String
		WHEN @UseWildCardsBefore=1 AND @UseWildCardsAfter=0 THEN '%' + @String
		WHEN @UseWildCardsBefore=0 AND @UseWildCardsAfter=1 THEN @String + '%'
		ELSE '%' + @String + '%'
	END
	
	IF @String IS NULL
		SELECT P.pkID
		FROM tblContent AS P
		INNER JOIN tblProperty ON tblProperty.fkPageID=P.pkID
		INNER JOIN tblPageLanguage ON tblPageLanguage.fkPageID=P.pkID
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID = tblProperty.fkPageDefinitionID and tblPageDefinition.Name = @PropertyName and tblPageDefinition.Property in (6,7)
		WHERE 
			P.ContentType = 0 
		AND
			P.ContentPath LIKE (@Path + '%')
		AND 
			(@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND 
			(String IS NULL AND LongString IS NULL)
	ELSE
		SELECT P.pkID
		FROM tblContent AS P
		INNER JOIN tblProperty ON tblProperty.fkPageID=P.pkID
		INNER JOIN tblPageLanguage ON tblPageLanguage.fkPageID=P.pkID
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID = tblProperty.fkPageDefinitionID and tblPageDefinition.Name = @PropertyName and tblPageDefinition.Property = 6
		WHERE 
			P.ContentType = 0 
		AND
			P.ContentPath LIKE (@Path + '%')
		AND 
			(@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND
			String LIKE @SearchString
		UNION
		SELECT P.pkID
		FROM tblContent AS P
		INNER JOIN tblProperty ON tblProperty.fkPageID=P.pkID
		INNER JOIN tblPageLanguage ON tblPageLanguage.fkPageID=P.pkID
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID = tblProperty.fkPageDefinitionID and tblPageDefinition.Name = @PropertyName and tblPageDefinition.Property = 7
		WHERE 
			P.ContentType = 0 
		AND
			P.ContentPath LIKE (@Path + '%')
		AND 
			(@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND
			LongString LIKE @SearchString
END
