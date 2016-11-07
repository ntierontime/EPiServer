CREATE PROCEDURE dbo.netPageDefinitionTypeList
AS
BEGIN
	SELECT 	DT.pkID AS ID,
			DT.Name,
			DT.Property,
			DT.TypeName,
			DT.AssemblyName, 
			DT.fkPageTypeGUID AS BlockTypeID,
			PT.Name as BlockTypeName,
			PT.ModelType as BlockTypeModel
	FROM tblPageDefinitionType as DT
		LEFT OUTER JOIN tblPageType as PT ON DT.fkPageTypeGUID = PT.PageTypeGUID
	ORDER BY DT.Name
END
