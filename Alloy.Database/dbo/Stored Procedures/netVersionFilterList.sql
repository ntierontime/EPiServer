CREATE PROCEDURE [dbo].[netVersionFilterList]
(
    @StartIndex INT,
    @MaxRows INT,
	@ContentID INT = NULL,
	@ChangedBy NVARCHAR(255) = NULL,
	@ExcludeDeleted BIT = 0,
	@LanguageIds dbo.IDTable READONLY,
	@Statuses dbo.IDTable READONLY
)
AS
BEGIN	
	SET NOCOUNT ON
	DECLARE @StatusCount INT
	SELECT @StatusCount = COUNT(*) FROM @Statuses
	DECLARE @LanguageCount INT
	SELECT @LanguageCount = COUNT(*) FROM @LanguageIds;
	
	WITH TempResult as
	(
		SELECT ROW_NUMBER() OVER(ORDER BY W.Saved DESC) as RowNumber,
			W.fkContentID AS ContentID,
			W.pkID AS WorkID,
			W.Status AS VersionStatus,
			W.ChangedByName AS SavedBy,
			W.Saved AS ItemCreated,
			W.Name,
			W.fkLanguageBranchID as LanguageBranchID,
			W.CommonDraft,
			W.fkMasterVersionID as MasterVersion,
			CASE WHEN C.fkMasterLanguageBranchID=W.fkLanguageBranchID THEN 1 ELSE 0 END AS IsMasterLanguageBranch,
			W.NewStatusByName As StatusChangedBy,
			W.DelayPublishUntil
		FROM
			tblWorkContent AS W
			INNER JOIN
			tblContent AS C ON C.pkID=W.fkContentID
		WHERE
			((@ContentID IS NULL) OR W.fkContentID=@ContentID) AND
			((@ChangedBy IS NULL) OR W.ChangedByName=@ChangedBy) AND
			((@StatusCount = 0) OR (W.Status IN (SELECT ID FROM @Statuses))) AND
            ((@LanguageCount = 0) OR (W.fkLanguageBranchID IN (SELECT ID FROM @LanguageIds))) AND
			((@ExcludeDeleted = 0) OR (C.Deleted = 0))
	)
	SELECT  ContentID, WorkID, VersionStatus, SavedBy, ItemCreated, Name, LanguageBranchID, CommonDraft, MasterVersion, IsMasterLanguageBranch, StatusChangedBy, DelayPublishUntil, (SELECT COUNT(*) FROM TempResult) AS 'TotalRows'
	FROM    TempResult
	WHERE RowNumber BETWEEN (@StartIndex +1) AND (@MaxRows + @StartIndex)
   		
END
