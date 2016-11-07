CREATE PROCEDURE dbo.netTaskWorkflowList
(
	@WorkflowInstanceId NVARCHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT
	    pkID AS TaskID,
	    COALESCE(Subject, N'-') AS Subject,
	    [Description],
	    DueDate,
	    Status,
	    Activity,
	    Created,
	    Changed,
	    OwnerName,
	    AssignedToName,
	    AssignedIsRole,
	    State,
	    fkPlugInID,
        WorkflowInstanceId,
	    EventActivityName
	FROM 
	    tblTask
	WHERE
		WorkflowInstanceId=@WorkflowInstanceId
	ORDER BY 
	    Status ASC,
	    DueDate DESC, 
	    Changed DESC
END
