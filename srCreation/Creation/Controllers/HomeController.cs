using srEntity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Creation.Controllers
{
    public class HomeController : _Controller
    {
        [HttpGet]
        public ActionResult Go()
        {
            ServicesModel model = new ServicesModel();
            model.AllServices = Biz.GetServices();
            FillNeeds(model);
            return View(model);
        }

        public ActionResult MoveByNano(string id)
        {
            if (string.IsNullOrEmpty(id))
                return RedirectToAction("Go", "Home");
            else
            {
                // Find nano url for given id and handle that.
                string url = BizNano.GetBigUrl(id);
                if (string.IsNullOrEmpty(url))
                    return View(); // Not found message to user.
                else
                    return Redirect(url);
            }
        }

        [HttpPost]
        public void ExecChat(string msg)
        {
            if (!string.IsNullOrEmpty(msg))
                Biz.AddChat(msg, GetUniqueUserId());
        }

        [HttpGet]
        public PartialViewResult GetChat(string lmId)
        {
            Int64 _lastMsgId = 0;
            long.TryParse(lmId, out _lastMsgId);
            return PartialView("_GbChat", Biz.GetChats(_lastMsgId));
        }

    }
}
