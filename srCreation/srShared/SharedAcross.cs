using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace srShared
{
    public static class SharedAcross
    {
        public static class Local
        {
            #region ConfigEntries
            /// <summary>
            /// Connection string to connect Sql Server Database
            /// </summary>
            private static string g_sSqlConString;
            public static string SqlConString
            {
                get
                {
                    return g_sSqlConString;
                }
            }

            private static string g_sMirrorStorage;
            public static string MirrorStorage
            {
                get
                {
                    return g_sMirrorStorage;
                }
            }
            private static string g_sImgExt;
            public static string ImgExt
            {
                get
                {
                    return g_sImgExt;
                }
                set
                {
                    g_sImgExt = value;
                }
            }
            #endregion

            /// <summary>
            /// Loads all the config file constants 
            /// </summary>
            public static void LoadConst()
            {
                g_sSqlConString = ReadConfig("cnn");
                g_sMirrorStorage = ReadConfig("MirrorStorage");
                g_sImgExt = ReadConfig("ImgExt");
            }

            public static string ReadConfig(string key)
            {
                return System.Configuration.ConfigurationManager.AppSettings.Get(key);
            }
        }
        public static class DB
        {
            #region DB Entries

            private static string g_sSiteName = string.Empty;
            public static string SiteName
            {
                get
                {
                    return g_sSiteName;
                }
            }

            private static string g_sSiteUrl = string.Empty;
            public static string SiteUrl
            {
                get
                {
                    return g_sSiteUrl;
                }
            }

            private static string g_sSiteTitle = string.Empty;
            public static string SiteTitle
            {
                get
                {
                    return g_sSiteTitle;
                }
            }

            #endregion

            public static void LoadConst()
            {
                Dictionary<string, string> pairs = new Dictionary<string, string>();

                foreach (var prop in typeof(SharedAcross.DB).GetProperties())
                {
                    if (pairs.Keys.Contains(prop.Name))
                    {
                        prop.SetValue(null, pairs[prop.Name]);
                    }
                }
            }
        }
    }
}
