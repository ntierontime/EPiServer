CREATE VIEW [dbo].[tblPageDefinitionType]
AS
SELECT
	[pkID],
	[Property],
	[Name],
	[TypeName],
	[AssemblyName],
	[fkContentTypeGUID] AS fkPageTypeGUID
FROM    dbo.tblPropertyDefinitionType
