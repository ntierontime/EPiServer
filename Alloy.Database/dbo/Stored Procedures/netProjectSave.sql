CREATE PROCEDURE [dbo].[netProjectSave]
	@ID INT,
	@Name	nvarchar(255),
	@IsPublic BIT,
	@Created	datetime,
	@CreatedBy	nvarchar(255),
	@Status INT,
	@DelayPublishUntil datetime = NULL,
	@PublishingTrackingToken nvarchar(255),
	@Members dbo.ProjectMemberTable READONLY
AS
BEGIN
	SET NOCOUNT ON
	IF @ID=0
	BEGIN
		INSERT INTO tblProject(Name, IsPublic, Created, CreatedBy, [Status], DelayPublishUntil, PublishingTrackingToken) VALUES(@Name, @IsPublic, @Created, @CreatedBy, @Status, @DelayPublishUntil, @PublishingTrackingToken)
		SET @ID = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE tblProject SET Name=@Name, IsPublic=@IsPublic, [Status] = @Status, DelayPublishUntil = @DelayPublishUntil, PublishingTrackingToken = @PublishingTrackingToken  WHERE pkID=@ID
	END
	MERGE tblProjectMember AS Target
    USING @Members AS Source
    ON (Target.pkID = Source.ID AND Target.fkProjectID=@ID)
    WHEN MATCHED THEN 
        UPDATE SET Name = Source.Name, Type = Source.Type
	WHEN NOT MATCHED BY Source AND Target.fkProjectID = @ID THEN
		DELETE
	WHEN NOT MATCHED BY Target THEN
		INSERT (fkProjectID, Name, Type)
		VALUES (@ID, Source.Name, Source.Type);
	SELECT pkID, Name, Type
	FROM tblProjectMember
	WHERE tblProjectMember.fkProjectID = @ID
	ORDER BY Name ASC
	RETURN @ID
END
