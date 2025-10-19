using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.Models
{
    public class M_Card
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Icon { get; set; }
        public string Color { get; set; }





        public int Id { get; set; }
        public DateTime DueDate { get; set; }
        public string Status { get; set; }
        public int AssignedToId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public int Priority { get; set; }
    }
}
