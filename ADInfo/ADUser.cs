using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ADInfo
{
    public class ADUser
    {
        public string FIO { get; set; }
        public string Account { get; set; }
        public string Title { get; set; }
        public string Department { get; set; }
        public string Organization { get; set; }
        public string PhoneNumber { get; set; }
        public string Mobilephone { get; set; }
        public string Mail { get; set; }
        public string Room { get; set; }
        public string City { get; set; }
        public string ID { get; set; }
        public string CSUPDCreated { get; set; }
        public string Enabled { get; set; }
        public string Path { get; set; }
        public string Created { get; set; }
        public string WarnQuota { get; set; }
        public string SendQuota { get; set; }
        public string ReceiveQuota { get; set; }
        public string LastlogonHostname { get; set; }
        public string LastlogonDate { get; set; }
        public string AccountExpires { get; set; }
        public string PasswordChanged { get; set; }
        public string PasswordExpires { get; set; }
        public string AccountLocked { get; set; }
        public string ATSIP { get; set; }
        public string ATSNumber { get; set; }
    }
}