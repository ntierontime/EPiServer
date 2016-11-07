using EPiServer.Core;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace Alloy.Models.Media
{
    [ContentType(GUID = "4473CAE3-7B33-4F31-9CCF-2337231BAA48")]
    [MediaDescriptor(ExtensionString = "pdf")]
    public class MDocumentPdfFile : MDocumentFileBase
    {
    }
}
