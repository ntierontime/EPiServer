using System.Web.Mvc;
using Alloy.Models.Pages;
using Alloy.Models.ViewModels;
using EPiServer.Web;
using EPiServer.Web.Mvc;
using EPiServer.Core;
using EPiServer.ServiceLocation;
using EPiServer;
using EPiServer.Security;
using EPiServer.DataAccess;
using Alloy.Business.ContentFolders;

namespace Alloy.Controllers
{
    public class StartPageController : PageControllerBase<StartPage>
    {
        public ActionResult Index(StartPage currentPage)
        {
            var model = PageViewModel.Create(currentPage);

            if (SiteDefinition.Current.StartPage.CompareToIgnoreWorkID(currentPage.ContentLink)) // Check if it is the StartPage or just a page of the StartPage type.
            {
                //Connect the view models logotype property to the start page's to make it editable
                var editHints = ViewData.GetEditHints<PageViewModel<StartPage>, StartPage>();
                editHints.AddConnection(m => m.Layout.Logotype, p => p.SiteLogotype);
                editHints.AddConnection(m => m.Layout.ProductPages, p => p.ProductPageLinks);
                editHints.AddConnection(m => m.Layout.CompanyInformationPages, p => p.CompanyInformationPageLinks);
                editHints.AddConnection(m => m.Layout.NewsPages, p => p.NewsPageLinks);
                editHints.AddConnection(m => m.Layout.CustomerZonePages, p => p.CustomerZonePageLinks);
            }

            return View(model);
        }

        private ContentFolder GetOrCreateFolder(ContentReference parentFolder, string folderName, string languageId)
        {
            IContentRepository contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
            var languageSelector = new LanguageSelector(languageId);
            var storedFolder =
                contentRepository.GetBySegment(parentFolder, folderName, languageSelector);// as ContentFolder;
            if (storedFolder != null)
            {
                return storedFolder as ContentFolder;
            }
            storedFolder = contentRepository.GetDefault<ContentFolder>(parentFolder);
            storedFolder.Name = folderName;
            contentRepository.Save(storedFolder, EPiServer.DataAccess.SaveAction.Publish, AccessLevel.NoAccess);
            return storedFolder as ContentFolder;
        }
    }
}
