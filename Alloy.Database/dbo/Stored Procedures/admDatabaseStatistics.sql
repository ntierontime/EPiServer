CREATE PROCEDURE dbo.admDatabaseStatistics
AS
BEGIN
	SET NOCOUNT ON
	SELECT
		(SELECT Count(*) FROM tblPage) AS PageCount
END
