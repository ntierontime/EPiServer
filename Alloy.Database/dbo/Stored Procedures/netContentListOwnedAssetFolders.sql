CREATE PROCEDURE [dbo].[netContentListOwnedAssetFolders] 
	@ContentIDs AS GuidParameterTable READONLY
AS
BEGIN
	SET NOCOUNT ON
	SELECT tblContent.pkID as ContentId
	FROM tblContent INNER JOIN @ContentIDs as ParamIds on tblContent.ContentOwnerID = ParamIds.Id		
END
