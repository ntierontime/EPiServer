using EPiServer.Core;

namespace EPiServerSearch.Models.Pages
{
    public interface IHasRelatedContent
    {
        ContentArea RelatedContentArea { get; }
    }
}
