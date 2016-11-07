CREATE PROCEDURE [dbo].[editSetVersionStatus]
(
	@WorkContentID INT,
	@Status INT,
	@UserName NVARCHAR(255),
	@Saved DATETIME = NULL,
	@RejectComment NVARCHAR(2000) = NULL,
	@DelayPublishUntil DateTime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	UPDATE 
		tblWorkContent
	SET
		Status = @Status,
		NewStatusByName=@UserName,
		RejectComment= COALESCE(@RejectComment, RejectComment),
		Saved = COALESCE(@Saved, Saved),
		DelayPublishUntil = @DelayPublishUntil
	WHERE
		pkID=@WorkContentID 
	IF (@@ROWCOUNT = 0)
		RETURN 1
	-- If there is no published version for this language update published table as well
	DECLARE @ContentId INT;
	DECLARE @LanguageBranchID INT;
	SELECT @LanguageBranchID = lang.fkLanguageBranchID, @ContentId = lang.fkContentID FROM tblContentLanguage AS lang INNER JOIN tblWorkContent AS work 
		ON lang.fkContentID = work.fkContentID WHERE 
		work.pkID = @WorkContentID AND work.fkLanguageBranchID = lang.fkLanguageBranchID AND lang.Status <> 4
	IF @ContentId IS NOT NULL
		BEGIN
			UPDATE
				tblContentLanguage
			SET
				Status = @Status,
				DelayPublishUntil = @DelayPublishUntil
			WHERE
				fkContentID=@ContentID AND fkLanguageBranchID=@LanguageBranchID
		END
	RETURN 0
END
