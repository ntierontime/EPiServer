CREATE VIEW [dbo].[tblPageDefinition]
AS
SELECT  [pkID],
		[fkContentTypeID] AS fkPageTypeID,
		[fkPropertyDefinitionTypeID] AS fkPageDefinitionTypeID,
		[FieldOrder],
		[Name],
		[Property],
		[Required],
		[Advanced],
		[Searchable],
		[EditCaption],
		[HelpText],
		[ObjectProgID],
		[DefaultValueType],
		[LongStringSettings],
		[SettingsID],
		[LanguageSpecific],
		[DisplayEditUI],
		[ExistsOnModel]
FROM    dbo.tblPropertyDefinition
