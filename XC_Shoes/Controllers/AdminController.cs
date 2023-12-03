using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Models;
using XC_Shoes.Connects;
using System.Web.Services.Description;
using System.IO;

namespace XC_Shoes.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        ConnectShoes connectShoes = new ConnectShoes();
        ConnectUsers connectUsers = new ConnectUsers();
        ConnectOrders connectOrders = new ConnectOrders();
        User user = new User();
        public AdminController() {
            user = connectUsers.getDataByID("US1");
            string resourcesPath = "~/Resources/Account/";
            resourcesPath = Path.Combine(resourcesPath, user.Image);
            ViewBag.ThisAccountImage = resourcesPath;
        }
        public ActionResult Home()
        {
            ViewBag.Title = "Home";
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
        public ActionResult ManageUser(string role = "0", string sort = "ASC", string search = "")
        {
            List<User> list = connectUsers.getData(role, sort, search);
            ViewBag.Title = "Manage User";
            ViewBag.Role = role;
            ViewBag.Sort = sort;
            ViewBag.Total = list.Count;
            ViewBag.SearchValue = search;
            return View(list);
        }
        public ActionResult ManageAdmin(string role = "1", string sort = "ASC", string search = "")
        {
            List<User> list = connectUsers.getData(role, sort, search);
            ViewBag.Title = "Manage Admin";
            ViewBag.Role = role;
            ViewBag.Sort = sort;
            ViewBag.SearchValue = search;
            ViewBag.Total = list.Count;
            return View(list);
        }
        public ActionResult MyAccount(User userUpdate = null)
        {
            ViewBag.Title = user.UserName;
            return View(user);
        }

        public ActionResult ManageOrder(string status = "Wait for confirmation", string sort = "ASC", string search = "")
        {
            List<Order> list = connectOrders.getFullOrderData(status, sort, search);
            ViewBag.Title = "Manage Order";
            ViewBag.Sort = sort;
            ViewBag.Status = status;
            ViewBag.SearchValue = search;
            ViewBag.Total = list.Count;
            ViewBag.NumberProductInPage = 0;
            return View(list);
        }
        public ActionResult ConfirmOrder(string id, string status = "Wait for confirmation", string sort = "ASC", string search = "")
        {
            return RedirectToAction("ManageOrder");
        }
    }
}