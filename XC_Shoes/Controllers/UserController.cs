using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.API;

namespace XC_Shoes.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        //private readonly GoogleDriveAPI _googleDriveApi;
        //public UserController()
        //{
        //    _googleDriveApi = new GoogleDriveAPI();
        //}
        public async Task<ActionResult> Index()
        {
            return View();
        }


        public ActionResult ShoesPage(string gender = "Men", string icon = "All")
        {
            return View();
        }

    }
}