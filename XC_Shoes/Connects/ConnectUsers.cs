using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using XC_Shoes.Models;

namespace XC_Shoes.Connects
{
    public class ConnectUsers
    {
        DbContext db = new DbContext();
        public User getUserData(string Email)
        {
            string sql = "SELECT dbo.GetBeforeMailString(u.Email) as  'NameTag', u.UserID,u.UserName,u.Email,u.Password,u.PhoneNumber,u.Image,u.Role from Users u where u.Email = N'" + Email + "'";
            User emp = new User();
            SqlDataReader rdr = db.ExcuteQuery(sql);
            while (rdr.Read())
            {
                emp.NameTag = rdr.GetValue(0).ToString();
                emp.UserID = rdr.GetValue(1).ToString();
                emp.UserName = rdr.GetValue(2).ToString();
                emp.Email = rdr.GetValue(3).ToString();
                emp.Password = rdr.GetValue(4).ToString();
                emp.PhoneNumber = rdr.GetValue(5).ToString();
                //emp.Role = int.Parse(rdr.GetValue(6).ToString());

            }
            rdr.Close();
            return (emp);
        }
        public List<UserShipment> getUserShipmentDetails(string id)
        {
            List<UserShipment> list = new List<UserShipment>();
            string sql = "SELECT * FROM Users_ShipmentDetails WHERE UserID = '" + id + "'";
            
            SqlDataReader rdr = db.ExcuteQuery(sql);
            while (rdr.Read())
            {
                UserShipment emp = new UserShipment();
                emp.UserID = rdr.GetValue(0).ToString();
                emp.UserName = rdr.GetValue(1).ToString();
                emp.PhoneNumber = rdr.GetValue(2).ToString();
                emp.SpecificAddress = rdr.GetValue(3).ToString();
                emp.AdministrativeBoundaries = rdr.GetValue(4).ToString();
                emp.IsDefault = bool.Parse(rdr.GetValue(5).ToString());
                list.Add(emp);
            }
            rdr.Close ();
            return (list);
        }
        //string projectDirectory = System.Web.Hosting.HostingEnvironment.MapPath("~");
        //public List<Shoe> getData(string role = "0", string sort = "ASC", string search = "")
        //{
        //    List<User> list = new List<User>();
        //    string sql = "SELECT S.ShoesID, SD.Name, TS.Name, C.Name, S.Price, S.Discount, I.Url, S.StyleType " +
        //        "FROM Shoes S " +
        //        "join Shoes_Details SD ON S.ShoesID = SD.ShoesID " +
        //        "join Type_Shoes TS ON SD.TypeShoesID = TS.TypeShoesID " +
        //        "join Colour_Detail CD ON S.ShoesID = CD.ShoesID " +
        //        "join Colours C ON CD.ColourID = C.ColourID " +
        //        "join Images I ON S.ShoesID = I.ShoesID AND CD.ColourID = I.ColourID " +
        //        "Where S.StyleType like '" + Gender + "' ";
        //    if (search != "")
        //    {
        //        sql = "SELECT S.ShoesID, SD.Name, TS.Name, C.Name, S.Price, S.Discount, I.Url, S.StyleType " +
        //           "FROM Shoes S " +
        //           "join Shoes_Details SD ON S.ShoesID = SD.ShoesID " +
        //           "join Type_Shoes TS ON SD.TypeShoesID = TS.TypeShoesID " +
        //           "join Colour_Detail CD ON S.ShoesID = CD.ShoesID " +
        //           "join Colours C ON CD.ColourID = C.ColourID " +
        //           "join Images I ON S.ShoesID = I.ShoesID AND CD.ColourID = I.ColourID " +
        //           "Where S.StyleType like '" + Gender + "' " +
        //           "And SD.Name like '%" + search + "%'";
        //    }
        //    if (sort == "DESC")
        //    {
        //        sql += "Order by SD.Name DESC";
        //    }
        //    else
        //    {
        //        sql += "Order by SD.Name ASC";
        //    }

        //    SqlDataReader rdr = db.ExcuteQuery(sql);

        //    while (rdr.Read())
        //    {
        //        User emp = new User();
        //        emp.ShoesID = rdr.GetValue(0).ToString();
        //        emp.NameShoes = rdr.GetValue(1).ToString();
        //        emp.TypeShoesName = rdr.GetValue(2).ToString();
        //        emp.NameColor = rdr.GetValue(3).ToString();
        //        emp.Price = float.Parse(rdr.GetValue(4).ToString());
        //        emp.Discount = float.Parse(rdr.GetValue(5).ToString());

        //        emp.Url = rdr.GetValue(6).ToString();
        //        emp.StyleType = rdr.GetValue(7).ToString();
        //        list.Add(emp);
        //    }
        //    rdr.Close();
        //    return (list);
        //}
    }
}