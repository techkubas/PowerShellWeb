using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation.Runspaces;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows;

namespace PowerShellWeb
{
    public partial class addUser : System.Web.UI.Page
    {
        public static string new_imie, new_nazwisko, new_password, ou_list, ou_fullname, manager_list, title, department, department_number, number, id, manager_name, manager_fullname, ou_name, username, password, ou_number, manager_number;
        public string donor_nazwisko, donor_number, reciver_nazwisko, reciver_number, deleted_index, deleted_surname;
        public static string new_title, new_department, new_department_number, new_number, new_id, ListBoxOu;


        protected void Page_Load(object sender, EventArgs e)
        {

        }
        private static void RunScript(string script)
        {
            Runspace runspace = RunspaceFactory.CreateRunspace();
            runspace.Open();
            Pipeline pipeline = runspace.CreatePipeline();
            pipeline.Commands.AddScript(script);
            pipeline.Invoke();
            runspace.Close();
        }

        [WebMethod]
        public static Hashtable firstF(string new_imie, string new_nazwisko, string new_password)
        {
            return GetDate1(new_imie, new_nazwisko, new_password);
        }

        [WebMethod]
        public static Hashtable secondF(string new_title, string new_department, string new_department_number)
        {
            return GetDate2(new_title, new_department, new_department_number);
        }

        [WebMethod]
        public static Hashtable thirdF(string new_number, string new_id)
        {
            return GetDate3(new_number, new_id);
        }

        [WebMethod]
        public static string fourF()
        {
            return GetDate4();
        }


        private static Hashtable GetDate1(string new_imie, string new_nazwisko, string new_password)
        {
            Hashtable ht_out = new Hashtable();
            ht_out.Add("panel2", false);
            ht_out.Add("info", "");
            string dane_out = "";
            string imie = '"' + new_imie + '"';
            string nazwisko = '"' + new_nazwisko + '"';
            string password = '"' + new_password + '"';
            string plik = (HttpContext.Current.Request.PhysicalApplicationPath + "\\App_Code\\Skrypty\\new_user_name_check.ps1");
            string script = File.ReadAllText(plik);
            string resultPath = Path.GetDirectoryName(HttpContext.Current.Request.PhysicalApplicationPath + "\\App_Code\\Skrypty");
            string script_edited = script.Replace("$input1", imie).Replace("$input2", nazwisko).Replace("$input3", password).Replace("$input4", resultPath);
            RunScript(script_edited);
            string results = File.ReadAllText(resultPath + "\\result.txt");

            switch (results)
            {
                case "0":
                    ht_out["panel2"] = true;
                    ht_out["info"] = "OK";
                    break;

                case "1":
                    ht_out["info"] = "Takie konto istnieje (imię.nazwisko).";
                    break;

                case "2":
                    ht_out["info"] = "Takie konto istnieje (inicjał.nazwisko).";
                    break;

                case "3":
                    ht_out["info"] = "Takie konto istnieje (imię.nazwisko).<br> Hasło nie spełnia minimalnych wymagań.";
                    break;

                case "4":
                    ht_out["info"] = "Takie konto istnieje (inicjał.nazwisko).<br> Hasło nie spełnia minimlanych wymagań.";
                    break;

                case "5":
                    ht_out["info"] = "Hasło nie spełnia minimalnych wymagań.";
                    break;
            }

            return ht_out;
        }

        private static Hashtable GetDate2(string new_title, string new_department, string new_department_number)
        {
            Hashtable ht_out = new Hashtable();
            ht_out.Add("panel3", false);
            ht_out.Add("info", "");
            title = '"' + new_title + '"';
            department = '"' + new_department + '"';
            department_number = '"' + new_department_number + '"';
            Regex rgx = new Regex(@"^[0-9]{3}-[0-9]{2}$");
            if (rgx.IsMatch(new_department_number))
            {
                ht_out["panel3"] = true;
            }
            else
            {
                ht_out["info"] = "Numer MPK jest nieprawidłowy, format prawidłowego numeru xxx-xx";
            }
            return ht_out;
        }
        
        private static Hashtable GetDate3(string new_number, string new_id)
        {
            Hashtable ht_out = new Hashtable();
            ht_out.Add("panel1", false);
            ht_out.Add("panel4", false);
            number = '"' + new_number + '"';
            id = '"' + new_id + '"';
            return ht_out;
        }
        [WebMethod]
        public static string GetDate4()
        {
            //Hashtable ht_out = new Hashtable();
            string plik = (HttpContext.Current.Request.PhysicalApplicationPath + "\\App_Code\\Skrypty\\ou_search.ps1");
            string script = File.ReadAllText(plik);
            string resultPath = Path.GetDirectoryName(HttpContext.Current.Request.PhysicalApplicationPath + "\\App_Code\\Skrypty");
            string edited_script = script.Replace("$input4", resultPath);
            RunScript(edited_script);
            string ou_list = File.ReadAllText(resultPath + "\\result2.txt");
            StringReader strReader = new StringReader(ou_list);
            int i = 0;
            string result = "";
            while (true)
            {
                string temp = strReader.ReadLine();
                if (temp != null)
                {
                    result += $"<option text='{temp.Trim()}' value='{i}'>{temp.Trim()}</option>";
                }
                else { break; }
            }
            File.Delete("result2.txt");
            return result;
        }
    }
}