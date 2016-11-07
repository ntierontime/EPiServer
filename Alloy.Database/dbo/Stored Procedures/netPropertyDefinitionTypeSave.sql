CREATE PROCEDURE [dbo].[netPropertyDefinitionTypeSave]
(
	@ID 			INT OUTPUT,
	@Property 		INT,
	@Name 			NVARCHAR(255),
	@TypeName 		NVARCHAR(255) = NULL,
	@AssemblyName 	NVARCHAR(255) = NULL,
	@BlockTypeID	uniqueidentifier = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	/* In case several sites start up at sametime, e.g. in enterprise it may occour that both sites tries to insert at same time. 
	Therefore a check is made to see it it already exist an entry with same guid, and if so an update is performed instead of insert.*/
	IF @ID <= 0
	BEGIN
		SET @ID = ISNULL((SELECT pkID FROM tblPropertyDefinitionType WHERE fkContentTypeGUID = @BlockTypeID), @ID)
	END
	IF @ID<0
	BEGIN
		IF @AssemblyName='EPiServer'
			SELECT @ID = Max(pkID)+1 FROM tblPropertyDefinitionType WHERE pkID<1000
		ELSE
			SELECT @ID = CASE WHEN Max(pkID)<1000 THEN 1000 ELSE Max(pkID)+1 END FROM tblPropertyDefinitionType
		INSERT INTO tblPropertyDefinitionType
		(
			pkID,
			Property,
			Name,
			TypeName,
			AssemblyName,
			fkContentTypeGUID
		)
		VALUES
		(
			@ID,
			@Property,
			@Name,
			@TypeName,
			@AssemblyName,
			@BlockTypeID
		)
	END
	ELSE
		UPDATE tblPropertyDefinitionType SET
			Name 		= @Name,
			Property		= @Property,
			TypeName 	= @TypeName,
			AssemblyName 	= @AssemblyName,
			fkContentTypeGUID = @BlockTypeID
		WHERE pkID=@ID
		
END
