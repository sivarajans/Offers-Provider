using srCnn;
using srShared;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Data;

namespace srData
{
    public class _Data
    {
        public Connector _CnnHit = null;
        public List<SqlParameter> _SqlParamList = null;

        private static _Data Data = null;
        public static _Data InsBase()
        {
            if (Data == null) Data = new NanoUrlData();
            return Data;
        }

        public void CnnIns()
        {
            _CnnHit = new Connector();
        }
        public void ParamIns()
        {
            _SqlParamList = new List<SqlParameter>();
        }
        public SqlParameter ReturnParam(string name, SqlDbType type, int size, ParameterDirection dir, bool isNull, byte prec, byte scale, object value)
        {
            return new SqlParameter(name, type, size, dir, isNull, prec, scale, string.Empty, DataRowVersion.Current, value);
        }

        public DataTable FetchGlobalChats(long lmId)
        {
            CnnIns(); ParamIns();
            _SqlParamList.Add(ReturnParam("LmId", SqlDbType.BigInt, 0, ParameterDirection.Input, false, 0, 0, lmId));

            return _CnnHit.ExecDataSet(_SqlParamList, Aio.SP.Fetch_GlobalChats).Tables[0];
        }

        public DataTable FetchAds()
        {
            CnnIns(); ParamIns();
            return _CnnHit.ExecDataSet(_SqlParamList, Aio.SP.Fetch_GAds).Tables[0];
        }

        public DataTable FetchCategories(byte type, short parentId)
        {
            CnnIns(); ParamIns();
            _SqlParamList.Add(ReturnParam("Type", SqlDbType.TinyInt, 0, ParameterDirection.Input, false, 0, 0, type));
            _SqlParamList.Add(ReturnParam("ParentId", SqlDbType.SmallInt, 0, ParameterDirection.Input, false, 0, 0, parentId));
            return _CnnHit.ExecDataSet(_SqlParamList, Aio.SP.Fetch_Categories).Tables[0];
        }

        public DataTable FetchServices()
        {
            CnnIns(); ParamIns();
            return _CnnHit.ExecDataSet(_SqlParamList, Aio.SP.Fetch_Services).Tables[0];
        }

        public void AddChat(string msg, long userId)
        {
            CnnIns(); ParamIns();
            _SqlParamList.Add(ReturnParam("Msg", SqlDbType.VarChar, -1, ParameterDirection.Input, false, 0, 0, msg));
            _SqlParamList.Add(ReturnParam("CtdBy", SqlDbType.BigInt, 0, ParameterDirection.Input, false, 0, 0, userId));
            _CnnHit.Exec(_SqlParamList, Aio.SP.AddTo_GlobalChats);
        }
    }
}
