CREATE PROCEDURE dbo.netTabInfoList AS
BEGIN
	SELECT 	pkID as TabID, 
			Name,
			DisplayName,
			GroupOrder,
			Access AS AccessMask,
			CONVERT(INT,SystemGroup) AS SystemGroup
	FROM tblPageDefinitionGroup 
	ORDER BY GroupOrder
END
