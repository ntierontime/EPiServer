CREATE PROCEDURE [dbo].[netActivityLogAssociatedGetLowest]
(
	@AssociatedItem		[nvarchar](255)
)
AS            
BEGIN
	SELECT MIN(pkID)
		FROM
		(SELECT pkID
			FROM [tblActivityLog]
			WHERE 
				RelatedItem = @AssociatedItem
				AND
				Deleted = 0
		UNION
			SELECT pkID
			FROM [tblActivityLog] 
			INNER JOIN [tblActivityLogAssociation] TAR ON pkID = TAR.[To]
			WHERE 
				TAR.[From] = @AssociatedItem 
				AND
				Deleted = 0) AS RESULT
END
