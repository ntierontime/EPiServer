using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using EPiServer;
using EPiServer.Core;
using EPiServer.Web;
using EPiServer.Web.Mvc;
using Alloy.Models.Blocks;
using EPiServer.ServiceLocation;
using Alloy.Business.ContentFolders;
using Alloy.Models.Media;

namespace Alloy.Controllers
{
    public class MDocumentListBlockController : BlockController<MDocumentListBlock>
    {
        public override ActionResult Index(MDocumentListBlock currentBlock)
        {
            //var contentAssetHelper = ServiceLocator.Current.GetInstance<ContentAssetHelper>();
            //var ownerNode = contentAssetHelper.GetOrCreateAssetFolder(currentBlock.CurrentPage.ContentLink);

            //IContentRepository contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

            //ContentReference assetFolder = ownerNode.ContentLink;
            //IEnumerable<ContentFolder> children = contentRepository.GetChildren<ContentFolder>(assetFolder).ToList();

            //var folder = Alloy.Helpers.ContentFolderHelper.GetOrCreateSpecificFolder<MDocumentsContentFolder>(children, "MDocuments", assetFolder, contentRepository);
            //List<MDocumentFileBase> childrenFiles = contentRepository.GetChildren<MDocumentFileBase>(folder.ContentLink).ToList();
            //ViewBag.MDocumentFiles = childrenFiles;

            return PartialView(currentBlock);
        }
    }
}
