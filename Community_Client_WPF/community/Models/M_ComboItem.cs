using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.Models
{
    public class M_ComboItem<T>
    {
        public string Display { get; set; }
        
        public T Value { get; set; }

        public M_ComboItem()
        {
            
        }

        public M_ComboItem(string display, T value)
        {
            Display = display;
            Value = value;
        }
        
        public override string ToString()
        {
            return Display;
        }
    }
}
