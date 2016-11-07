CREATE PROCEDURE dbo.netSoftLinksGetUnchecked
(
	@LastCheckedDate	datetime,
	@LastCheckedDateBroken	datetime,
	@MaxNumberOfLinks INT = 1000
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP(@MaxNumberOfLinks) *
	FROM tblContentSoftlink
	WHERE (LinkProtocol like 'http%' OR LinkProtocol is NULL) AND 
		(LastCheckedDate < @LastCheckedDate OR (LastCheckedDate < @LastCheckedDateBroken AND LinkStatus <> 0) OR LastCheckedDate IS NULL)
	ORDER BY LastCheckedDate
END
