using Google.Apis.Auth.OAuth2;
using Google.Apis.Drive.v3;
using Google.Apis.Services;
using Google.Apis;
using Google.Apis.Util.Store;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.UI.WebControls;

namespace XC_Shoes.API
{
    public class GoogleDriveAPI
    {
        private const string ClientId = "1069009233830-io2h6ifsm0ab464nqsg0b0grl9voc964.apps.googleusercontent.com";
        private const string ClientSecret = "1069009233830-io2h6ifsm0ab464nqsg0b0grl9voc964.apps.googleusercontent.com";
        private const string RedirectUri = "https://developers.google.com/oauthplayground";

        private const string RefreshToken = "1//04-EXI0oSDJvzCgYIARAAGAQSNwF-L9Ir0hC_2tco9b5FiIk_YNsisACuk2p6fO42CzNUxn6vGHRNK8DjKEXKv70xJUeA7ERrBeU";

        private readonly DriveService _driveService;

        public GoogleDriveAPI()
        {
            UserCredential credential = GetUserCredential().Result;

            _driveService = new DriveService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = "Google Drive API Demo",
            });
        }

        private async Task<UserCredential> GetUserCredential()
        {
            try
            {
                var projectDirectory = System.Web.Hosting.HostingEnvironment.MapPath("~");
                var credentialsPath = Path.Combine(projectDirectory, "bin", "credentials.json");

                var credentialsJson = File.ReadAllText(credentialsPath);

                string[] Scopes = { DriveService.Scope.Drive };

                UserCredential credential;

                var credentialPath = Path.Combine(projectDirectory, "bin", "token.json");

                var clientSecrets = new ClientSecrets
                {
                    ClientId = "1069009233830-io2h6ifsm0ab464nqsg0b0grl9voc964.apps.googleusercontent.com",
                    ClientSecret = "1069009233830-io2h6ifsm0ab464nqsg0b0grl9voc964.apps.googleusercontent.com"
                };

                credential = await GoogleWebAuthorizationBroker.AuthorizeAsync(
                    clientSecrets,
                    Scopes,
                    "user",
                    CancellationToken.None,
                    new FileDataStore(credentialPath, true));

                return credential;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error getting user credential: {ex.Message}");
                throw;
            }
        }

        public async Task<string> UploadFile(string filePath, string fileName)
        {
            try
            {
                var fileMetadata = new Google.Apis.Drive.v3.Data.File()
                {
                    Name = fileName,
                    MimeType = "image/jpg",
                };

                using (var stream = new FileStream(filePath, FileMode.Open))
                {
                    var request = _driveService.Files.Create(fileMetadata, stream, "image/jpg");
                    request.Upload();

                    // Lấy ID của tệp tin đã tải lên
                    var uploadedFileId = request.ResponseBody.Id;

                    // Lưu ID vào danh sách để sử dụng sau này
                    await SaveFileId(uploadedFileId);

                    return uploadedFileId;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error uploading file: {ex.Message}");
                return null;
            }
        }

        public async Task DeleteFile(string fileName)
        {
            try
            {
                // Truy xuất ID từ danh sách lưu trữ
                var fileId = await GetFileId(fileName);

                if (fileId != null)
                {
                    await _driveService.Files.Delete(fileId).ExecuteAsync();
                    Console.WriteLine("File deleted successfully.");
                }
                else
                {
                    Console.WriteLine($"File '{fileName}' not found.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deleting file: {ex.Message}");
            }
        }

        public async Task GeneratePublicUrl(string fileName)
        {
            try
            {
                // Truy xuất ID từ danh sách lưu trữ
                var fileId = await GetFileId(fileName);

                if (fileId != null)
                {
                    var permission = new Google.Apis.Drive.v3.Data.Permission
                    {
                        Role = "reader",
                        Type = "anyone",
                    };

                    await _driveService.Permissions.Create(permission, fileId).ExecuteAsync();

                    var file = await _driveService.Files.Get(fileId).ExecuteAsync();

                    Console.WriteLine($"WebViewLink: {file.WebViewLink}");
                    Console.WriteLine($"WebContentLink: {file.WebContentLink}");
                }
                else
                {
                    Console.WriteLine($"File '{fileName}' not found.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error generating public URL: {ex.Message}");
            }
        }

        public async Task CreateFolder(string folderName)
        {
            try
            {
                var folderMetadata = new Google.Apis.Drive.v3.Data.File
                {
                    Name = folderName,
                    MimeType = "application/vnd.google-apps.folder"
                };

                var request = _driveService.Files.Create(folderMetadata);
                request.Fields = "id";

                var folder = await request.ExecuteAsync();

                Console.WriteLine($"Folder '{folderName}' created with ID: {folder.Id}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error creating folder '{folderName}': {ex.Message}");
            }
        }

        private async Task SaveFileId(string fileId)
        {
            // Lưu ID vào danh sách (có thể lưu vào cơ sở dữ liệu, file, hoặc nơi lưu trữ khác)
            // Đây chỉ là ví dụ, bạn cần triển khai theo cách thích hợp cho ứng dụng của mình.
            // Trong ví dụ này, sử dụng một danh sách tạm thời trong bộ nhớ.
            var fileIds = await LoadFileIds();
            fileIds.Add(fileId);
            await SaveFileIds(fileIds);
        }

        private async Task<string> GetFileId(string fileName)
        {
            // Truy xuất ID từ danh sách (có thể truy xuất từ cơ sở dữ liệu, file, hoặc nơi lưu trữ khác)
            // Đây chỉ là ví dụ, bạn cần triển khai theo cách thích hợp cho ứng dụng của mình.
            // Trong ví dụ này, sử dụng một danh sách tạm thời trong bộ nhớ.
            var fileIds = await LoadFileIds();
            return fileIds.Find(id => id.Contains(fileName));
        }

        private async Task<List<string>> LoadFileIds()
        {
            // Tải danh sách ID từ nơi lưu trữ (có thể tải từ cơ sở dữ liệu, file, hoặc nơi lưu trữ khác)
            // Đây chỉ là ví dụ, bạn cần triển khai theo cách thích hợp cho ứng dụng của mình.
            // Trong ví dụ này, sử dụng một danh sách tạm thời trong bộ nhớ.
            // FileIds.json là file lưu trữ danh sách ID.
            if (File.Exists("FileIds.json"))
            {
                var json = File.ReadAllText("FileIds.json");
                return Newtonsoft.Json.JsonConvert.DeserializeObject<List<string>>(json);
            }
            else
            {
                return new List<string>();
            }
        }

        private async Task SaveFileIds(List<string> fileIds)
        {
            // Lưu danh sách ID vào nơi lưu trữ (có thể lưu vào cơ sở dữ liệu, file, hoặc nơi lưu trữ khác)
            // Đây chỉ là ví dụ, bạn cần triển khai theo cách thích hợp cho ứng dụng của mình.
            // Trong ví dụ này, sử dụng một danh sách tạm thời trong bộ nhớ.
            // FileIds.json là file lưu trữ danh sách ID.
            var json = Newtonsoft.Json.JsonConvert.SerializeObject(fileIds);
            File.WriteAllText("FileIds.json", json);
        }


        //static string[] Scopes = { DriveService.Scope.Drive };
        //static string ApplicationName = "Application_upload_file_laptrinh_vb";
        //private void UploadImage(string path, DriveService service, string folderUpload)
        //{


        //    var fileMetadata = new Google.Apis.Drive.v3.Data.File();
        //    fileMetadata.Name = Path.GetFileName(path);
        //    fileMetadata.MimeType = "image/*";

        //    fileMetadata.Parents = new List
        //    {
        //        folderUpload
        //    };


        //    FilesResource.CreateMediaUpload request;
        //    using (var stream = new System.IO.FileStream(path, System.IO.FileMode.Open))
        //    {
        //        request = service.Files.Create(fileMetadata, stream, "image/*");
        //        request.Fields = "id";
        //        request.Upload();
        //    }

        //    var file = request.ResponseBody;

        //    //textBox1.Text += ("File ID: " + file.Id);

        //}
    }
}