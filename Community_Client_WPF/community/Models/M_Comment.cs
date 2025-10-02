using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace community.Models
{
    [DataContract]
    public class M_Comment
    {
        [DataMember(Name = "id")]
        public int Id { get; set; }

        [DataMember(Name = "user_id")]
        public int User_Id { get; set; }

        [DataMember(Name = "nickname")]
        public string Nickname { get; set; }

        [DataMember(Name = "content")]
        public string Content { get; set; }

        [DataMember(Name = "create_dt")]
        public DateTime Created_Dt { get; set; }

        [DataMember(Name = "update_dt")]
        public DateTime Updated_Dt { get; set; }
    }
}
