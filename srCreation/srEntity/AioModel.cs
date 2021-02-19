using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace srEntity
{
    // Models for the View
    #region Models
    public class NanoModel : _Model
    {
        public bool IsNanoAvail { get; set; }
        public string BigUrl { get; set; }
        public string NanoUrl { get; set; }
        public string Nano { get; set; }
    }
    public class ServicesModel : _Model
    {
        public IEnumerable<Service> AllServices { get; set; }
    }
    public class OfferModel : _Model
    {
        public IEnumerable<Offer> AllOffers { get; set; }
    }
    public class PhotoModel : _Model
    {
        public List<Photos> AllPhotos { get; set; }
    }
    #endregion

    #region Model Supporters
    public class Service
    {
        public byte Id { get; set; }
        public string Name { get; set; }
        public string Descn { get; set; }
        public string RouteName { get; set; }
        public byte[] Img { get; set; }
    }
    public class Offer
    {
        public long Id { get; set; }
        public short CatId { get; set; }
        public short CatName { get; set; }
        public string Title { get; set; }
        public string Descn { get; set; }
        public DateTime offFrom { get; set; }
        public DateTime offEnd { get; set; }
        public long Likes { get; set; }
        public long DisLikes { get; set; }
        public string ModBy { get; set; }
        public DateTime ModOn { get; set; }
        public IEnumerable<Comment> Cmnts { get; set; }
    }
    public class Photos
    {
        public long Id { get; set; }
        public short CatId { get; set; }
        public string Name { get; set; }
        public string NanoImg { get; set; }
        public string KiloImg { get; set; }
        public string OrgImg { get; set; }
        public long Likes { get; set; }
        public long DisLikes { get; set; }
        public string CtdBy { get; set; }
        public DateTime CtdOn { get; set; }
        public IEnumerable<Comment> Cmnts { get; set; }
    }
    public class Comment
    {
        public long Id { get; set; }
        public long AgainstId { get; set; }
        public string Cmnt { get; set; }
        public string CtdBy { get; set; }
        public DateTime CtdOn { get; set; }
    }
    #endregion
}