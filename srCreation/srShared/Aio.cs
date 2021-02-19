using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;

namespace srShared
{
    public class Aio
    {
        public static string ReturnImg(byte[] array)
        {
            if (array != null && array.Length > 0)
                return String.Format("data:image/gif;base64,{0}", Convert.ToBase64String(array));
            return string.Empty;
        }

        #region Validation
        public static bool IsImage(string sFileName)
        {
            string[] sImgExt = SharedAcross.Local.ImgExt.Split(',');
            if (sImgExt.Contains(System.IO.Path.GetExtension(sFileName)))
                return true;
            return false;
        }
        public static bool IsUrl(ref string url)
        {
            url = new UriBuilder(url).Uri.AbsoluteUri;
            Uri uriResult;
            return Uri.TryCreate(url, UriKind.Absolute, out uriResult);
        }
       
        #endregion

        #region App Handlers

        public static void ErrHandler(Exception e)
        {
            //do best
        }

        #endregion

        #region Constants

        public const string CustomSeriousErr = "Serious error occured!, Please try after some time!";

        public enum RC
        {
            Error = -1,
            Success = 0,
            Found = 2
        }

        public struct SP
        {
            public const string Fetch_BigUrl = "sr_Fetch_BigUrl"; // Just fetches big url for nano
            public const string Get_NanoUrl = "sr_Get_NanoUrl"; // Generates nano url if not exists in db
            public const string Fetch_GlobalChats = "sr_Fetch_GlobalChats";
            public const string Fetch_GAds = "sr_Fetch_GAds";
            public const string Fetch_Categories = "sr_Fetch_Categories";
            public const string Fetch_Services = "sr_Fetch_Services";
            public const string AddTo_GlobalChats = "sr_AddTo_GlobalChats";
            public const string Fetch_Offers = "sr_Fetch_Offers";
        }
        public struct Splitters
        {
            public const char UserDataSplit = ',';
            public const char UserEntrySplit = ':';

        }
        #endregion

    }
    public static class Extend
    {
        public static List<TSource> ToList<TSource>(this DataTable dataTable) where TSource : new()
        {

            var dataList = new List<TSource>();

            if (dataTable != null && dataTable.Rows.Count > 0)
            {
                const BindingFlags flags = BindingFlags.Public | BindingFlags.Instance | BindingFlags.NonPublic;
                var objFieldNames = (from PropertyInfo aProp in typeof(TSource).GetProperties(flags)
                                     select new
                                     {
                                         Name = aProp.Name,
                                         Type = Nullable.GetUnderlyingType(aProp.PropertyType) ?? aProp.PropertyType
                                     }).ToList();
                var dataTblFieldNames = (from DataColumn aHeader in dataTable.Columns
                                         select new
                                         {
                                             Name = aHeader.ColumnName,
                                             Type = aHeader.DataType
                                         }).ToList();

                var commonFields = objFieldNames.Intersect(dataTblFieldNames).ToList();

                foreach (DataRow dataRow in dataTable.AsEnumerable().ToList())
                {
                    var aTSource = new TSource();
                    foreach (var aField in commonFields)
                    {
                        PropertyInfo propertyInfos = aTSource.GetType().GetProperty(aField.Name);
                        var value = (dataRow[aField.Name] == DBNull.Value) ? null : dataRow[aField.Name]; //if database field is nullable
                        propertyInfos.SetValue(aTSource, value, null);
                    }
                    dataList.Add(aTSource);
                }
            }
            return dataList;
        }
    }

}
