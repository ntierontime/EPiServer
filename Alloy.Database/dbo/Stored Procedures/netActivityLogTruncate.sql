CREATE PROCEDURE [dbo].[netActivityLogTruncate]
(
	@MaxRows BIGINT = NULL,
	@BeforeEntry BIGINT = NULL,
	@CreatedBefore DATETIME = NULL,
	@PreservedRelation  nvarchar(255) = NULL
)
AS
BEGIN	
	IF (@PreservedRelation IS NOT NULL)
	BEGIN
			DECLARE @PreservedRelationLike NVARCHAR(256) = @PreservedRelation + '%'
			IF (@MaxRows IS NOT NULL)
			BEGIN
				DELETE TOP(@MaxRows) L FROM [tblActivityLog] as L LEFT OUTER JOIN [tblActivityLogAssociation] as A ON L.pkID = A.[To]
				WHERE (((@BeforeEntry IS NULL) OR (pkID < @BeforeEntry)) AND ((@CreatedBefore IS NULL) OR (ChangeDate < @CreatedBefore))
				AND ((A.[From] IS NULL OR A.[From] NOT LIKE @PreservedRelationLike) AND (L.RelatedItem IS NULL OR L.RelatedItem NOT LIKE @PreservedRelationLike)))
			END
			ELSE
			BEGIN
				DELETE L FROM [tblActivityLog] as L LEFT OUTER JOIN [tblActivityLogAssociation] as A ON L.pkID = A.[To]
				WHERE (((@BeforeEntry IS NULL) OR (pkID < @BeforeEntry)) AND ((@CreatedBefore IS NULL) OR (ChangeDate < @CreatedBefore))
				AND ((A.[From] IS NULL OR A.[From] NOT LIKE @PreservedRelationLike) AND (L.RelatedItem IS NULL OR L.RelatedItem NOT LIKE @PreservedRelationLike)))
			END
	END
	ELSE
	BEGIN
		IF (@MaxRows IS NOT NULL)
		BEGIN
			DELETE TOP(@MaxRows) FROM [tblActivityLog] 
			WHERE ((@BeforeEntry IS NULL) OR (pkID < @BeforeEntry)) AND ((@CreatedBefore IS NULL) OR (ChangeDate < @CreatedBefore))
		END
		ELSE
		BEGIN
			DELETE FROM [tblActivityLog] 
			WHERE ((@BeforeEntry IS NULL) OR (pkID < @BeforeEntry)) AND ((@CreatedBefore IS NULL) OR (ChangeDate < @CreatedBefore))
		END
	END
	RETURN @@ROWCOUNT
END
