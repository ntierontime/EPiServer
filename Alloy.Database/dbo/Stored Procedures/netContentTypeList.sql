CREATE PROCEDURE [dbo].[netContentTypeList]
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT	CT.pkID AS ID,
			CONVERT(NVARCHAR(38),CT.ContentTypeGUID) AS Guid,
			CT.Name,
			CT.DisplayName,
			CT.Description,
			CT.DefaultWebFormTemplate,
			CT.DefaultMvcController,
			CT.DefaultMvcPartialView,
			CT.Available,
			CT.SortOrder,
			CT.ModelType,
			CT.Filename,
			CT.ACL,
			CT.ContentType,
			CTD.pkID AS DefaultID,
			CTD.Name AS DefaultName,
			CTD.StartPublishOffset,
			CTD.StopPublishOffset,
			CONVERT(INT,CTD.VisibleInMenu) AS VisibleInMenu,
			CTD.PeerOrder,
			CTD.ChildOrderRule,
			CTD.fkFrameID AS FrameID,
			CTD.fkArchiveContentID AS ArchiveContentLink
	FROM tblContentType CT
	LEFT JOIN tblContentTypeDefault AS CTD ON CTD.fkContentTypeID=CT.pkID 
	ORDER BY CT.SortOrder
END
