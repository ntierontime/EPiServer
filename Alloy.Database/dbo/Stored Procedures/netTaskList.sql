CREATE PROCEDURE dbo.netTaskList
(
	@UserName NVARCHAR(255) = NULL
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
	    OwnerName=@UserName OR
	    AssignedToName=@UserName OR
	    AssignedIsRole=1 OR
	    @UserName IS NULL
	ORDER BY 
	    Status ASC,
	    DueDate DESC, 
	    Changed DESC
END
