CREATE PROCEDURE [dbo].[netProjectList]
	@StartIndex INT = 0,
	@MaxRows INT,
	@Status INT = -1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @projectIDs TABLE(projectID INT NOT NULL, TotalRows INT NOT NULL);
	WITH PageCTE AS
    (SELECT pkID, [Status],
     ROW_NUMBER() OVER(ORDER BY Name ASC, pkID ASC) AS intRow
     FROM tblProject
	 WHERE @Status  = -1 OR @Status = [Status])
	INSERT INTO  @projectIDs 
		SELECT PageCTE.pkID, (SELECT COUNT(*) FROM PageCTE) AS 'TotalRows' 
		FROM PageCTE 
		WHERE intRow BETWEEN (@StartIndex +1) AND (@MaxRows + @StartIndex)
	--Projects
	SELECT 
		pkID, Name, IsPublic, CreatedBy, Created, [Status], DelayPublishUntil, PublishingTrackingToken
	FROM 
		tblProject 
	INNER JOIN @projectIDs AS projects ON projects.projectID = tblProject.pkID
	--ProjectMembers
	SELECT 
		pkID, projectID, Name, Type
	FROM 
		tblProjectMember 
	INNER JOIN @projectIDs AS projects ON projects.projectID = tblProjectMember.fkProjectID
	ORDER BY projectID, Name
	RETURN COALESCE((SELECT TOP 1 TotalRows FROM @projectIDs), 0)
END
