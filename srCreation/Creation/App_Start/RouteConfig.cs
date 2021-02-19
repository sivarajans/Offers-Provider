using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace srCreation
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
             name: "NanoGen",
             url: "ng/NanoGen/{action}/{id}",
             defaults: new { controller = "NanoGen", action = "Go", id = UrlParameter.Optional }
            );

            routes.MapRoute(
              name: "OfferZone",
              url: "off/Offer/{action}/{id}",
              defaults: new { controller = "Offer", action = "Go", id = UrlParameter.Optional }
             );

            //routes.MapRoute(
            //    name: "ImageZone",
            //    url: "img/{controller}/{action}/{id}",
            //    defaults: new { controller = "Mirror", action = "Go", id = UrlParameter.Optional }
            //);

            routes.MapRoute(
             name: "NanoRedirect",
             url: "{id}",
             defaults: new { controller = "NanoGen", action = "Migrate" }
            );

            routes.MapRoute(
               name: "Default",
               url: "{controller}/{action}/{id}/{*catchall}",
               defaults: new { controller = "Home", action = "Go", id = UrlParameter.Optional }
           );



        }
    }
}