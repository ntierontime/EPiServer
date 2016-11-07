CREATE PROCEDURE [dbo].[netFindContentCoreDataByContentGuid]
	@ContentGuid UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
        --- *** use NOLOCK since this may be called during page save if debugging. The code should not be written so this happens, it's to make it work in the debugger ***
	SELECT TOP 1 P.pkID as ID, P.fkContentTypeID as ContentTypeID, P.fkParentID as ParentID, P.ContentGUID, PL.LinkURL, P.Deleted, CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish, PL.Created, PL.Changed, PL.Saved, PL.StartPublish, PL.StopPublish, P.ContentAssetsID, P.fkMasterLanguageBranchID as MasterLanguageBranchID, PL.ContentLinkGUID as ContentLinkID, PL.AutomaticLink, PL.FetchData, P.ContentType
	FROM tblContent AS P WITH (NOLOCK)
	LEFT JOIN tblContentLanguage AS PL ON PL.fkContentID=P.pkID
	WHERE P.ContentGUID = @ContentGuid AND (P.fkMasterLanguageBranchID=PL.fkLanguageBranchID OR P.fkMasterLanguageBranchID IS NULL)
END
