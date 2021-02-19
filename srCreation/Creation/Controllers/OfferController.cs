using srBiz;
using srEntity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Creation.Controllers
{
    public class OfferController : _Controller
    {

        public ActionResult Go(string Id)
        {
            OfferModel model = new OfferModel();
            model.AllOffers = BizOffer.GetOffers(Convert.ToInt64(Id));
            return View(model);
        }

        public ActionResult Create()
        {
            OfferModel model = new OfferModel();
            List<Offer> off = new List<Offer>();
            off.Add(new Offer());
            model.AllOffers = off;
            return View("CreateOffer", model);
        }
    }
}
