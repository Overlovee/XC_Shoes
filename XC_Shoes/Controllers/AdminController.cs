using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Models;
using XC_Shoes.Connects;
using System.Web.Services.Description;

namespace XC_Shoes.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        ConnectShoes connectShoes = new ConnectShoes();
        public ActionResult Home()
        {
            return View();
        }
        public ActionResult ManageProduct(string styleStyle = "Men", string sort = "ASC", string search = "")
        {
            List<Shoe> list = connectShoes.getShoesDataByStyleType(styleStyle, sort, search);
            ViewBag.Title = "Manage Product";
            ViewBag.Style = styleStyle;
            ViewBag.Sort = sort;
            ViewBag.SearchValue = search;
            return View(list);
        }
    }
}