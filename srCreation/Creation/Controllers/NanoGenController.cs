using srEntity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Creation.Controllers
{
    public class NanoGenController : _Controller
    {
        public ActionResult Go()
        {
            NanoModel model = new NanoModel();
            model.NanoUrl = BizNano.CreateNano(model.BigUrl, GetUniqueUserId());
            if (!string.IsNullOrEmpty(model.NanoUrl))
                model.IsNanoAvail = true;
            return View(model);
        }
        public ActionResult Migrate(string id)
        {
            if (String.IsNullOrEmpty(id))
                return RedirectToAction("Go");
            else
            {
                var bigUrl = BizNano.GetBigUrl(id);
                if (string.IsNullOrEmpty(bigUrl))
                    return RedirectToAction("Go");
                else
                    return Content(string.Format("<script language='javascript' type='text/javascript'>location.href='{0}';</script>", bigUrl));
            }
        }
        public ViewResult GenerateNano(NanoModel model)
        {
            if (!string.IsNullOrEmpty(model.BigUrl) && model.BigUrl.Contains('.'))
            {
                model.Nano = BizNano.CreateNano(model.BigUrl, GetUniqueUserId());
                model.NanoUrl = string.Format("{0}/{1}", Uri.UriSchemeHttp + Uri.SchemeDelimiter + "localhost/Creation", model.Nano);
                model.IsNanoAvail = true;
            }
            return View("Go", model);
        }
    }
}
