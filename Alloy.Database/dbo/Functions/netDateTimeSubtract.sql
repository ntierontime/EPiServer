create FUNCTION dbo.netDateTimeSubtract
(
	@DateTime1 DateTime,
	@DateTime2 DateTime
)
RETURNS BigInt
AS
BEGIN
declare @Return BigInt
Select @Return = (Convert(BigInt, 
	DATEDIFF(day, @DateTime1, @DateTime2)) * 86400000) + 
	(DATEDIFF(millisecond, 
		DATEADD(day, 
			DATEDIFF(day, @DateTime1, @DateTime2)
		, @DateTime1)
	, @DateTime2
	)
)
return @Return
END
