CREATE PROCEDURE dbo.netFrameList
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT
		pkID AS FrameID, 
		CASE
			WHEN FrameName IS NULL THEN
				N''
			ELSE
				SUBSTRING(FrameName, 9, LEN(FrameName) - 9)
		END AS FrameName,
		FrameDescription,
		'' AS FrameDescriptionLocalized,
		CONVERT(INT, SystemFrame) AS SystemFrame
	FROM
		tblFrame
	ORDER BY
		SystemFrame DESC,
		FrameName
END
