using System;
using System.Net;
using System.Web.Mvc;
using EPiServer.Find.Framework.Statistics;
using EPiServer.Find.Helpers.Text;
using EPiServer.Framework.Web.Resources;
using EpiserverFind.Models.Pages;
using EpiserverFind.Models.ViewModels;
using EPiServer.Find.UI;
using EPiServer.Find.UnifiedSearch;
using EPiServer.Globalization;
using EPiServer.Find;
using EpiserverFind.Controllers;
using EPiServer.Web;
using EPiServer.Find.Cms;

namespace EpiserverFind.Controllers
{
    public class FindSearchPageController : PageControllerBase<FindSearchPage>
    {
        private readonly IClient searchClient;
        private readonly IFindUIConfiguration findUIConfiguration;
        private readonly IRequiredClientResourceList requiredClientResourceList;

        public FindSearchPageController(IClient searchClient, IFindUIConfiguration findUIConfiguration, IRequiredClientResourceList requiredClientResourceList)
        {
            this.searchClient = searchClient;
            this.findUIConfiguration = findUIConfiguration;
            this.requiredClientResourceList = requiredClientResourceList;
        }

        [ValidateInput(false)]
        public ViewResult Index(FindSearchPage currentPage, string q)
        {
            var model = new FindSearchContentModel(currentPage)
                {
                    PublicProxyPath = findUIConfiguration.AbsolutePublicProxyPath()
                };

            //detect if serviceUrl and/or defaultIndex is configured.
            model.IsConfigured = SearchIndexIsConfigured(EPiServer.Find.Configuration.GetConfiguration());

            if (model.IsConfigured && !string.IsNullOrWhiteSpace(model.Query))
            {
                var query = BuildQuery(model);

                //Create a hit specification to determine display based on values entered by an editor on the search page.
                var hitSpec = new HitSpecification
                {
                    HighlightTitle = model.CurrentPage.HighlightTitles,
                    HighlightExcerpt = model.CurrentPage.HighlightExcerpts,
                    ExcerptLength = model.ExcerptLength
                };

                try
                {
                    model.Hits = query.GetResult(hitSpec);
                }
                catch (WebException wex)
                {
                    model.IsConfigured = wex.Status != WebExceptionStatus.NameResolutionFailure;
                }
            }

            RequireClientResources();

            return View(model);
        }

        private ITypeSearch<ISearchContent> BuildQuery(FindSearchContentModel model)
        {
            var queryFor = searchClient.UnifiedSearch().For(model.Query);

            if (model.UseAndForMultipleSearchTerms)
            {
              queryFor = queryFor.WithAndAsDefaultOperator();
            }

            var query = queryFor
                .UsingSynonyms()
                .UsingAutoBoost(TimeSpan.FromDays(30))
                //Include a facet whose value is used to show the total number of hits regardless of section.
                //The filter here is irrelevant but should match *everything*.
                .TermsFacetFor(x => x.SearchSection)
                .FilterFacet("AllSections", x => x.SearchSection.Exists())
                //Fetch the specific paging page.
                .Skip((model.PagingPage - 1)*model.CurrentPage.PageSize)
                .Take(model.CurrentPage.PageSize)
                //Allow editors (from the Find/Optimizations view) to push specific hits to the top 
                //for certain search phrases.
                .ApplyBestBets();

            // obey DNT
            var doNotTrackHeader = System.Web.HttpContext.Current.Request.Headers.Get("DNT");
            // Should not track when value equals 1
            if (doNotTrackHeader == null || doNotTrackHeader.Equals("0"))
            {
                query = query.Track();
            }

            //If a section filter exists (in the query string) we apply
            //a filter to only show hits from a given section.
            if (!string.IsNullOrWhiteSpace(model.SectionFilter))
            {
                query = query.FilterHits(x => x.SearchSection.Match(model.SectionFilter));
            }
            return query;
        }

        /// <summary>
        /// Checks if service url and index are configured
        /// </summary>
        /// <param name="configuration">Find configuration</param>
        /// <returns>True if configured, false otherwise</returns>
        private bool SearchIndexIsConfigured(EPiServer.Find.Configuration configuration)
        {
            return (!configuration.ServiceUrl.IsNullOrEmpty()
                    && !configuration.ServiceUrl.Contains("YOUR_URI")
                    && !configuration.DefaultIndex.IsNullOrEmpty()
                    && !configuration.DefaultIndex.Equals("YOUR_INDEX"));
        }

        /// <summary>
        /// Requires the client resources used in the view.
        /// </summary>
        private void RequireClientResources()
        {
            // jQuery.UI is used in autocomplete example.
            // Add jQuery.UI files to existing client resource bundles or load it from CDN or use any other alternative library.
            // We use local resources for demo purposes without Internet connection.
            requiredClientResourceList.RequireStyle(VirtualPathUtilityEx.ToAbsolute("~/Static/css/jquery-ui.css"));
            requiredClientResourceList.RequireScript(VirtualPathUtilityEx.ToAbsolute("~/Static/js/jquery-ui.js")).AtFooter();
        }
    }
}
