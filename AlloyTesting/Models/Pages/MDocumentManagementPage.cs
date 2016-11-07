using System;
using System.ComponentModel.DataAnnotations;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using EPiServer.SpecializedProperties;
using Alloy.Models.Pages;
using Alloy.Models;
using Alloy;
using Alloy.Business.ContentFolders;

namespace Alloy.Models.Pages
{
    [ContentType(
        DisplayName = "MDocument Management Page", 
        GUID = "7962187b-fcd3-4d61-8e0c-bbbb8a9c6a65", 
        GroupName = "Restricted", 
        Description = "MDocuments Management Page Description")]
    [AvailableContentTypes(
        Availability.Specific,
        Include = new[] { typeof(ContentFolder), typeof(MDocumentsContentFolder) })]
    [SiteImageUrl(Global.StaticGraphicsFolderPath + "MDocumentsFolder.png")]
    public class MDocumentManagementPage : SitePageData
    {
        public virtual string Title { get; set; }
        
        //public virtual string ContentDirectory { get; set; }
        
        [CultureSpecific]
        [Display(
            Name = "Main body",
            Description = "The main body will be shown in the main content area of the page, using the XHTML-editor you can insert for example text, images and tables.",
            GroupName = SystemTabNames.Content,
            Order = 1)]
        public virtual XhtmlString MainBody { get; set; }
    }
}