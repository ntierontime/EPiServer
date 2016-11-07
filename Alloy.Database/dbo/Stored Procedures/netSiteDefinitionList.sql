CREATE PROCEDURE [dbo].[netSiteDefinitionList]
AS
BEGIN
	SELECT UniqueId, Name, SiteUrl, StartPage, SiteAssetsRoot FROM tblSiteDefinition
	SELECT site.[UniqueId] AS SiteId, host.[Name], host.[Type], host.[Language], host.[Https] 
	FROM tblHostDefinition host
	INNER JOIN tblSiteDefinition site ON site.pkID = host.fkSiteID
END
