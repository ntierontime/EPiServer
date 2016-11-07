CREATE PROCEDURE [dbo].[editDeletePageCheckInternal]
(@pages editDeletePageInternalTable READONLY) 
AS
BEGIN
	SET NOCOUNT ON
	SELECT
		tblPageLanguage.fkLanguageBranchID AS OwnerLanguageID,
		NULL AS ReferencedLanguageID,
		tblPageLanguage.fkPageID AS OwnerID, 
		tblPageLanguage.Name As OwnerName,
		PageLink As ReferencedID,
		tpl.Name AS ReferencedName,
		0 AS ReferenceType
	FROM 
		tblProperty 
	INNER JOIN 
		tblPage ON tblProperty.fkPageID=tblPage.pkID
	INNER JOIN 
		tblPageLanguage ON tblPageLanguage.fkPageID=tblPage.pkID
	INNER JOIN
		tblPage AS tp ON PageLink=tp.pkID
	INNER JOIN
		tblPageLanguage AS tpl ON tpl.fkPageID=tp.pkID
	WHERE 
		(tblProperty.fkPageID NOT IN (SELECT pkID FROM @pages)) AND
		(PageLink IN (SELECT pkID FROM @pages)) AND
		tblPage.Deleted=0 AND
		tblPageLanguage.fkLanguageBranchID=tblProperty.fkLanguageBranchID AND
		tpl.fkLanguageBranchID=tp.fkMasterLanguageBranchID
	
	UNION
	
	SELECT
		tblPageLanguage.fkLanguageBranchID AS OwnerLanguageID,
		NULL AS ReferencedLanguageID,    
		tblPageLanguage.fkPageID AS OwnerID,
		tblPageLanguage.Name As OwnerName,
		tp.pkID AS ReferencedID,
		tpl.Name AS ReferencedName,
		1 AS ReferenceType
	FROM
		tblPageLanguage
	INNER JOIN
		tblPage ON tblPage.pkID=tblPageLanguage.fkPageID
	INNER JOIN
		tblPage AS tp ON tblPageLanguage.PageLinkGUID = tp.PageGUID
	INNER JOIN
		tblPageLanguage AS tpl ON tpl.fkPageID=tp.pkID
	WHERE
		(tblPageLanguage.fkPageID NOT IN (SELECT pkID FROM @pages)) AND
		(tblPageLanguage.PageLinkGUID IN (SELECT PageGUID FROM @pages)) AND
		tblPage.Deleted=0 AND
		tpl.fkLanguageBranchID=tp.fkMasterLanguageBranchID
	
	UNION
	
	SELECT
		tblContentSoftlink.OwnerLanguageID AS OwnerLanguageID,
		tblContentSoftlink.ReferencedLanguageID AS ReferencedLanguageID,
		PLinkFrom.pkID AS OwnerID,
		PLinkFromLang.Name  As OwnerName,
		PLinkTo.pkID AS ReferencedID,
		PLinkToLang.Name AS ReferencedName,
		1 AS ReferenceType
	FROM
		tblContentSoftlink
	INNER JOIN
		tblPage AS PLinkFrom ON PLinkFrom.pkID=tblContentSoftlink.fkOwnerContentID
	INNER JOIN
		tblPageLanguage AS PLinkFromLang ON PLinkFromLang.fkPageID=PLinkFrom.pkID
	INNER JOIN
		tblPage AS PLinkTo ON PLinkTo.PageGUID=tblContentSoftlink.fkReferencedContentGUID
	INNER JOIN
		tblPageLanguage AS PLinkToLang ON PLinkToLang.fkPageID=PLinkTo.pkID
	WHERE
		(PLinkFrom.pkID NOT IN (SELECT pkID FROM @pages)) AND
		(PLinkTo.pkID IN (SELECT pkID FROM @pages)) AND
		PLinkFrom.Deleted=0 AND
		PLinkFromLang.fkLanguageBranchID=PLinkFrom.fkMasterLanguageBranchID AND
		PLinkToLang.fkLanguageBranchID=PLinkTo.fkMasterLanguageBranchID
		
	UNION
	
	SELECT
		tblPageLanguage.fkLanguageBranchID AS OwnerLanguageID,
		NULL AS ReferencedLanguageID,
		tblPage.pkID AS OwnerID,
		tblPageLanguage.Name  As OwnerName,
		tp.pkID AS ReferencedID,
		tpl.Name AS ReferencedName,
		2 AS ReferenceType
	FROM
		tblPage
	INNER JOIN 
		tblPageLanguage ON tblPageLanguage.fkPageID=tblPage.pkID
	INNER JOIN
		tblPage AS tp ON tblPage.ArchivePageGUID=tp.PageGUID
	INNER JOIN
		tblPageLanguage AS tpl ON tpl.fkPageID=tp.pkID
	WHERE
		(tblPage.pkID NOT IN (SELECT pkID FROM @pages)) AND
		(tblPage.ArchivePageGUID IN (SELECT PageGUID FROM @pages)) AND
		tblPage.Deleted=0 AND
		tpl.fkLanguageBranchID=tp.fkMasterLanguageBranchID AND
		tblPageLanguage.fkLanguageBranchID=tblPage.fkMasterLanguageBranchID
	UNION
	
	SELECT 
		tblPageLanguage.fkLanguageBranchID AS OwnerLanguageID,
		NULL AS ReferencedLanguageID,
		tblPage.pkID AS OwnerID, 
		tblPageLanguage.Name  As OwnerName,
		tblPageTypeDefault.fkArchivePageID AS ReferencedID,
		tblPageType.Name AS ReferencedName,
		3 AS ReferenceType
	FROM 
		tblPageTypeDefault
	INNER JOIN
	   tblPageType ON tblPageTypeDefault.fkPageTypeID=tblPageType.pkID
	INNER JOIN
		tblPage ON tblPageTypeDefault.fkArchivePageID=tblPage.pkID
	INNER JOIN 
		tblPageLanguage ON tblPageLanguage.fkPageID=tblPage.pkID
	WHERE 
		tblPageTypeDefault.fkArchivePageID IN (SELECT pkID FROM @pages) AND
		tblPageLanguage.fkLanguageBranchID=tblPage.fkMasterLanguageBranchID
	ORDER BY
	   ReferenceType
		
	RETURN 0
	
END
