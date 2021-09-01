using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Management.Automation;
using System.Text;

namespace ADInfo
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class ADUsersGetAdvanced : System.Web.Services.WebService
    {
        [WebMethod]
        public void GetADUsers()
        {

            var adusers = new List<ADUser>();

            // Initialize PowerShell engine
            var powershell = PowerShell.Create();

            // Add the script to the PowerShell object
            var script = Server.MapPath(".") + "\\Scripts\\ADUsersGetAdvanced.ps1";
            powershell.Commands.AddCommand(script, false);
            powershell.AddParameter("string", "*");
            // Execute the script
            var results = powershell.Invoke();

            foreach (var result in results )
            {
                var adu = new ADUser
                {
                    FIO = (result.Properties["FIO"].Value ?? "").ToString(),
                    Account = (result.Properties["Account"].Value ?? "").ToString(),
                    Title = (result.Properties["Title"].Value ?? "").ToString(),
                    Department = (result.Properties["Department"].Value ?? "").ToString(),
                    Organization = (result.Properties["Organization"].Value ?? "").ToString(),
                    PhoneNumber = (result.Properties["PhoneNumber"].Value ?? "").ToString(),
                    Mobilephone=(result.Properties["Mobilephone"].Value ?? "").ToString(),
                    Mail = (result.Properties["Mail"].Value ?? "").ToString(),
                    Room = (result.Properties["Room"].Value ?? "").ToString(),
                    City = (result.Properties["City"].Value ?? "").ToString(),
                    ID = (result.Properties["ID"].Value ?? "").ToString(),
                    CSUPDCreated = (result.Properties["CSUPDCreated"].Value ?? "").ToString(),
                    Enabled = (result.Properties["Enabled"].Value ?? "").ToString(),
                    Path = (result.Properties["Path"].Value ?? "").ToString(),
                    Created = (result.Properties["Created"].Value ?? "").ToString(),
                    WarnQuota = (result.Properties["WarnQuota"].Value ?? "").ToString(),
                    SendQuota = (result.Properties["SendQuota"].Value ?? "").ToString(),
                    ReceiveQuota = (result.Properties["ReceiveQuota"].Value ?? "").ToString(),
                    LastlogonHostname = (result.Properties["LastlogonHostname"].Value ?? "").ToString(),
                    LastlogonDate = (result.Properties["LastlogonDate"].Value ?? "").ToString(),
                    AccountExpires = (result.Properties["AccountExpires"].Value ?? "").ToString(),
                    PasswordChanged = (result.Properties["PasswordChanged"].Value ?? "").ToString(),
                    PasswordExpires = (result.Properties["PasswordExpires"].Value ?? "").ToString(),
                    AccountLocked = (result.Properties["AccountLocked"].Value ?? "").ToString(),
                    ATSIP = (result.Properties["ATSIP"].Value ?? "").ToString(),
                    ATSNumber = (result.Properties["ATSNumber"].Value ?? "").ToString()
                };
                adusers.Add(adu);
            }
            
            var js = new JavaScriptSerializer();
            Context.Response.Write(js.Serialize(adusers));
        }
    }
}
