using EPiServer.DataAnnotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Alloy.Models.Media
{
    [ContentType(GUID = "A1AA0743-DEAD-40F8-9EBC-CB9FB8557D11")]
    public class MDocumentFileBase : GenericMedia, IMDocumentFile
    {
        public virtual string M_Title { get; set; }

        public virtual string M_Type { get; set; }

        public virtual string M_FileName { get; set; }

        public virtual string M_Directory { get; set; }
    }
}
