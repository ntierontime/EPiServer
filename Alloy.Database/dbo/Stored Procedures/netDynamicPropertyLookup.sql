CREATE PROCEDURE [dbo].[netDynamicPropertyLookup]
AS
BEGIN
	SET NOCOUNT ON
	SELECT
		P.fkPageID AS PageID,
		P.fkPageDefinitionID,
		PD.Name AS PropertyName,
		LanguageSpecific,
		RTRIM(LB.LanguageID) AS BranchLanguageID,
		ScopeName,
		CONVERT(INT,Boolean) AS Boolean,
		Number AS IntNumber,
		FloatNumber,
		PageType,
		PageLink AS ContentLink,
		LinkGuid,
		Date AS DateValue,
		String,
		LongString
	FROM
		tblProperty AS P
	INNER JOIN
		tblLanguageBranch AS LB
	ON
		P.fkLanguageBranchID = LB.pkID
	INNER JOIN
		tblPageDefinition AS PD
	ON
		PD.pkID = P.fkPageDefinitionID
	WHERE   
		(LB.Enabled = 1 OR PD.LanguageSpecific < 3) AND
		(PD.fkPageTypeID IS NULL)	
END
