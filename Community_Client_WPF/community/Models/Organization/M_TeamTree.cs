using community.Common;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace community.Models
{
    [DataContract]
    public class M_TeamTree : Notify
    {
        public event ActionHandler<M_TeamTree> OnSelected;

        private int id;
        private int origin_id;
        private int depth;
        private string name;
        private string description;
        private DateTime created_at;
        private DateTime updated_at;
        private int? parent_id;

        public ObservableCollection<M_TeamTree> SubTree { get; set; }
            = new ObservableCollection<M_TeamTree>();

        private bool isSelected;
        public bool IsSelected
        {
            get => this.isSelected;
            set
            {
                this.isSelected = value;
                OnSelected?.Invoke(this);
                base.OnPropertyChanged(nameof(IsSelected));
            }
        }


        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "origin_id")]
        public int Origin_Id
        {
            get => this.origin_id;
            set => base.OnPropertyChanged(ref this.origin_id, value);
        }

        [DataMember(Name = "depth")]
        public int Depth
        {
            get => this.depth;
            set => base.OnPropertyChanged(ref this.depth, value);
        }

        [DataMember(Name = "name")]
        public string Name
        {
            get => this.name;
            set => base.OnPropertyChanged(ref this.name, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "updated_at")]
        public DateTime Updated_At
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }

        [DataMember(Name = "parent_id")]
        public int? Parent_Id
        {
            get => this.parent_id;
            set => base.OnPropertyChanged(ref this.parent_id, value);
        }
    }
}
