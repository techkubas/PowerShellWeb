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
       .ReqAtrib{
           display:none;
       }
        .optional_atributes_panel{
            display:none;
        }
    </style>
    <script type="text/javascript">
        function Test() {
            var name = $(".new_imie_textbox").val();
          // alert("Test " + name);
            PageMethods.firstF(name, $(".new_nazwisko_textbox").val(), $(".new_password_textbox").val(), OnOK, null);
        }

        function Check2() {
            var name = $(".title_textbox").val();
            PageMethods.SecondF(name, $(".department_textbox").val(), $(".department_number_textbox").val(), OnOK2, null);
        }

        function OnOK2(result){
            if (result.panel2)
                $('.optional_atributes_panel').show();
            else
                $('.optional_atributes_panel').hide();
        }

        function OnOK(result) {
            if (result.panel)
                $('.ReqAtrib').show();
            else {
                $('.ReqAtrib').hide();
                //alert(result.info);
                //alertify.alert('Info', result.info);
                alertify.confirm("This is a confirm dialog.",
                    function () {
                        alertify.success('Ok');
                    },
                    function () {
                        alertify.error('Cancel');
                    }).set({
                        labels: {
                            ok: "Tak"
                        }
                    });
            }
           

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="True" EnableScriptGlobalization="True"></asp:ScriptManager>
        <div>
            <asp:Label ID="Main_label" runat="server" Text="Wprowadź dane tworzonego użytkownika"></asp:Label>
        </div>
        <asp:Panel ID="Panel1" runat="server">
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
            <%-- <asp:Button ID="Button1" runat="server" Text="Dalej"  OnClick="Button1_Click"/> --%>
            <input id="Button4" type="button" value="Sprawdź" onclick="Test()"/>
        </asp:Panel>
        <asp:Panel ID="ReqAtrib" runat="server" Visible="True" CssClass="ReqAtrib" >
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
            <%-- <asp:Button ID="Button2" runat="server" Text="Dalej" OnClick="Button2_Click"/> --%>
            <input id="Button5" type="button" value="Dalej" onclick="Check2()"/>
        </asp:Panel>
        <asp:Panel ID="optional_atributes_panel" runat="server"  CssClass="optional_atributes_panel">
            <table style="width: 100%;">
                <tr>
                    <td><asp:Label ID="Label7" runat="server" Text="Numer karty"></asp:Label></td>
                    <td><asp:TextBox ID="card_number_textbox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label8" runat="server" Text="Numer pracownika"></asp:Label></td>
                    <td><asp:TextBox ID="worker_number_textbox" runat="server"></asp:TextBox></td>
                </tr>
            </table>
            <asp:Button ID="Button3" runat="server" Text="Dalej" OnClick="Button3_Click"/>
        </asp:Panel>
    </form>
</body>
</html>
