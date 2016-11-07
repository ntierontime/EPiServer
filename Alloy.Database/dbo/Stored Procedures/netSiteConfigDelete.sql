CREATE PROCEDURE [dbo].[netSiteConfigDelete]
	@SiteID VARCHAR(250),
	@PropertyName VARCHAR(250)
AS
BEGIN
	DELETE FROM tblSiteConfig WHERE SiteID = @SiteID AND PropertyName = @PropertyName
END
