CREATE PROCEDURE dbo.netCategorySave
(
	@CategoryID		INT OUTPUT,
	@CategoryName	NVARCHAR(50),
	@Description	NVARCHAR(255),
	@Available		BIT,
	@Selectable		BIT,
	@SortOrder		INT,
	@ParentID		INT = NULL,
	@Guid			UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	IF (@CategoryID IS NULL)
	BEGIN
			IF (@SortOrder < 0)
			BEGIN
				SELECT @SortOrder = MAX(SortOrder) + 10 FROM tblCategory 
				IF (@SortOrder IS NULL)
					SET @SortOrder=100
			END
			INSERT INTO tblCategory 
				(CategoryName, 
				CategoryDescription, 
				fkParentID, 
				Available, 
				Selectable,
				SortOrder,
				CategoryGUID) 
			VALUES 
				(@CategoryName,
				@Description,
				@ParentID,
				@Available,
				@Selectable,
				@SortOrder,
				COALESCE(@Guid,NewId()))
		SET @CategoryID =  SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		UPDATE 
			tblCategory 
		SET 
			CategoryName		= @CategoryName,
			CategoryDescription	= @Description,
			fkParentID			= @ParentID,
			SortOrder			= @SortOrder,
			Available			= @Available,
			Selectable			= @Selectable,
			CategoryGUID		= COALESCE(@Guid,CategoryGUID)
		WHERE 
			pkID=@CategoryID
	END
	
	RETURN 0
END
