using srShared;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace srEntity
{
    public class _Model
    {
        public _Model()
        {
            _PageTitle = "Welcome!";
            _User = new User();
            _Categories = new List<Category>();
            _Chats = new List<GbChat>();
            _GoogAds = new List<GAd>();
        }
        public byte _RngService { get; set; }
        public string _PageTitle { get; set; }

        public User _User { get; set; }
        public IEnumerable<Category> _Categories { get; set; }
        public IEnumerable<GbChat> _Chats { get; set; }
        public IEnumerable<GAd> _GoogAds { set; get; }

        public class User
        {
            public long Id { get; set; }
            public string Fname { get; set; }
            public string Lname { get; set; }
            public string Email { get; set; }
            public string Img { get; set; }
            public byte UserType { get; set; }
            public string UserTypeName { get; set; }
           
        }
        public class Category
        {
            public long Id { get; set; }
            public string Categ { get; set; }
            public string ParentId { get; set; }
        }
        public class GbChat
        {
            public long Id { get; set; }
            public string Msg { get; set; }
            public string CtdBy { get; set; }
            public DateTime CtdOn { get; set; }
        }
        public class GAd
        {
            public int Id { get; set; }
            public string Code { get; set; }
        }
    }
}