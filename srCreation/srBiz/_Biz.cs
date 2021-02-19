using srData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using srEntity;
using srShared;

namespace srBiz
{
    public class _Biz
    {
        private static _Biz biz;
        public static _Biz InsBase()
        {
            if (biz == null) biz = new _Biz();
            return biz;
        }
        protected _Data Dt
        {
            get
            {
                return _Data.InsBase();
            }
        }
        protected NanoUrlData DtNano
        {
            get
            {
                return NanoUrlData.Ins();
            }
        }
        protected OfferData DtOffer
        {
            get
            {
                return OfferData.Ins();
            }
        }

        public IEnumerable<_Model.GbChat> GetChats(long lmId = 0)
        {
            return Dt.FetchGlobalChats(lmId).ToList<_Model.GbChat>();
        }

        public IEnumerable<_Model.GAd> GetAds()
        {
            return Dt.FetchAds().ToList<_Model.GAd>();
        }

        public IEnumerable<_Model.Category> GetCategories(byte type, short parentId)
        {
            return Dt.FetchCategories(type, parentId).ToList<_Model.Category>();
        }
        public IEnumerable<Service> GetServices()
        {
            return Dt.FetchServices().ToList<Service>();
        }
        public void AddChat(string msg, long userId)
        {
            Dt.AddChat(msg, userId);
        }
    }
}
