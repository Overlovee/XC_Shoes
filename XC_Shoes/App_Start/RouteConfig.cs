using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace XC_Shoes
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
<<<<<<< HEAD
                defaults: new { controller = "User", action = "ShoesPage", id = UrlParameter.Optional }
=======
                defaults: new { controller = "Admin", action = "Home", id = UrlParameter.Optional }
>>>>>>> 48fc07dd77edcbd86adcaadf14465d0be778973c
            );
        }
    }
}
