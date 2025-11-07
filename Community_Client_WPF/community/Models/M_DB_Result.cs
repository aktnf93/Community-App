using System.Runtime.Serialization;

namespace community.Models
{
    [DataContract]
    public class M_DB_Result
    {
        [DataMember(Name = "fieldCount")]
        public int? FieldCount { get; set; }

        [DataMember(Name = "affectedRows")]
        public int? AffectedRows { get; set; }

        [DataMember(Name = "insertId")]
        public int? InsertId { get; set; }

        [DataMember(Name = "info")]
        public string Info { get; set; }

        [DataMember(Name = "serverStatus")]
        public int? ServerStatus { get; set; }

        [DataMember(Name = "warningStatus")]
        public int? WarningStatus { get; set; }

        [DataMember(Name = "changedRows")]
        public int? ChangedRows { get; set; }
    }
}
