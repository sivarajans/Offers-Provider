using srEntity;
using srBiz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using srShared;
using System.Web.Script.Serialization;

namespace Creation.Controllers
{
    public class _Controller : Controller
    {
        public _Biz Biz
        {
            get
            {
                return _Biz.InsBase();
            }
        }
        protected NanoUrlBiz BizNano
        {
            get
            {
                return NanoUrlBiz.Ins();
            }
        }
        protected OfferBiz BizOffer
        {
            get
            {
                return OfferBiz.Ins();
            }
        }


        protected void FillNeeds(_Model model)
        {
            if (model != null)
            {
                model._GoogAds = Biz.GetAds();
                if (model is OfferModel)
                {
                    model._Categories = Biz.GetCategories(0, 0);
                }
                else if (model is PhotoModel)
                {
                    model._Categories = Biz.GetCategories(1, 0);
                }
                model._User = new _Model.User { Fname = "SivaRajan", Email = "admin@site.com", UserTypeName = "Admin" };
            }
        }

        public void SignIn(string email, bool createPersistentCookie)
        {
            if (String.IsNullOrEmpty(email))
                return;

            _Model.User userData = new _Model.User();
            SetAuthCookie(email, createPersistentCookie, userData);
        }

        private void SetAuthCookie(string userName, bool createPersistentCookie, _Model.User userData)
        {
            HttpCookie cookie = FormsAuthentication.GetAuthCookie(userName, createPersistentCookie);
            FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(cookie.Value);
            FormsAuthenticationTicket newTicket = new FormsAuthenticationTicket(
                 ticket.Version, ticket.Name, ticket.IssueDate, ticket.Expiration
                , ticket.IsPersistent, JsSerialize(userData), ticket.CookiePath
            );

            string encTicket = FormsAuthentication.Encrypt(newTicket);
            cookie.Value = encTicket;
            System.Web.HttpContext.Current.Response.Cookies.Add(cookie);
        }
        private _Model.User GetUserCrypto()
        {
            if (User != null && User.Identity != null)
            {
                if (User.Identity is FormsIdentity)
                {
                    FormsIdentity identity = ((FormsIdentity)User.Identity);
                    if (identity.Ticket != null && identity.Ticket.UserData != null)
                    {
                        JavaScriptSerializer jsSer = new JavaScriptSerializer();
                        return (_Model.User)jsSer.Deserialize(identity.Ticket.UserData, typeof(_Model.User));
                    }
                }
            }
            return null;
        }

        private string JsSerialize(object dataToSerialize)
        {
            JavaScriptSerializer jsSer = new JavaScriptSerializer();
            return jsSer.Serialize(dataToSerialize);
        }
        public long GetUniqueUserId()
        {
            _Model.User userData = GetUserCrypto();
            if (userData != null)
            {
                //string idFind = userData.Split(Aio.Splitters.UserDataSplit).Where(x => x.Contains("Id")).First();
                //string id = idFind.Split(Aio.Splitters.UserEntrySplit)[1];
                //if (!string.IsNullOrEmpty(id))
                //    return Convert.ToInt64(id);
                return userData.Id;
            }
            return 2; //Cant find user.. So returning as Guest....
        }
        public bool IsAdmin()
        {
            _Model.User userData = GetUserCrypto();
            if (userData != null && userData.UserType == 1) // 1 is for admin
            {
                return true;
            }
            return false; //Cant find user.. So returning as Guest....
        }
        public bool IsCurrentUser(long chatId)
        {
            if (chatId == GetUniqueUserId())
                return true;
            return false;
        }
        protected override void OnException(ExceptionContext filterContext)
        {
            // Logs exception in table..

            base.OnException(filterContext);
        }
        protected override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            var result = filterContext.Result as ViewResultBase;
            if (result == null)
                return;
            var model = result.Model as _Model;
            if (model == null)
                return;

            FillNeeds(model);

            //base.OnActionExecuted(filterContext);
        }
    }
}