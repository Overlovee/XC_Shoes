using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Connects;
using XC_Shoes.Models;
namespace XC_Shoes.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        public ActionResult Index()
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