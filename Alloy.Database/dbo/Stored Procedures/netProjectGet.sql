CREATE PROCEDURE [dbo].[netProjectGet]
	@ID int
AS
BEGIN
	SELECT pkID, IsPublic, Name, Created, CreatedBy, [Status], DelayPublishUntil, PublishingTrackingToken
	FROM tblProject
	WHERE tblProject.pkID = @ID
	SELECT pkID, Name, Type
	FROM tblProjectMember
	WHERE tblProjectMember.fkProjectID = @ID
	ORDER BY Name ASC
END
