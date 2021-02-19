using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace srBiz
{
    public class NanoUrlBiz : _Biz
    {
        private static NanoUrlBiz biz = null;

        public static NanoUrlBiz Ins()
        {
            if (biz == null) biz = new NanoUrlBiz();
            return biz;
        }

        public string GetBigUrl(string nano)
        {
            return DtNano.FetchBigUrl(nano);
        }
        public string CreateNano(string bigUrl, long userId)
        {
            if (string.IsNullOrEmpty(bigUrl)) // Fail safe.
            {
                return null;
            }
            if (srShared.Aio.IsUrl(ref bigUrl))
                return DtNano.GetNanoUrl(bigUrl, userId);
            return null;
        }
    }
}
