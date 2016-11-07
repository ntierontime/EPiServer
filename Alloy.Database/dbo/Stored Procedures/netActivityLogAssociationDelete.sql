CREATE PROCEDURE [dbo].[netActivityLogAssociationDelete]
(
	@AssociatedItem	[nvarchar](255),
	@ChangeLogID  BIGINT = 0
)
AS            
BEGIN
	DELETE FROM [tblActivityLogAssociation] WHERE [From] = @AssociatedItem AND (@ChangeLogID = 0 OR @ChangeLogID = [To])
	DECLARE @RowCount INT = (SELECT @@ROWCOUNT)
	UPDATE [tblActivityLog] SET RelatedItem = NULL WHERE @ChangeLogID = 0 AND RelatedItem = @AssociatedItem
	SELECT @@ROWCOUNT + @RowCount
END
