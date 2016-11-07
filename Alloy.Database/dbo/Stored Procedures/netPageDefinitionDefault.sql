CREATE PROCEDURE dbo.netPageDefinitionDefault
(
	@PageDefinitionID	INT,
	@Boolean			BIT				= NULL,
	@Number				INT				= NULL,
	@FloatNumber		FLOAT			= NULL,
	@PageType			INT				= NULL,
	@PageReference		INT				= NULL,
	@Date				DATETIME		= NULL,
	@String				NVARCHAR(450)	= NULL,
	@LongString			NVARCHAR(MAX)	= NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	DELETE FROM tblPropertyDefault WHERE fkPageDefinitionID=@PageDefinitionID
	IF (@Boolean IS NULL AND @Number IS NULL AND @FloatNumber IS NULL AND @PageType IS NULL AND 
		@PageReference IS NULL AND @Date IS NULL AND @String IS NULL AND @LongString IS NULL)
		RETURN
	
	IF (@Boolean IS NULL)
		SET @Boolean=0
		
	INSERT INTO tblPropertyDefault 
		(fkPageDefinitionID, Boolean, Number, FloatNumber, PageType, PageLink, Date, String, LongString) 
	VALUES
		(@PageDefinitionID, @Boolean, @Number, @FloatNumber, @PageType, @PageReference, @Date, @String, @LongString)
	RETURN 
END
