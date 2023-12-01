using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XC_Shoes.Connects;
using XC_Shoes.Models;
namespace XC_Shoes.Controllers
{
    public class ShoesController : Controller
    {
        // GET: Shoes
        public ActionResult TypeShoesPartial()
        {
            ConnectTypeShoes connectShoes = new ConnectTypeShoes();
            List<TypeShoes> TypeShoesList = connectShoes.getTypeShoesData();
            return View(TypeShoesList);
        }
        public ActionResult IconsPartial()
        {
            ConnectIcons connectShoes = new ConnectIcons();
            List<Icons> IconList = connectShoes.getIconShoesData();
            return View(IconList);
        }

    }
}