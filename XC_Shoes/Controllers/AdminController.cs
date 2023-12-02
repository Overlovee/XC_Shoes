using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Models;
using XC_Shoes.Connects;

namespace XC_Shoes.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        ConnectShoes connectShoes = new ConnectShoes();
        public ActionResult Home(string styleStyle = "Men")
        {
            List<Shoe> list = connectShoes.getShoesDataByStyleType(styleStyle);
            return View(list);
        }
        public ActionResult ManageProduct(string styleStyle = "Men")
        {
            List<Shoe> list = connectShoes.getShoesDataByStyleType(styleStyle);
            return View(list);
        }
    }
}