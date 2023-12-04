﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using XC_Shoes.Models;
namespace XC_Shoes.Connects
{
    public class ConnectBag
    {
        DbContext db = new DbContext();
        public List<Bag> getBagData(string userID)
        {
            List<Bag> listEmployee = new List<Bag>();
            string sql = "SELECT * FROM dbo.GetBag('" + userID + "')";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            while (rdr.Read())
            {
                Bag emp = new Bag();
                emp.ShoesID = rdr.GetValue(0).ToString();
                emp.ShoesName = rdr.GetValue(1).ToString();
                emp.StyleType = rdr.GetValue(2).ToString();
                emp.TypeName = rdr.GetValue(3).ToString();
                emp.ColorName = rdr.GetValue(4).ToString();
                emp.Size = int.Parse(rdr.GetValue(5).ToString());
                emp.Quantity = int.Parse(rdr.GetValue(6).ToString());
                emp.Price = float.Parse(rdr.GetValue(7).ToString());
                emp.BuyingSelectionStatus = bool.Parse(rdr.GetValue(8).ToString());
                emp.Url = rdr.GetValue(9).ToString();
                listEmployee.Add(emp);
            }
            rdr.Close();
            return (listEmployee);
        }
    }
}