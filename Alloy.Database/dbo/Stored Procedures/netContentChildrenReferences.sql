CREATE PROCEDURE [dbo].[netContentChildrenReferences]
(
	@ParentID INT,
	@LanguageID NCHAR(17),
	@ChildOrderRule INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
/*	
		/// <summary>
		/// Most recently created page will be first in list
		/// </summary>
		CreatedDescending		= 1,
		/// <summary>
		/// Oldest created page will be first in list
		/// </summary>
		CreatedAscending		= 2,
		/// <summary>
		/// Sorted alphabetical on name
		/// </summary>
		Alphabetical			= 3,
		/// <summary>
		/// Sorted on page index
		/// </summary>
		Index					= 4,
		/// <summary>
		/// Most recently changed page will be first in list
		/// </summary>
		ChangedDescending		= 5,
		/// <summary>
		/// Sort on ranking, only supported by special controls
		/// </summary>
		Rank					= 6,
		/// <summary>
		/// Oldest published page will be first in list
		/// </summary>
		PublishedAscending		= 7,
		/// <summary>
		/// Most recently published page will be first in list
		/// </summary>
		PublishedDescending		= 8
*/
	SELECT @ChildOrderRule = ChildOrderRule FROM tblContent WHERE pkID=@ParentID
		
	IF (@ChildOrderRule = 1)
	BEGIN
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent
		INNER JOIN
			tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
		WHERE 
			fkParentID=@ParentID AND tblContent.fkMasterLanguageBranchID=tblContentLanguage.fkLanguageBranchID
		ORDER BY 
			Created DESC,ContentLinkID DESC
		RETURN @@ROWCOUNT
	END
	IF (@ChildOrderRule = 2)
	BEGIN
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent
		INNER JOIN
			tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
		WHERE 
			fkParentID=@ParentID AND tblContent.fkMasterLanguageBranchID=tblContentLanguage.fkLanguageBranchID
		ORDER BY 
			Created ASC,ContentLinkID ASC
		RETURN @@ROWCOUNT
	END
	IF (@ChildOrderRule = 3)
	BEGIN
		-- Get language branch for listing since we want to sort on name
		DECLARE @LanguageBranchID INT
		SELECT 
			@LanguageBranchID = pkID 
		FROM 
			tblLanguageBranch 
		WHERE 
			LOWER(LanguageID)=LOWER(@LanguageID)
		-- If we did not find a valid language branch, go with master language branch from tblContent
		IF (@@ROWCOUNT < 1)
		BEGIN
			SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
			FROM 
				tblContent
			INNER JOIN
				tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
			WHERE 
				fkParentID=@ParentID AND tblContent.fkMasterLanguageBranchID=tblContentLanguage.fkLanguageBranchID
			ORDER BY 
				Name ASC
		    RETURN @@ROWCOUNT
		END
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent AS P
		LEFT JOIN
			tblContentLanguage AS PL ON PL.fkContentID=P.pkID AND 
			PL.fkLanguageBranchID=@LanguageBranchID
		WHERE 
			P.fkParentID=@ParentID
		ORDER BY 
			PL.Name ASC
		RETURN @@ROWCOUNT
	END
	IF (@ChildOrderRule = 4)
	BEGIN
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent
		WHERE 
			fkParentID=@ParentID
		ORDER BY 
			PeerOrder ASC
		RETURN @@ROWCOUNT
	END
	IF (@ChildOrderRule = 5)
	BEGIN
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent
		INNER JOIN
			tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
		WHERE 
			fkParentID=@ParentID AND tblContent.fkMasterLanguageBranchID=tblContentLanguage.fkLanguageBranchID
		ORDER BY 
			Changed DESC
		RETURN @@ROWCOUNT
	END
	IF (@ChildOrderRule = 7)
	BEGIN
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent
		INNER JOIN
			tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
		WHERE 
			fkParentID=@ParentID AND tblContent.fkMasterLanguageBranchID=tblContentLanguage.fkLanguageBranchID
		ORDER BY 
			StartPublish ASC
		RETURN @@ROWCOUNT
	END
	IF (@ChildOrderRule = 8)
	BEGIN
		SELECT
			pkID AS ContentLinkID, ContentType, fkContentTypeID as ContentTypeID, IsLeafNode
		FROM 
			tblContent
		INNER JOIN
			tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
		WHERE 
			fkParentID=@ParentID AND tblContent.fkMasterLanguageBranchID=tblContentLanguage.fkLanguageBranchID
		ORDER BY 
			StartPublish DESC
		RETURN @@ROWCOUNT
	END
END
