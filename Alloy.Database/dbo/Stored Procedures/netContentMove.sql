CREATE PROCEDURE [dbo].[netContentMove]
(
	@ContentID				INT,
	@DestinationContentID	INT,
	@WastebasketID		INT,
	@Archive			INT,
	@DeletedBy			VARCHAR(255) = NULL,
	@DeletedDate		DATETIME = NULL, 
	@Saved				DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @TmpParentID		INT
	DECLARE @SourceParentID		INT
	DECLARE @TmpNestingLevel	INT
	DECLARE @Delete				BIT
	DECLARE @IsDestinationLeafNode BIT
	DECLARE @SourcePath VARCHAR(7000)
	DECLARE @TargetPath VARCHAR(7000)
 
	/* Protect from moving Content under itself */
	IF (EXISTS (SELECT NestingLevel FROM tblTree WHERE fkParentID=@ContentID AND fkChildID=@DestinationContentID) OR @DestinationContentID=@ContentID)
		RETURN -1
    
    SELECT @SourcePath=ContentPath + CONVERT(VARCHAR, @ContentID) + '.' FROM tblContent WHERE pkID=@ContentID
    SELECT @TargetPath=ContentPath + CONVERT(VARCHAR, @DestinationContentID) + '.', @IsDestinationLeafNode=IsLeafNode FROM tblContent WHERE pkID=@DestinationContentID
    
	/* Switch parent to archive Content, disable stop publish and update Saved */
	UPDATE tblContent SET
		@SourceParentID		= fkParentID,
		fkParentID			= @DestinationContentID,
		ContentPath            = @TargetPath
	WHERE pkID=@ContentID
	IF @IsDestinationLeafNode = 1
		UPDATE tblContent SET IsLeafNode = 0 WHERE pkID=@DestinationContentID
	IF NOT EXISTS(SELECT * FROM tblContent WHERE fkParentID=@SourceParentID)
		UPDATE tblContent SET IsLeafNode = 1 WHERE pkID=@SourceParentID
    IF (@Archive = 1)
	BEGIN
		UPDATE tblContentLanguage SET
			StopPublish			= NULL,
			Saved				= @Saved
		WHERE fkContentID=@ContentID
		UPDATE tblWorkContent SET
			StopPublish			= NULL
		WHERE fkContentID = @ContentID
	END
	 
	/* Remove all references to this Content and its childs, but preserve the 
		information below itself */
	DELETE FROM 
		tblTree 
	WHERE 
		fkChildID IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@ContentID UNION SELECT @ContentID) AND
		fkParentID NOT IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@ContentID UNION SELECT @ContentID)
 
	/* Insert information about new Contents for all Contents where the destination is a child */
	DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT fkParentID, NestingLevel FROM tblTree WHERE fkChildID=@DestinationContentID
	OPEN cur
	FETCH NEXT FROM cur INTO @TmpParentID, @TmpNestingLevel
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO tblTree
			(fkParentID,
			fkChildID,
			NestingLevel)
		SELECT
			@TmpParentID,
			fkChildID,
			@TmpNestingLevel + NestingLevel + 1
		FROM
			tblTree
		WHERE
			fkParentID=@ContentID
		UNION ALL
		SELECT
			@TmpParentID,
			@ContentID,
			@TmpNestingLevel + 1
	 
		FETCH NEXT FROM cur INTO @TmpParentID, @TmpNestingLevel
	END
	CLOSE cur
	DEALLOCATE cur
	/* Insert information about new Contents for destination */
	INSERT INTO tblTree
		(fkParentID,
		fkChildID,
		NestingLevel)
	SELECT
		@DestinationContentID,
		fkChildID,
		NestingLevel+1
	FROM
		tblTree
	WHERE
		fkParentID=@ContentID
	UNION
	SELECT
		@DestinationContentID,
		@ContentID,
		1
  
    /* Determine if destination is somewhere under wastebasket */
    SET @Delete=0
    IF (EXISTS (SELECT NestingLevel FROM tblTree WHERE fkParentID=@WastebasketID AND fkChildID=@ContentID))
        SET @Delete=1
    
    /* Update deleted bit of Contents */
    UPDATE tblContent  SET 
		Deleted=@Delete,
		DeletedBy = @DeletedBy,
		DeletedDate = @DeletedDate
    WHERE pkID IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@ContentID) OR pkID=@ContentID
	/* Update saved date for Content */
	IF(@Delete > 0)
	BEGIN
		UPDATE tblContentLanguage  SET 
				Saved = @Saved
   		WHERE fkContentID IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@ContentID) OR fkContentID=@ContentID
	END
 
    /* Create materialized path to moved Contents */
    UPDATE tblContent
    SET ContentPath=@TargetPath + CONVERT(VARCHAR, @ContentID) + '.' + RIGHT(ContentPath, LEN(ContentPath) - LEN(@SourcePath))
    WHERE pkID IN (SELECT fkChildID FROM tblTree WHERE fkParentID = @ContentID) /* Where Content is below source */    
    
	RETURN 0
END
