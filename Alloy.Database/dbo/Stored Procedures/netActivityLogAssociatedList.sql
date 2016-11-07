CREATE PROCEDURE [dbo].[netActivityLogAssociatedList]
(
	@MatchAll			dbo.StringParameterTable READONLY,
	@MatchAny			dbo.StringParameterTable READONLY,
	@StartIndex			BIGINT = NULL,
	@MaxCount			INT = NULL
)
AS            
BEGIN
	DECLARE @CompareMatchAll AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @CompareMatchAll SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @MatchAll WHERE String IS NOT NULL) X
	DECLARE @CompareMatchAny AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @CompareMatchAny SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @MatchAny WHERE String IS NOT NULL) X
	DECLARE @MatchAllCount INT = (SELECT COUNT(*) FROM @CompareMatchAll)
	DECLARE @IdsAll AS TABLE([ID] [bigint] NOT NULL)
	INSERT INTO @IdsAll
	SELECT pkID	FROM (
		SELECT pkID, [From] AS Value, StringLen
			FROM [tblActivityLog]
			JOIN tblActivityLogAssociation ON pkID = [To]
			JOIN @CompareMatchAll ON [From] LIKE CompareString
			WHERE Deleted = 0
		UNION 
		SELECT pkID, RelatedItem AS Value, StringLen
			FROM [tblActivityLog]
			JOIN @CompareMatchAll ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
	) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	GROUP BY pkID
	HAVING COUNT(pkID) = @MatchAllCount
	DECLARE @Ids AS TABLE([ID] [bigint] NOT NULL)
	INSERT INTO @Ids
		SELECT pkID FROM (
			SELECT pkID, [From] AS Value, StringLen
			FROM @IdsAll ids
			JOIN [tblActivityLog] ON pkID = ids.ID
			JOIN tblActivityLogAssociation ON pkID = [To]
			JOIN @CompareMatchAny ON [From] LIKE CompareString
			WHERE Deleted = 0
		) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	UNION
		SELECT pkID FROM (
			SELECT pkID, RelatedItem AS Value, StringLen
			FROM @IdsAll ids
			JOIN [tblActivityLog] ON pkID = ids.ID
			JOIN @CompareMatchAny ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
		) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)
	SELECT TOP(@MaxCount) [pkID], [Action], [Type], [ChangeDate], [ChangedBy], [LogData], [RelatedItem], [Deleted], @TotalCount AS 'TotalCount'
	FROM [tblActivityLog] al
	JOIN @Ids ids ON al.[pkID] = ids.[ID]
	WHERE [pkID] <= @StartIndex
	ORDER BY [pkID] DESC
END
