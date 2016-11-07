using System;
using System.ComponentModel.DataAnnotations;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using System.Collections.Generic;
using Alloy.Models.Media;
using EPiServer;
using EPiServer.Web;
using EPiServer.XForms;
using System.ComponentModel;

namespace Alloy.Models.Blocks
{
    [ContentType(DisplayName = "MDocumentList Block", GUID = "21c37c2e-4735-42e7-b5fc-4b80811b30de", Description = "MDocumentList Block Description")]
    public class MDocumentListBlock : SiteBlockData
    {
        [Display(Order = 1, GroupName = SystemTabNames.Content)]
        [Required]
        public virtual string ButtonText { get; set; }

        [Display(Order = 2, GroupName = SystemTabNames.Content)]
        [Required]
        public virtual Url ButtonLink { get; set; }

        [Display(
            GroupName = SystemTabNames.Content,
            Order = 3)]
        [CultureSpecific]
        [UIHint(UIHint.Image)]
        [Required]
        public virtual ContentReference Image { get; set; }

        /// <summary>
        /// Gets or sets the contact page from which contact information should be retrieved
        /// </summary>
        [Display(
            GroupName = SystemTabNames.Content,
            Order = 4)]
        [UIHint(Global.SiteUIHints.Contact)]
        [Required]
        public virtual PageReference ContactPageLink { get; set; }

        [Display(
            GroupName = SystemTabNames.Content,
            Order = 5)]
        [CultureSpecific]
        [Required]
        public virtual XForm Form { get; set; }

        [Display(Order = 6
            , GroupName = SystemTabNames.Content)]
        [CultureSpecific]
        [Required]
        public virtual XhtmlString MainBody { get; set; }

        [Display(
            GroupName = SystemTabNames.Content,
            Order = 7)]
        [DefaultValue(false)]
        [Required]
        public virtual bool IncludePublishDate { get; set; }

        [Display(
            GroupName = SystemTabNames.Content,
            Order = 8)]
        [Required]
        public virtual DateTime TestDate { get; set; }

        [Display(
            GroupName = SystemTabNames.Content,
            Order = 9)]
        [Required]
        public virtual int TestInteger { get; set; }
    }
}