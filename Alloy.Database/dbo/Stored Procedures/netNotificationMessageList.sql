CREATE PROCEDURE [dbo].[netNotificationMessageList]
	@Recipient NVARCHAR(50) = NULL,
	@Channel NVARCHAR(50) = NULL,
	@Category NVARCHAR(255) = NULL,
	@Read BIT = NULL,
	@Sent BIT = NULL,
	@StartIndex	INT,
	@MaxCount	INT
AS
BEGIN
	DECLARE @Ids AS TABLE([RowNr] [int] IDENTITY(0,1), [ID] [bigint] NOT NULL)
	INSERT INTO @Ids
	SELECT pkID
	FROM [tblNotificationMessage]
	WHERE
		((@Recipient IS NULL) OR (@Recipient = Recipient))
		AND
		((@Channel IS NULL) OR (@Channel = Channel))
		AND
		((@Category IS NULL) OR (Category LIKE @Category + '%'))
		AND
		(@Read IS NULL OR 
			((@Read = 1 AND [Read] IS NOT NULL) OR
			(@Read = 0 AND [Read] IS NULL)))
		AND
		(@Sent IS NULL OR 
			((@Sent = 1 AND [Sent] IS NOT NULL) OR
			(@Sent = 0 AND [Sent] IS NULL)))
	ORDER BY Saved DESC
	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)
 
	SELECT TOP(@MaxCount) pkID AS ID, [Recipient], [Sender], [Channel], [Type], [Subject], [Content], [Sent], [SendAt], [Saved], [Read], [Category], @TotalCount AS 'TotalCount'
	FROM [tblNotificationMessage] nm
	JOIN @Ids ids ON nm.[pkID] = ids.[ID]
	WHERE ids.RowNr >= @StartIndex
	ORDER BY nm.[Saved] DESC
END
