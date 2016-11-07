CREATE PROCEDURE dbo.netTaskLoad
(
	@TaskID INT
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
	    pkID=@TaskID
END
