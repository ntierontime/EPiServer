CREATE PROCEDURE [dbo].[netActivityLogAssociationDeleteRelated]
(
	@AssociatedItem	[nvarchar](255),
	@RelatedItem	[nvarchar](255)
)
AS            
BEGIN
	DECLARE @RelatedItemCompare NVARCHAR(256) = CASE RIGHT(@RelatedItem, 1) WHEN '/' THEN LEFT(@RelatedItem, LEN(@RelatedItem) - 1) ELSE @RelatedItem END
	DECLARE @RelatedItemLike NVARCHAR(256) = @RelatedItemCompare + '%'
	DECLARE @RelatedItemLength INT = LEN(@RelatedItemLike)
	DELETE FROM [tblActivityLogAssociation] 
	FROM [tblActivityLogAssociation] AS TCLA INNER JOIN [tblActivityLog] AS TCL ON TCLA.[To] = TCL.pkID
	WHERE (TCLA.[From] = @AssociatedItem AND TCL.[RelatedItem] LIKE @RelatedItemLike AND (TCL.[RelatedItem] = @RelatedItemCompare OR SUBSTRING(TCL.[RelatedItem], @RelatedItemLength, 1) = '/'))
	OR (TCLA.[From] LIKE @RelatedItemLike AND TCL.[RelatedItem] = @AssociatedItem AND (TCLA.[From] = @RelatedItemCompare OR SUBSTRING(TCLA.[From], @RelatedItemLength, 1) = '/'))
END
