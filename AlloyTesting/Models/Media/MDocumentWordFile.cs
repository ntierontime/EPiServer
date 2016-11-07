using EPiServer.Core;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace Alloy.Models.Media
{
    [ContentType(GUID = "CC6ECF1F-B803-43BE-96F0-3C2D1A072D0E")]
    [MediaDescriptor(ExtensionString = "doc,docm,docx,dot,dotm,dotx")]
    public class MDocumentWordFile : MDocumentFileBase
    {
    }
}

