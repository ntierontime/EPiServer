CREATE PROCEDURE [dbo].[netUniqueSequenceNext]
(
    @Name NVARCHAR (100),
    @Steps INT,
    @NextValue INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT OFF
	DECLARE @ErrorVal INT
	
	/* Assume that row exists and try to do an update to get the next value */
	UPDATE tblUniqueSequence SET @NextValue = LastValue = LastValue + @Steps WHERE Name = @Name
	
	/* If no rows were updated, the row did not exist */
	IF @@ROWCOUNT=0
	BEGIN
	
		/* Try to insert row. The reason for not starting with insert is that this operation is only
		needed ONCE for a sequence, the first update will succeed after this initial insert. */
		INSERT INTO tblUniqueSequence (Name, LastValue) VALUES (@Name, @Steps)
		SET @ErrorVal=@@ERROR	
		
		/* An extra safety precaution - parallell execution caused another instance of this proc to
		insert the relevant row between our first update and our insert. This causes a unique constraint
		violation. Note that SET XACT_ABORT OFF prevents error from propagating to calling code. */
		IF @ErrorVal <> 0
		BEGIN
		
			IF @ErrorVal = 2627
			BEGIN
				/* Unique constraint violation - do the update again since the row now exists */
				UPDATE tblUniqueSequence SET @NextValue = LastValue = LastValue + @Steps WHERE Name = @Name
			END
			ELSE
			BEGIN
				/* Some other error than unique key violation, very unlikely but raise an error to make 
				sure it gets noticed. */
				RAISERROR(50001, 14, 1)
			END
		END
		ELSE
		BEGIN
			/* No error from insert, the "next value" will be equal to the requested number of steps. */
			SET @NextValue = @Steps
		END
	END
END
