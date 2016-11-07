using EPiServer;
using EPiServer.Core;
using EPiServer.DataAccess;
using EPiServer.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Alloy.Helpers
{
    public static class ContentFolderHelper
    {
        public static ContentFolder GetOrCreateSpecificFolder<T>(IEnumerable<ContentFolder> children, string folderName, ContentReference siteAssetFolder, IContentRepository contentRepository)
            where T : ContentFolder

        {
            if (children.Any(child => child.Name == folderName))
            {
                return children.First();
            }

            var folder = contentRepository.GetDefault<T>(siteAssetFolder);
            folder.Name = folderName;
            contentRepository.Save(folder, SaveAction.Publish, AccessLevel.NoAccess);

            return folder;
        }
    }
}