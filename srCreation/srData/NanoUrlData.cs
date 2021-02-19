using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using srShared;
using System.Data;

namespace srData
{
    public class NanoUrlData : _Data
    {
        private static NanoUrlData NanoData = null;
        public static NanoUrlData Ins()
        {
            if (NanoData == null) NanoData = new NanoUrlData();
            return NanoData;
        }
        public string FetchBigUrl(string nano)
        {
            CnnIns(); ParamIns();
            _SqlParamList.Add(ReturnParam("Nano", SqlDbType.VarChar, 64, ParameterDirection.Input, false, 0, 0, nano));
            return _CnnHit.ExecScalar(_SqlParamList, Aio.SP.Fetch_BigUrl);
        }
        public string GetNanoUrl(string bigUrl, long userId)
        {
            CnnIns(); ParamIns();
            _SqlParamList.Add(ReturnParam("BigUrl", SqlDbType.VarChar, -1, ParameterDirection.Input, false, 0, 0, bigUrl));
            _SqlParamList.Add(ReturnParam("CtdBy", SqlDbType.BigInt, 0, ParameterDirection.Input, false, 0, 0, userId));
            return _CnnHit.ExecScalar(_SqlParamList, Aio.SP.Get_NanoUrl);
        }
    }
}
