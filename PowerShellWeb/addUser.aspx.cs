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
        public string new_title, new_department, new_department_number;


        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static Hashtable firstF(string new_imie, string new_nazwisko, string new_password)
        {
            return getDate(new_imie, new_nazwisko, new_password);
        }

        [WebMethod]
        public static Hashtable SecondF(string new_title, string new_department, string new_department_number)
        {
            return GetDate2(new_title, new_department, new_department_number);
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

        private static Hashtable GetDate2(string new_title, string new_department, string new_department_number)
        {
            Hashtable ht_out = new Hashtable();
            ht_out.Add("panel2", false);
            ht_out.Add("info", "");
            title = '"' + new_title + '"';
            department = '"' + new_department + '"';
            department_number = '"' + new_department_number + '"';
            Regex rgx = new Regex(@"^[0-9]{3}-[0-9]{2}$");
            if (rgx.IsMatch(new_department_number))
            {
                ht_out["panel2"] = true;
            }
            else
            {
                //MessageBox.Show("Numer MPK jest nieprawidłowy, format prawidłowego numeru xxx-xx");
                ht_out["info"] = "Numer MPK jest nieprawidłowy, format prawidłowego numeru xxx-xx";
            }
            return ht_out;
        }

        private static Hashtable getDate(string new_imie, string new_nazwisko, string new_password)
        {
            Hashtable ht_out = new Hashtable();
            ht_out.Add("panel", false);
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
                    // ReqAtrib.Visible = true;
                    ht_out["panel"] = true;
                    ht_out["info"] = "OK";
                    break;

                case "1":
                    ht_out["info"] = "Takie konto istnieje (imię.nazwisko).";
                    //DialogResult dialogResult = MessageBox.Show("Użytkownik o podanych danych już istnieje, czy chesz go edytować?", "Eekum bokum", MessageBoxButtons.YesNo);
                    //if (dialogResult == DialogResult.Yes)
                    //{
                    //    current_page = 7;
                    //    load_user_data();
                    //    Page_switcher(current_page);
                    //}
                    //else if (dialogResult == DialogResult.No)
                    //{
                    //    //もぐもぐ
                    //}
                    break;

                case "2":
                    ht_out["info"] = "Takie konto istnieje (inicjał.nazwisko).";
                    //DialogResult dialogResult = MessageBox.Show("Użytkownik o podanych danych już istnieje, czy chesz go edytować?", "Eekum bokum", MessageBoxButtons.YesNo);
                    //if (dialogResult == DialogResult.Yes)
                    //{
                    //    current_page = 7;
                    //    load_user_data();
                    //    Page_switcher(current_page);
                    //}
                    //else if (dialogResult == DialogResult.No)
                    //{
                    //    //もぐもぐ
                    //}
                    break;

                case "3":
                    ht_out["info"] = "Takie konto istnieje (imię.nazwisko). Hasło nie spełnia minimalnych wymagań.";
                    break;

                case "4":
                    ht_out["info"] = "Takie konto istnieje (inicjał.nazwisko). Hasło nie spełnia minimlanych wymagań.";
                    break;

                case "5":
                    ht_out["info"] = "Hasło nie spełnia minimalnych wymagań.";
                    break;
            }

            return ht_out;
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            new_imie = new_imie_textbox.Text;
            new_nazwisko = new_nazwisko_textbox.Text;
            new_password = new_password_textbox.Text;
            string imie = '"' + new_imie + '"';
            string nazwisko = '"' + new_nazwisko + '"';
            string password = '"' + new_password + '"';
            string plik = (HttpContext.Current.Request.PhysicalApplicationPath + "\\App_Code\\Skrypty\\new_user_name_check.ps1");
            string script = File.ReadAllText(plik);
            string resultPath = Path.GetDirectoryName(HttpContext.Current.Request.PhysicalApplicationPath + "\\App_Code\\Skrypty");
            string script_edited = script.Replace("$input1", imie).Replace("$input2", nazwisko).Replace("$input3", password).Replace("$input4", resultPath);
            RunScript(script_edited);
            string results = File.ReadAllText(resultPath+"\\result.txt");
            switch (results)
            {
                case "0":
                    ReqAtrib.Visible = true;
                    break;

                case "1":
                    Response.Write("<script language=javascript>alert('Takie konto istnieje (imię.nazwisko).')</script>");
                    //DialogResult dialogResult = MessageBox.Show("Użytkownik o podanych danych już istnieje, czy chesz go edytować?", "Eekum bokum", MessageBoxButtons.YesNo);
                    //if (dialogResult == DialogResult.Yes)
                    //{
                    //    current_page = 7;
                    //    load_user_data();
                    //    Page_switcher(current_page);
                    //}
                    //else if (dialogResult == DialogResult.No)
                    //{
                    //    //もぐもぐ
                    //}
                    break;

                case "2":
                    Response.Write("<script language=javascript>alert('Takie konto istnieje (inicjał.nazwisko).')</script>");
                    //DialogResult dialogResult = MessageBox.Show("Użytkownik o podanych danych już istnieje, czy chesz go edytować?", "Eekum bokum", MessageBoxButtons.YesNo);
                    //if (dialogResult == DialogResult.Yes)
                    //{
                    //    current_page = 7;
                    //    load_user_data();
                    //    Page_switcher(current_page);
                    //}
                    //else if (dialogResult == DialogResult.No)
                    //{
                    //    //もぐもぐ
                    //}
                    break;

                case "3":
                    Response.Write("<script language=javascript>alert('Takie konto istnieje (imię.nazwisko). Hasło nie spełnia minimalnych wymagań.')</script>");
                    break;

                case "4":
                    Response.Write("<script language=javascript>alert('Takie konto istnieje (inicjał.nazwisko). Hasło nie spełnia minimlanych wymagań.')</script>");
                    break;

                case "5":
                    Response.Write("<script language=javascript>alert('Hasło nie spełnia minimalnych wymagań.')</script>");
                    break;
            }

        }
        protected void Button2_Click(object sender, EventArgs e)
        {
            new_title = title_textbox.Text;
            new_department = department_textbox.Text;
            new_department_number = department_number_textbox.Text;
            string title = '"' + new_title + '"';
            string department = '"' + new_department + '"';
            string department_number = '"' + new_department_number + '"';
            Regex rgx = new Regex(@"^[0-9]{3}-[0-9]{2}$");
            if (rgx.IsMatch(department_number))
            {
                optional_atributes_panel.Visible = true;
            }
            else
            {
                //MessageBox.Show("Numer MPK jest nieprawidłowy, format prawidłowego numeru xxx-xx");
                Response.Write("<script language=javascript>alert('Numer MPK jest nieprawidłowy, format prawidłowego numeru xxx-xx')</script>");
            }
        }

        protected void Button3_Click(object sender, EventArgs e)
        {

        }
    }
}