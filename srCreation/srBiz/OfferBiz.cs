using srEntity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using srShared;

namespace srBiz
{
    public class OfferBiz : _Biz
    {
        private static OfferBiz biz = null;

        public static OfferBiz Ins()
        {
            if (biz == null) biz = new OfferBiz();
            return biz;
        }
        public IEnumerable<Offer> GetOffers(long lastOfferId)
        {
            return DtOffer.FetchOffers(lastOfferId).ToList<Offer>();
        }
    }
}
