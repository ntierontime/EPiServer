CREATE PROCEDURE dbo.netContentLoadLongString
(
	@LongStringGuid	UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT LongString FROM tblContentProperty WHERE [guid]=@LongStringGuid
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT LongString FROM tblWorkContentProperty WHERE [guid]=@LongStringGuid
	END
END
