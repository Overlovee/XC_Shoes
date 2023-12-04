﻿using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using XC_Shoes.Models;

namespace XC_Shoes.Connects
{
    public class ConnectPurchased
    {
        DbContext db = new DbContext();
        //string projectDirectory = System.Web.Hosting.HostingEnvironment.MapPath("~");
        public List<Purchased> getData(string sort = "DESC")
        {
            List<Purchased> list = new List<Purchased>();
            string sql = "SELECT " +
                "S.ShoesID, " +
                "SD.Name, " +
                "C.Name, " +
                "S.StyleType, " +
                "SUM(OD.Quantity) AS Purchased, " +
                "S.Price, " +
                "S.Price * SUM(OD.Quantity) AS Total, " +
                "I.Url " +
                "FROM " +
                "Shoes S " +
                "JOIN Shoes_Details SD ON S.ShoesID = SD.ShoesID " +
                "JOIN Colour_Detail CD ON S.ShoesID = CD.ShoesID " +
                "JOIN Colours C ON CD.ColourID = C.ColourID " +
                "LEFT JOIN Order_Detail OD ON S.ShoesID = OD.ShoesID AND C.ColourID = OD.ColourID AND S.StyleType = OD.StyleType " +
                "Join Images I ON S.ShoesID = I.ShoesID AND C.ColourID = I.ColourID " +
                "Join OrderSystem OS ON OD.OrderID = OS.OrderID " +
                "Where OS.Status Like N'Done' " +
                "GROUP BY S.ShoesID, SD.Name, C.Name, S.StyleType, S.Price, OD.Quantity, I.Url " +
                "Order by Purchased DESC, S.ShoesID ASC";

            if(sort == "ASC")
            {
                sql = "SELECT " +
                "S.ShoesID, " +
                "SD.Name, " +
                "C.Name, " +
                "S.StyleType, " +
                "SUM(OD.Quantity) AS Purchased, " +
                "S.Price, " +
                "S.Price * SUM(OD.Quantity) AS Total, " +
                "I.Url " +
                "FROM " +
                "Shoes S " +
                "JOIN Shoes_Details SD ON S.ShoesID = SD.ShoesID " +
                "JOIN Colour_Detail CD ON S.ShoesID = CD.ShoesID " +
                "JOIN Colours C ON CD.ColourID = C.ColourID " +
                "LEFT JOIN Order_Detail OD ON S.ShoesID = OD.ShoesID AND C.ColourID = OD.ColourID AND S.StyleType = OD.StyleType " +
                "Join Images I ON S.ShoesID = I.ShoesID AND C.ColourID = I.ColourID " +
                "Join OrderSystem OS ON OD.OrderID = OS.OrderID " +
                "Where OS.Status Like N'Done' " +
                "GROUP BY S.ShoesID, SD.Name, C.Name, S.StyleType, S.Price, OD.Quantity, I.Url " +
                "Order by Purchased ASC, S.ShoesID ASC";
            }
            SqlDataReader rdr = db.ExcuteQuery(sql);

            while (rdr.Read())
            {
                Purchased emp = new Purchased();
                emp.ShoesID = rdr.GetValue(0).ToString();
                emp.ShoesName = rdr.GetValue(1).ToString();
                emp.ColorName = rdr.GetValue(2).ToString();
                emp.StyleType = rdr.GetValue(3).ToString();
                emp.PurchasedQuantity = int.Parse(rdr.GetValue(4).ToString());
                emp.Price = decimal.Parse(rdr.GetValue(5).ToString());
                emp.Total = decimal.Parse(rdr.GetValue(6).ToString());
                emp.Url = rdr.GetValue(7).ToString();
                list.Add(emp);
            }
            rdr.Close();
            return (list);
        }
        public decimal getTotalIncome()
        {
            string sql = "SELECT SUM(Price*Quantity) " +
                "FROM Order_Detail OD " +
                "Join OrderSystem OS ON OD.OrderID = OS.OrderID " +
                "Where OS.Status Like N'Done'";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            decimal emp = 0;
            if (rdr.Read())
            {
                emp = decimal.Parse(rdr.GetValue(0).ToString());
            }
            rdr.Close();
            return (emp);
        }
        public decimal getThisMonthIncome()
        {
            string sql = "SELECT SUM(Price*Quantity) " +
                "FROM Order_Detail OD " +
                "Join OrderSystem OS ON OD.OrderID = OS.OrderID " +
                "Where OS.Status Like N'Done' " +
                "And MONTH(OS.OrderDate) = Month(GETDATE())";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            decimal emp = 0;
            if (rdr.Read())
            {
                emp = decimal.Parse(rdr.GetValue(0).ToString());
            }
            rdr.Close();
            return (emp);
        }
        public int getTotalOrder()
        {
            string sql = "SELECT Count(OrderID) " +
                "FROM OrderSystem OS " +
                "Where OS.Status Not Like N'Canceled' ";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            int emp = 0;
            if (rdr.Read())
            {
                emp = int.Parse(rdr.GetValue(0).ToString());
            }
            rdr.Close();
            return (emp);
        }
        public int getTotalOrderByMonth(int month = 12)
        {
            string sql = "SELECT Count(OrderID) " +
                "FROM OrderSystem OS " +
                "Where OS.Status Not Like N'Canceled' " +
                "And Month(OS.OrderDate) = '"+month+"'";
            SqlDataReader rdr = db.ExcuteQuery(sql);
            int emp = 0;
            if (rdr.Read())
            {
                emp = int.Parse(rdr.GetValue(0).ToString());
            }
            rdr.Close();
            return (emp);
        }
    }
}