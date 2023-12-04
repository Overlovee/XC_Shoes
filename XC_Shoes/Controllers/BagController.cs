using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Connects;
using XC_Shoes.Models;
namespace XC_Shoes.Controllers
{
    public class BagController : Controller
    {
        // GET: Bag
        DbContext db = new DbContext();
        public ActionResult ShowBagPage(string userID = "US3")
        {
            ConnectBag connectBag = new ConnectBag();
            List<Bag> bagList = connectBag.getBagData(userID);
            return View(bagList);
        }
    }
}