using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using EPiServer;
using EPiServer.Core;
using EPiServer.Framework.DataAnnotations;
using EPiServer.Web.Mvc;
using Alloy.Models.Pages;
using Alloy.Controllers;
using Alloy.Models.ViewModels;
using EPiServer.DataAccess;
using EPiServer.Security;
using Alloy.Business.ContentFolders;
using EPiServer.ServiceLocation;
using Alloy.Models.Media;

namespace Alloy.Controllers
{
    public class MDocumentManagementPageController : PageControllerBase<MDocumentManagementPage>
    {
        public ActionResult Index(MDocumentManagementPage currentPage)
        {
            var model = PageViewModel.Create(currentPage);

            var contentAssetHelper = ServiceLocator.Current.GetInstance<ContentAssetHelper>();
            var ownerNode = contentAssetHelper.GetOrCreateAssetFolder(currentPage.ContentLink);
            
            IContentRepository contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

            ContentReference assetFolder = ownerNode.ContentLink;
            IEnumerable<ContentFolder> children = contentRepository.GetChildren<ContentFolder>(assetFolder).ToList();

            var folder = Alloy.Helpers.ContentFolderHelper.GetOrCreateSpecificFolder<MDocumentsContentFolder>(children, "MDocuments", assetFolder, contentRepository);
            List<MDocumentFileBase> childrenImageFiles = contentRepository.GetChildren<MDocumentFileBase>(folder.ContentLink).ToList();
            ViewBag.MDocumentsList = childrenImageFiles;

            return View(model);
        }
    }
}