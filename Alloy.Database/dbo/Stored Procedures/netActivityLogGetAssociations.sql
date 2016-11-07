CREATE PROCEDURE [dbo].[netActivityLogGetAssociations]
(
	@Id	BIGINT
)
AS            
BEGIN
		SELECT RelatedItem AS Uri
			FROM [tblActivityLog] 
			WHERE 
				@Id = pkID AND
				RelatedItem IS NOT NULL 
		UNION
		SELECT [From] AS Uri
			FROM [tblActivityLogAssociation] 
			WHERE 
				[To] = @Id AND
				[From] IS NOT NULL 
END
