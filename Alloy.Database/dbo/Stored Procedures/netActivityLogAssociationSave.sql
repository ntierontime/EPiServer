CREATE PROCEDURE [dbo].[netActivityLogAssociationSave]
(
	@AssociatedItem	[nvarchar](255),
	@ChangeLogID  BIGINT
)
AS            
BEGIN
	INSERT INTO [tblActivityLogAssociation] VALUES(@AssociatedItem, @ChangeLogID)
END
