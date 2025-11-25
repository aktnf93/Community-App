using System;
using System.Runtime.Serialization;
using System.Windows.Media;

namespace community.Models
{
    [DataContract]
    public class M_HomePorts
    {
        [DataMember(Name = "type_color")]
        public SolidColorBrush Type_Color { get; set; }

        [DataMember(Name = "category")]
        public string Category { get; set; }

        [DataMember(Name = "title")]
        public string Title { get; set; }

        [DataMember(Name = "created_at")]
        public DateTime? Created_At { get; set; }
    }
}
