using srShared;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace srData
{
    public class OfferData : _Data
    {
        private static OfferData data = null;
        public static OfferData Ins()
        {
            if (data == null) data = new OfferData();
            return data;
        }
        public DataTable FetchOffers(long lastOfferId)
        {
            CnnIns(); ParamIns();
            _SqlParamList.Add(ReturnParam("LastOfferId", SqlDbType.BigInt, 0, ParameterDirection.Input, false, 0, 0, lastOfferId));
            return _CnnHit.ExecDataSet(_SqlParamList, Aio.SP.Fetch_Offers).Tables[0];
        }
    }
}
