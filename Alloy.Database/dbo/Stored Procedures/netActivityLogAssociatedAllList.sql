CREATE PROCEDURE [dbo].[netActivityLogAssociatedAllList]
(
	@Associations	dbo.StringParameterTable READONLY,
	@StartIndex			BIGINT = NULL,
	@MaxCount			INT = NULL
)
AS            
BEGIN
	DECLARE @Compare AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @Compare SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @Associations WHERE String IS NOT NULL) X
	DECLARE @MatchAllCount INT = (SELECT COUNT(*) FROM @Compare)
	DECLARE @Ids AS TABLE([ID] [bigint] NOT NULL)
	
	INSERT INTO @Ids
	SELECT pkID FROM (
		SELECT pkID, [From] AS Value, StringLen
			FROM [tblActivityLog]
			JOIN tblActivityLogAssociation ON pkID = [To]
			JOIN @Compare ON [From] LIKE CompareString
			WHERE Deleted = 0
		UNION 
		SELECT pkID, RelatedItem AS Value, StringLen
			FROM [tblActivityLog]
			JOIN @Compare ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
	) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	GROUP BY pkID
	HAVING COUNT(pkID) = @MatchAllCount
	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)
	SELECT TOP(@MaxCount) [pkID], [Action], [Type], [ChangeDate], [ChangedBy], [LogData], [RelatedItem], [Deleted], @TotalCount AS 'TotalCount'
	FROM [tblActivityLog] al
	JOIN @Ids ids ON al.[pkID] = ids.[ID]
	WHERE [pkID] <= @StartIndex
	ORDER BY [pkID] DESC
END
