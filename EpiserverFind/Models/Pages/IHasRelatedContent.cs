using EPiServer.Core;

namespace EpiserverFind.Models.Pages
{
    public interface IHasRelatedContent
    {
        ContentArea RelatedContentArea { get; }
    }
}
