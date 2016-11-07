CREATE PROCEDURE [dbo].[netChangeLogTruncBySeqNDate]
(
	@LowestSequenceNumber BIGINT = NULL,
	@OlderThan DATETIME = NULL
)
AS
BEGIN	
	DELETE FROM [tblActivityLog] WHERE
	((@LowestSequenceNumber IS NULL) OR (pkID < @LowestSequenceNumber)) AND
	((@OlderThan IS NULL) OR (ChangeDate < @OlderThan))
END
