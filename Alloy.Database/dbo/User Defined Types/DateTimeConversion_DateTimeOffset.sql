CREATE TYPE [dbo].[DateTimeConversion_DateTimeOffset] AS TABLE (
    [IntervalStart] DATETIME   NOT NULL,
    [IntervalEnd]   DATETIME   NOT NULL,
    [Offset]        FLOAT (53) NOT NULL);

