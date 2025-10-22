using community.Common;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.Models
{
    public class M_TreeItem : Notify
    {
        public event NormalHandler<M_TreeItem> Selected;

        public int Depth { get; set; }
        public ObservableCollection<M_TreeItem> SubTrees { get; set; } = new ObservableCollection<M_TreeItem>();

        public string Name { get; set; }
        public string Icon { get; set; }


        private bool isSelected;
        private bool isExpanded;


        public bool IsSelected
        {
            get => this.isSelected;
            set
            {
                if (SubTrees.Count > 0)
                {
                    value = false;
                    IsExpanded = !IsExpanded;
                }

                base.OnPropertyChanged(ref this.isSelected, value);

                if (this.isSelected)
                {
                    Selected?.Invoke(this);
                }
            }
        }

        public bool IsExpanded
        {
            get => this.isExpanded;
            set
            {
                if (SubTrees.Count == 0)
                {
                    value = false;
                }

                base.OnPropertyChanged(ref this.isExpanded, value);
            }
        }
    }
}
