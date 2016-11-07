using EPiServer.Core;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace Alloy.Models.Media
{
    [ContentType(GUID = "D8C528EF-8842-4F8A-B65C-D330BAD19459")]
    [MediaDescriptor(ExtensionString = "odp,pot,potm,potx,ppa,ppam,pps,ppsx,ppt,pptm,pptx")]
    public class MDocumentPPTFile : MDocumentFileBase
    {
    }
}
