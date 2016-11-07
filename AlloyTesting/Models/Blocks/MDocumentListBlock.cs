using System;
using System.ComponentModel.DataAnnotations;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using System.Collections.Generic;
using Alloy.Models.Media;

namespace Alloy.Models.Blocks
{
    [ContentType(DisplayName = "MDocumentList Block", GUID = "21c37c2e-4735-42e7-b5fc-4b80811b30de", Description = "MDocumentList Block Description")]
    public class MDocumentListBlock : SiteBlockData
    {
        public PageData CurrentPage
        {
            get
            {
                var pageRouteHelper = EPiServer.ServiceLocation.ServiceLocator.Current.GetInstance<EPiServer.Web.Routing.IPageRouteHelper>();
                return pageRouteHelper.Page;
            }
        }

        //public List<MDocumentFileBase> MDocumentFiles { get; set; }
    }
}