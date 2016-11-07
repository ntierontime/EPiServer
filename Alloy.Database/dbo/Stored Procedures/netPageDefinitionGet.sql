CREATE PROCEDURE [dbo].[netPageDefinitionGet]
(
	@PageDefinitionID INT
)
AS
BEGIN
	SELECT tblPageDefinition.pkID AS ID,
		fkPageTypeID AS PageTypeID,
		COALESCE(fkPageDefinitionTypeID,tblPageDefinition.Property) AS PageDefinitionTypeID,
		tblPageDefinition.Name,
		COALESCE(tblPageDefinitionType.Property,tblPageDefinition.Property) AS Type,
		CONVERT(INT,Required) AS Required,
		Advanced,
		CONVERT(INT,Searchable) AS Searchable,
		DefaultValueType,
		EditCaption,
		HelpText,
		ObjectProgID,
		LongStringSettings,
		SettingsID,
		CONVERT(INT,Boolean) AS Boolean,
		Number AS IntNumber,
		FloatNumber,
		PageType,
		PageLink,
		Date AS DateValue,
		String,
		LongString,
		FieldOrder,
		LanguageSpecific,
		DisplayEditUI,
		ExistsOnModel
	FROM tblPageDefinition
	LEFT JOIN tblPropertyDefault ON tblPropertyDefault.fkPageDefinitionID=tblPageDefinition.pkID
	LEFT JOIN tblPageDefinitionType ON tblPageDefinitionType.pkID=tblPageDefinition.fkPageDefinitionTypeID
	WHERE tblPageDefinition.pkID = @PageDefinitionID
END
