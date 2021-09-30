<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addUser.aspx.cs" Inherits="PowerShellWeb.addUser" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="Scripts/jquery-3.6.0.min.js"></script>
    <script src="Styles/alertify.js"></script>
    <link href="Styles/css/alertify.css" rel="stylesheet" />
    <style type="text/css">

        .SecondPanel{
            display:none;
        }
        .ThirdPanel{
            display:none;
        }
        .FourPanel{
            display:none;
        }
        .FivePanel{
            display:none;
        }

    </style>
    <script type="text/javascript">
        function Check1() {
            var name = $(".new_imie_textbox").val();
            PageMethods.firstF(name, $(".new_nazwisko_textbox").val(), $(".new_password_textbox").val(), OnOK, null);
        }

        function Check2() {
            var name = $(".title_textbox").val();
            PageMethods.secondF(name, $(".department_textbox").val(), $(".department_number_textbox").val(), OnOK2, null);
        }

        function Check3() {
            var name = $(".id_textbox").val();
            PageMethods.thirdF(name, $(".number_textbox").val(), OnOK3, null);
        }

        function Check4() {
            //var name = $(".").val();
            //PageMethods.fourF(name, OnOK4, null);
            $('.FourPanel').hide();
            $('.FivePanel').show();
        }

        function Search() {
            var name = $(".Menedzer_textbox").val();
            PageMethods.fiveF(name, date5OK);
        }

        function Check5() {
        
        }





        function OnOK(result) {
            if (result.panel2)
                $('.SecondPanel').show();
            else {
                $('.SecondPanel').hide();
                alertify.alert('Uwaga', result.info);
            }
        }

        function OnOK2(result){
            if (result.panel3)
                $('.ThirdPanel').show();
            else {
                $('.ThirdPanel').hide();
                alertify.alert('Uwaga', result.info);
            }
        }

        function OnOK3(result) {
            if (result.panel4) {
                $('.FourPanel').hide();
            }
            else {
                $('.FirstPanel').hide();
                $('.SecondPanel').hide();
                $('.ThirdPanel').hide();
                $('.FourPanel').show();
                PageMethods.GetDate4(date4OK);

            }
        }

        function date4OK(result) {
            $('#OuSelect').append(result);
        }

        function changeFuncOu(OuValue) {
            alertify.alert('Wybrane OU: ', OuValue);
            PageMethods.OuSave(OuValue);
        }

        function OnOK4(result) {
            if (result.panel5) {
                $('.FivePanel').hide();
            }
            else {
                $('.FourPanel').hide();
                $('.FivePanel').show();
                //PageMethods.GetDate5(date5OK);
            }
        }

        function date5OK(result) {
            $('#MenedzerSelect').append(result.options);
            $('#i_title').val(result.title);
        }

        function changeFuncMenedzer(MenedzerValue) {
            alertify.alert('Wybrany menedżer: ', MenedzerValue);
            //PageMethods
        }

        function Check10(manager_name) {
            $('#manager_namee').append(manager_name);
            alertify.alert("test menadzera: ", manager_namee);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="True" EnableScriptGlobalization="True"></asp:ScriptManager>
        <div>
        </div>

        <asp:Panel ID="FirstPanel" runat="server" CssClass="FirstPanel">
            <asp:Label ID="Main_label" runat="server" Text="Wprowadź dane tworzonego użytkownika"></asp:Label>
            <table style="width:100%;">
                <tr>
                    <td><asp:Label ID="Label1" runat="server" Text="Imię"></asp:Label></td>
                    <td><asp:TextBox ID="new_imie_textbox" CssClass="new_imie_textbox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label2" runat="server" Text="Nazwisko"></asp:Label></td>
                    <td><asp:TextBox ID="new_nazwisko_textbox" CssClass="new_nazwisko_textbox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label3" runat="server" Text="Hasło"></asp:Label></td>
                    <td><asp:TextBox ID="new_password_textbox" CssClass="new_password_textbox" runat="server" TextMode="Password"></asp:TextBox></td>
                </tr>
            </table>
            <input id="Button1" type="button" value="Sprawdź" onclick="Check1()"/>
        </asp:Panel>

        <asp:Panel ID="SecondPanel" runat="server" Visible="True" CssClass="SecondPanel" >
            <table style="width: 100%;">
                <tr>
                    <td><asp:Label ID="Label4" runat="server" Text="Tytuł"></asp:Label></td>
                    <td><asp:TextBox ID="title_textbox" CssClass="title_textbox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label5" runat="server" Text="Dział"></asp:Label></td>
                    <td><asp:TextBox ID="department_textbox" CssClass="department_textbox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label6" runat="server" Text="Numer MPK"></asp:Label></td>
                    <td><asp:TextBox ID="department_number_textbox" CssClass="department_number_textbox" runat="server"></asp:TextBox></td>
                </tr>
            </table>
            <input id="Button2" type="button" value="Dalej" onclick="Check2()"/>
        </asp:Panel>

        <asp:Panel ID="ThirdPanel" runat="server"  CssClass="ThirdPanel">
            <table style="width: 100%;">
                <tr>
                    <td><asp:Label ID="Label7" runat="server" Text="Numer karty"></asp:Label></td>
                    <td><asp:TextBox ID="id_textbox" runat="server" CssClass="id_textbox"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label8" runat="server" Text="Numer pracownika"></asp:Label></td>
                    <td><asp:TextBox ID="number_textbox" runat="server" CssClass="number_textbox"></asp:TextBox></td>
                </tr>
            </table>
            <input id="Button3" type="button" value="Dalej" onclick="Check3()"/>
        </asp:Panel>

        <asp:Panel ID="FourPanel" runat="server" CssClass="FourPanel">
            <asp:Label ID="Label9" runat="server" Text="Wybierz właściwe OU"></asp:Label><br />
            <select id="OuSelect" style="width:300px;height:300px" size="2"  onclick="changeFuncOu(value)"></select><br />
            <input id="Button4" type="button" value="Dalej" onclick="Check4()"/>
        </asp:Panel>

        <asp:Panel ID="FivePanel" runat="server" CssClass="FivePanel">
            <%--<h1>Ou: <script>window.alert(ou_name);</script></h1>--%>
            <asp:Label ID="Label10" runat="server" Text="Wpisz nazwisko menedżera"></asp:Label><br />
            <asp:TextBox ID="Menedzer_textbox" runat="server" CssClass="Menedzer_textbox"></asp:TextBox>
            <input id="Button5" type="button" value="Szukaj" onclick="Search()"/><br />
            <select id="MenedzerSelect" style="width:300px;height:300px" size="2"  onclick="changeFuncMenedzer(value)" cssclass="MenedzerSelect"></select><br />
            <input id="i_title" type="text" />
            <input id="manager_namee" type="button" value="Check OU" onclick="Check10()"/>
            <input id="Button6" type="button" value="Dalej" onclick="Check5()"/>
        </asp:Panel>

        <%--<asp:Panel ID="FinalPanel" runat="server" CssClass="FinalPanel">
            <asp:Label ID="Label11" runat="server" Text="Wpisz nazwisko menedżera"></asp:Label><br />
            <asp:TextBox ID="TextBox1" runat="server" CssClass="Menedzer_textbox"></asp:TextBox>
            <select id="MenedzerSelectac" style="width:300px;height:300px" size="2"  onclick="changeFuncMenedzer(value)" cssclass="MenedzerSelect"></select><br />
            <input id="Button21" type="button" value="Dalej" onclick="Check6()"/>
        </asp:Panel>--%>
    </form>
</body>
</html>