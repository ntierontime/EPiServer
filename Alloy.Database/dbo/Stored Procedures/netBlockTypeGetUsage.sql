CREATE PROCEDURE [dbo].[netBlockTypeGetUsage]
(
	@BlockTypeID		INT,
	@OnlyPublished	BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@OnlyPublished = 1)
	BEGIN
		SELECT DISTINCT
			Property.fkContentID as ContentID, 
			0 AS WorkID,
			ContentLanguage.Name,
			LanguageBranch.LanguageID AS LanguageBranch
		FROM tblContentProperty as Property WITH(INDEX(IDX_tblContentProperty_ScopeName))
		INNER JOIN dbo.GetScopedBlockProperties(@BlockTypeID) as ScopedProperties ON 
			Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
		INNER JOIN tblContentLanguage as ContentLanguage ON Property.fkContentID=ContentLanguage.fkContentID
		INNER JOIN tblLanguageBranch as LanguageBranch ON LanguageBranch.pkID=ContentLanguage.fkLanguageBranchID
	END
	ELSE
	BEGIN
		SELECT DISTINCT
			WorkContent.fkContentID as ContentID, 
			WorkContent.pkID as WorkID,
			WorkContent.Name,
			LanguageBranch.LanguageID AS LanguageBranch
		FROM tblWorkContentProperty as Property WITH(INDEX(IDX_tblWorkContentProperty_ScopeName))
		INNER JOIN dbo.GetScopedBlockProperties(@BlockTypeID) as ScopedProperties ON 
			Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
		INNER JOIN tblWorkContent as WorkContent ON WorkContent.pkID = Property.fkWorkContentID
		INNER JOIN tblLanguageBranch as LanguageBranch ON LanguageBranch.pkID=WorkContent.fkLanguageBranchID
	END
END
