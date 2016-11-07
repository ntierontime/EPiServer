CREATE PROCEDURE dbo.netPageDefinitionConvertList
(
	@PageDefinitionID INT
)
AS
BEGIN
	SELECT 
			fkPageDefinitionID,
			fkPageID,
			NULL AS fkWorkPageID,
			fkLanguageBranchID,
			NULL AS fkUserPropertyID,
			ScopeName,
			CONVERT(INT,Boolean) AS Boolean,
			Number AS IntNumber,
			FloatNumber,
			PageType,
			LinkGuid,
			PageLink,
			Date AS DateValue,
			String,
			LongString,
			CONVERT(INT,0) AS DeleteProperty
	FROM tblProperty 
	WHERE fkPageDefinitionID=@PageDefinitionID
	UNION ALL
	
	SELECT 
			fkPageDefinitionID,
			NULL AS fkPageID,
			fkWorkPageID,
			NULL AS fkLanguageBranchID,
			NULL AS fkUserPropertyID,
			ScopeName,
			CONVERT(INT,Boolean) AS Boolean,
			Number AS IntNumber,
			FloatNumber,
			PageType,
			LinkGuid,
			PageLink,
			Date AS DateValue,
			String,
			LongString,
			CONVERT(INT,0) AS DeleteProperty
	FROM tblWorkProperty 
	WHERE fkPageDefinitionID=@PageDefinitionID
END
