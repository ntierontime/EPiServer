CREATE PROCEDURE [dbo].[netPageTypeCheckUsage]
(
	@PageTypeID		INT,
	@OnlyPublished	BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	IF (@OnlyPublished = 1)
	BEGIN
		SELECT TOP 1
			tblPage.pkID as PageID, 
			0 AS WorkID
		FROM 
			tblPage
		WHERE
			tblPage.fkPageTypeID = @PageTypeID
	END
	ELSE
	BEGIN
		SELECT TOP 1
			tblPage.pkID as PageID, 
			tblWorkPage.pkID as WorkID
		FROM 
			tblWorkPage
		INNER JOIN 
			tblPage ON tblWorkPage.fkPageID = tblPage.pkID
		WHERE
			tblPage.fkPageTypeID = @PageTypeID
	END
END
