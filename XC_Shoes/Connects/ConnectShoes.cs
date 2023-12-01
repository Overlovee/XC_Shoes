using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using XC_Shoes.Models;
namespace XC_Shoes.Connects
{
    public class ConnectShoes
    {
        DbContext db = new DbContext();
        public List<Models.Shoes> getShoesData(String Gender)
        {
            List<Models.Shoes> listEmployee = new List<Shoes>();
            string sql = "SELECT S.IconID, S.ShoesID,SD.TypeShoesID,SD.Name,S.StyleType,TS.Name,count(CD.ColourID) as 'Number_Colour',S.Price,S.Discount FROM Shoes S,Shoes_Details SD,Type_Shoes TS,Colour_Detail CD WHERE S.ShoesID = SD.ShoesID AND SD.TypeShoesID = TS.TypeShoesID AND S.ShoesID = CD.ShoesID GROUP BY S.IconID, S.ShoesID,SD.TypeShoesID,SD.Name,S.StyleType,TS.Name,S.Price,S.Discount HAVING StyleType = '"+ Gender +"'";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            while (rdr.Read())
            {
                Shoes emp = new Shoes();
                emp.IconID = rdr.GetValue(0).ToString();
                emp.ShoesID = rdr.GetValue(1).ToString();
                emp.TypeShoesID = Convert.ToInt32(rdr.GetValue(2).ToString());
                emp.NameShoes = rdr.GetValue(3).ToString();
                emp.StyleType = rdr.GetValue(4).ToString();
                emp.TypeShoesName = rdr.GetValue(5).ToString();
                emp.NumberColor = Convert.ToInt32(rdr.GetValue(6).ToString());
                emp.Price = float.Parse(rdr.GetValue(7).ToString());
                emp.Discount = float.Parse(rdr.GetValue(8).ToString());
                emp.IconID = rdr.GetValue(0).ToString();
                listEmployee.Add(emp);
            }
            return (listEmployee);
        }
    }
}