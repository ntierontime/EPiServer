CREATE PROCEDURE [dbo].[netChangeLogGetHighestSeqNum]
(
	@count BIGINT = 0 OUTPUT
)
AS
BEGIN
	select @count = MAX(pkID) from [tblActivityLog]
END
SET QUOTED_IDENTIFIER ON
