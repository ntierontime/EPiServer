//using EPiServer;
//using EPiServer.Core;
//using EPiServer.DataAccess;
//using EPiServer.Framework;
//using EPiServer.Framework.Initialization;
//using EPiServer.Security;
//using EPiServer.ServiceLocation;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;

//using Alloy.Business.ContentFolders;
//using EPiServer.Data.Entity;
//using EPiServer.Filters;

//namespace Alloy
//{
//    [InitializableModule]
//    [ModuleDependency(typeof(EPiServer.Web.InitializationModule))]
//    public class RestrictedContentFolderInitializationModule : IInitializableModule
//    {
//        public void Initialize(InitializationEngine context)
//        {
//            IContentRepository contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

//            ContentReference siteAssetFolder = ContentReference.SiteBlockFolder;
//            IEnumerable<ContentFolder> children = contentRepository.GetChildren<ContentFolder>(siteAssetFolder).ToList();

//            Alloy.Helpers.ContentFolderHelper.CreateSpecificFolderIfNotExists<MDocumentsContentFolder>(children, "MDocuments", siteAssetFolder, contentRepository);
//        }

//        public void Uninitialize(InitializationEngine context)
//        {
//        }

//        //private void CreateSpecificFolder<T>(IEnumerable<ContentFolder> children, string folderName, ContentReference siteAssetFolder, IContentRepository contentRepository) where T : IContent
//        //{
//        //    if (children.Any(child => child.Name == folderName))
//        //    {
//        //        return;
//        //    }

//        //    var folder = contentRepository.GetDefault<T>(siteAssetFolder);
//        //    folder.Name = folderName;
//        //    contentRepository.Save(folder, SaveAction.Publish, AccessLevel.NoAccess);
//        //}

//    }
//}