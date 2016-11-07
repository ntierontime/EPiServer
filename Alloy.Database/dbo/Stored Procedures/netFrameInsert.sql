CREATE PROCEDURE dbo.netFrameInsert
(
	@FrameID		INTEGER OUTPUT,
	@FrameName		NVARCHAR(100),
	@FrameDescription	NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	
	INSERT INTO tblFrame
		(FrameName,
		FrameDescription)
	VALUES
		('target="' + @FrameName + '"', 
		@FrameDescription)
	SET @FrameID =  SCOPE_IDENTITY() 
		
	RETURN 0
END
