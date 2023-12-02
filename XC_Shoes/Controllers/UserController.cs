using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Connects;
using XC_Shoes.Models;
using XC_Shoes.API;

namespace XC_Shoes.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        //GoogleDriveAPI googleDriveAPI = new GoogleDriveAPI();
        public async Task<ActionResult> Index()
        {
            return View();
        }


        public ActionResult ShoesPage(string gender = "Men", string icon = "All")
        {
            ConnectShoes connectShoes = new ConnectShoes();
            List<Shoe> ListShoes = connectShoes.getShoesData(gender);
            return View(ListShoes);
        }

    }
}