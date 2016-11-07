CREATE PROCEDURE dbo.netTaskSave
(
    @TaskID INT OUTPUT,
    @Subject NVARCHAR(255),
    @Description NVARCHAR(2000) = NULL,
    @DueDate DATETIME = NULL,
    @OwnerName NVARCHAR(255),
    @AssignedToName NVARCHAR(255),
    @AssignedIsRole BIT,
    @Status INT,
    @PlugInID INT = NULL,
    @Activity NVARCHAR(MAX) = NULL,
    @State NVARCHAR(MAX) = NULL,
    @WorkflowInstanceId NVARCHAR(36) = NULL,
    @EventActivityName NVARCHAR(255) = NULL,
	@CurrentDate DATETIME
)
AS
BEGIN
    -- Create new task
	IF @TaskID = 0
	BEGIN
		INSERT INTO tblTask
		    (Subject,
		    Description,
		    DueDate,
		    OwnerName,
		    AssignedToName,
		    AssignedIsRole,
		    Status,
		    Activity,
		    fkPlugInID,
		    State,
		    WorkflowInstanceId,
		    EventActivityName,
			Created,
			Changed) 
		VALUES
		    (@Subject,
		    @Description,
		    @DueDate,
		    @OwnerName,
		    @AssignedToName,
		    @AssignedIsRole,
		    @Status,
		    @Activity,
		    @PlugInID,
		    @State,
		    @WorkflowInstanceId,
			@EventActivityName,
			@CurrentDate,
			@CurrentDate)
		SET @TaskID= SCOPE_IDENTITY() 
		
		RETURN
	END
    -- Update existing task
	UPDATE tblTask SET
		Subject = @Subject,
		Description = @Description,
		DueDate = @DueDate,
		OwnerName = @OwnerName,
		AssignedToName = @AssignedToName,
		AssignedIsRole = @AssignedIsRole,
		Status = @Status,
		Activity = CASE WHEN @Activity IS NULL THEN Activity ELSE @Activity END,
		State = @State,
		fkPlugInID = @PlugInID,
		WorkflowInstanceId = @WorkflowInstanceId,
		EventActivityName = @EventActivityName,
		Changed = @CurrentDate
	WHERE pkID = @TaskID
END
