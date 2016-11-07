CREATE PROCEDURE [dbo].[DateTimeConversion_GetFieldNames]
AS 
BEGIN 
	SELECT '** TABLENAME **','** DATETIME COLUMNNAME (OPTIONAL) **', '** STORENAME (OPTIONAL) **'
	-- TABLES
	UNION SELECT 'tblContent', NULL, NULL
	UNION SELECT 'tblContentLanguage', NULL, NULL
	UNION SELECT 'tblContentProperty', NULL, NULL
	UNION SELECT 'tblContentSoftlink', NULL, NULL
	UNION SELECT 'tblContentType', NULL, NULL
	UNION SELECT 'tblPlugIn', NULL, NULL
	UNION SELECT 'tblProject', NULL, NULL
	UNION SELECT 'tblPropertyDefinitionDefault', 'Date', NULL
	UNION SELECT 'tblTask', NULL, NULL
	UNION SELECT 'tblWorkContent', NULL, NULL
	UNION SELECT 'tblWorkContentProperty', NULL, NULL
	UNION SELECT 'tblXFormData', 'DatePosted', NULL
	-- STORES
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel'
	UNION SELECT 'tblIndexRequestLog', NULL, 'EPiServer.Search.Data.IndexRequestQueueItem'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiContentRestoreStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.ApplicationModules.Security.SiteSecret'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Core.PropertySettings.PropertySettingsContainer'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Core.PropertySettings.PropertySettingsGlobals'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Core.PropertySettings.PropertySettingsWrapper'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Editor.TinyMCE.TinyMCESettings'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Editor.TinyMCE.ToolbarRow'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Licensing.StoredLicense'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.MirroringService.MirroringData'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Shell.Profile.ProfileData'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Shell.Storage.PersonalizedViewSettingsStorage'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Util.BlobCleanupJobState'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Util.ContentAssetsCleanupJobState'
	UNION SELECT 'tblSystemBigTable', NULL, 'GadgetStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'VisitorGroup'
	UNION SELECT 'tblSystemBigTable', NULL, 'VisitorGroupCriterion'
	UNION SELECT 'tblSystemBigTable', NULL, 'XFormFolders'
	-- OBSOLETE STORES
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Web.HostDefinition'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Web.SiteDefinition'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardContainerStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardLayoutPartStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardTabLayoutStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardTabStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Events.Remote.EventSecret'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Licensing.SiteLicenseData'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.TaskManager.TaskManagerDynamicData'
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Core.IndexingInformation'
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Shell.Search.SearchProviderSetting'
END
