using EPiServer.Core;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace Alloy.Models.Media
{
    [ContentType(GUID = "780C8A17-AA44-4F07-86C6-ACA7A3827554")]
    [MediaDescriptor(ExtensionString = "xla,xlam,xls,xlsx,xlsm,xlsb,xlt,xlw,csv")]
    public class MDocumentExcelFile : MDocumentFileBase
    {
    }
}

