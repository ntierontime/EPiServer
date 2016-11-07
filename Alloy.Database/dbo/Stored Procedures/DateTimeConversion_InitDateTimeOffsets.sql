CREATE PROCEDURE [dbo].[DateTimeConversion_InitDateTimeOffsets]
(@DateTimeOffsets [dbo].[DateTimeConversion_DateTimeOffset] READONLY)
AS
BEGIN
	IF OBJECT_ID('[dbo].[tblDateTimeConversion_Offset]', 'U') IS NOT NULL
		DROP TABLE [dbo].[tblDateTimeConversion_Offset]
	CREATE TABLE [dbo].[tblDateTimeConversion_Offset](
		[pkID] [INT] IDENTITY(1,1) NOT NULL,
		[IntervalStart] [DATETIME] NOT NULL, 
		[IntervalEnd] [DATETIME] NOT NULL,
		[Offset] DECIMAL(24,20) NOT NULL,
		CONSTRAINT [PK_tblDateTimeConversion_Offset] PRIMARY KEY  CLUSTERED
		(
			[pkID]
		)
	)
	INSERT INTO [dbo].[tblDateTimeConversion_Offset](IntervalStart, IntervalEnd, Offset)
	SELECT  tbl.IntervalStart,tbl.IntervalEnd,-CAST(tbl.Offset AS DECIMAL(24,20))/24/60 FROM @DateTimeOffsets tbl
	CREATE UNIQUE INDEX IDX_DateTimeConversion_Interval1 ON [dbo].[tblDateTimeConversion_Offset](IntervalStart ASC, IntervalEnd ASC) 
	CREATE UNIQUE INDEX IDX_DateTimeConversion_Interval2 ON [dbo].[tblDateTimeConversion_Offset](IntervalStart DESC, IntervalEnd DESC) 
END
