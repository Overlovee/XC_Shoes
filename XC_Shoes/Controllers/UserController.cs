using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
<<<<<<< HEAD
using XC_Shoes.API;

=======
using XC_Shoes.Connects;
using XC_Shoes.Models;
>>>>>>> 0da3ae7ac7451c3fdd20eb00f89e7995e6a993e5
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
            ConnectShoes connectShoes = new ConnectShoes();
            List<Shoes> ListShoes = connectShoes.getShoesData(gender);
            return View(ListShoes);
        }

    }
}