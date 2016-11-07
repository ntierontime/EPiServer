CREATE PROCEDURE dbo.netFrameUpdate
(
	@FrameID			INT,
	@FrameName			NVARCHAR(100),
	@FrameDescription		NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	UPDATE 
		tblFrame 
	SET 
		FrameName='target="' + @FrameName + '"', 
		FrameDescription=@FrameDescription
	WHERE
		pkID=@FrameID
		
	RETURN 0
END
