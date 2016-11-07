CREATE PROCEDURE [dbo].[netMappedIdentityListProviders]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT DISTINCT Provider
	FROM tblMappedIdentity 
END
