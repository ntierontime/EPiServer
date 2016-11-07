CREATE PROCEDURE [dbo].[netURLSegmentListPages]
(
	@URLSegment	NCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	IF (LEN(@URLSegment) = 0)
	BEGIN
		set @URLSegment = NULL
	END 
	SELECT DISTINCT fkPageID as "PageID"
	FROM tblPageLanguage
	WHERE URLSegment = @URLSegment
	OR (@URLSegment = NULL AND URLSegment = '' OR URLSegment IS NULL)
	
END
