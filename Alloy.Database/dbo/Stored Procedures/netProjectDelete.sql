CREATE PROCEDURE [dbo].[netProjectDelete]
	@ID	INT
AS
	SET NOCOUNT ON
		DELETE FROM tblProjectItem WHERE fkProjectID = @ID
		DELETE FROM tblProjectMember WHERE fkProjectID = @ID 
		DELETE FROM tblProject WHERE pkID = @ID 
	RETURN @@ROWCOUNT
