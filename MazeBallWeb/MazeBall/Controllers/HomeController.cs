using System.Web.Mvc;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Configuration;

namespace WynikiWebApp.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult About()
        {
            ViewBag.Message = "Maze Ball 3d - Windows 10, XBOX, Android, iPhone - Concept Game that utilize Microsoft Azure services like Azure Functions, SQL Database, App Service, VM, Applipplication Insights, Traffic Manager.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Privacy Policy";

            return View();
        }
        public ActionResult Privacy()
        {
            ViewBag.Message = "Privacy Policy";

            return View();
        }
        public ActionResult Index()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["defaultConnection"].ConnectionString;
            string sql = "SELECT [id] ,[Nick] ,ISNULL(CAST([Data] as nvarchar(50)), 'Not in Competition - please Play again!!!') as Data ,[Wynik] ,[Czas] FROM [dbo].[wyniki] ORDER BY [Wynik] DESC, [Czas] ASC;";
            List<Result> results = new List<Result>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(sql, conn);

                conn.Open();
                SqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    var wynik = new Result()
                    {
                        Id = GetValue(reader["Id"]),
                        Nick = GetValue(reader["Nick"]),
                        Data = GetValue(reader["Data"]),
                        Wynik = GetValue(reader["Wynik"]),
                        Czas = GetValue(reader["Czas"])
                    };

                    results.Add(wynik);
                }
            }

            return View(results);
        }

        private static string GetValue(object obj)
        {
            if (obj == null) return string.Empty;

            return obj.ToString();
        }

    }

    public class Result
    {
        public string Id { get; set; }
        public string Nick { get; set; }
        public string Data { get; set; }
        public string Wynik { get; set; }
        public string Czas { get; set; }
    }
}
