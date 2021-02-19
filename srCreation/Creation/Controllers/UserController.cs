using srEntity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace srCreation.Controllers
{
    public class UserController : Controller
    {
        
        public ActionResult Go()
        {
            return View(new _Model.User());
        }
    }
}
