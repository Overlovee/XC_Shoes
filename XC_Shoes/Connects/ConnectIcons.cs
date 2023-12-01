﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using XC_Shoes.Models;
namespace XC_Shoes.Connects
{
    public class ConnectIcons
    {
        DbContext db = new DbContext();
        public List<Models.Icons> getIconShoesData()
        {
            List<Models.Icons> listEmployee = new List<Models.Icons>();
            string sql = "SELECT * FROM Icons";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            while (rdr.Read())
            {
                Models.Icons emp = new Models.Icons();
                emp.IconID = rdr.GetValue(0).ToString();
                emp.NameIcon = rdr.GetValue(1).ToString();
                emp.Quantity = Convert.ToInt32(rdr.GetValue(2).ToString());

                listEmployee.Add(emp);
            }
            return (listEmployee);
        }
    }
}