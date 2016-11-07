CREATE PROCEDURE [dbo].[editSetCommonDraftVersion]
(
	@WorkContentID INT,
	@Force BIT
)
AS
BEGIN
   SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE  @ContentLink INT
	DECLARE  @LangID INT
	DECLARE  @CommonDraft INT
	
	-- Find the ConntentLink and Language for the Page Work ID 
	SELECT   @ContentLink = fkContentID, @LangID = fkLanguageBranchID, @CommonDraft = CommonDraft from tblWorkContent where pkID = @WorkContentID
	
	
	-- If the force flag or there is a common draft which is published we will reset the common draft
	if (@Force = 1 OR EXISTS(SELECT * FROM tblWorkContent WITH(NOLOCK) WHERE fkContentID = @ContentLink AND Status=4 AND fkLanguageBranchID = @LangID AND CommonDraft = 1))
	BEGIN 	
		-- We should remove the old common draft from other content version repect to language
		UPDATE 
			tblWorkContent
		SET
			CommonDraft = 0
		FROM  tblWorkContent WITH(INDEX(IDX_tblWorkContent_fkContentID))
		WHERE
			fkContentID = @ContentLink and fkLanguageBranchID  = @LangID  
	END
	-- If the forct flag or there is no common draft for the page wirh respect to language
	IF (@Force = 1 OR NOT EXISTS(SELECT * from tblWorkContent WITH(NOLOCK)  where fkContentID = @ContentLink AND fkLanguageBranchID = @LangID AND CommonDraft = 1))
	BEGIN
		UPDATE 
			tblWorkContent
		SET
			CommonDraft = 1
		WHERE
			pkID = @WorkContentID
	END	
		
	IF (@@ROWCOUNT = 0)
		RETURN 1
	RETURN 0
END
