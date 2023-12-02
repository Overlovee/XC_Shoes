using Google.Apis.Auth.OAuth2;
using Google.Apis.Drive.v3;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading;
using System.Web;

namespace XC_Shoes.API
{
    public class GoogleDriveAPI
    {
        UserCredential credential;
        public GoogleDriveAPI()
        {
            string projectDirectory = System.Web.Hosting.HostingEnvironment.MapPath("~");
            string credentialsPath = Path.Combine(projectDirectory, "Credentials", "credentials.json");

            GoogleClientSecrets clientSecrets;

            using (var stream = new FileStream(credentialsPath, FileMode.Open, FileAccess.Read))
            {
                clientSecrets = GoogleClientSecrets.Load(stream);
            }

            credentialsPath = Path.Combine(projectDirectory, "Credentials", "token.json");

            var credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                clientSecrets.Secrets,
                new[] { DriveService.Scope.Drive },
                "user",
                CancellationToken.None,
                new FileDataStore(credentialsPath, true)
            ).Result;

            DriveService service = new DriveService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = "XC Shoes Store",
            });
        }
        public void CreateFolder(string nameFolder)
        {
            var driveService = new DriveService(new BaseClientService.Initializer
            {
                HttpClientInitializer = credential,
                ApplicationName = "XC Shoes Store",
            });

            var folderMetadata = new Google.Apis.Drive.v3.Data.File
            {
                Name = nameFolder,
                MimeType = "application/vnd.google-apps.folder",
            };

            var request = driveService.Files.Create(folderMetadata);
            request.Fields = "id";
            var folder = request.Execute();
        }
    }
}