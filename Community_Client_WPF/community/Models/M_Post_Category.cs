using community.Common;
using System;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace community.Models
{
    [DataContract]
    public class M_Post_Category : Notify
    {
        private int id;
        private int? parent_id;
        private string name;
        private string description;
        private DateTime created_at;
        private DateTime updated_at;

        public event ActionHandler<M_Post_Category> SelectEvent;

        private bool isSelected = false;
        private bool isExpanded = true;
        private string image_path = string.Empty;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "parent_id")]
        public int? Parent_Id
        {
            get => this.parent_id;
            set => base.OnPropertyChanged(ref this.parent_id, value);
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
        public DateTime Updated_Dt
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }

        public ObservableCollection<M_Post_Category> SubCategory { get; set; }
            = new ObservableCollection<M_Post_Category>();

        public bool IsSelected
        {
            get => this.isSelected;
            set
            {
                base.OnPropertyChanged(ref this.isSelected, value);
                if (value)
                {
                    BtnCategorySelect();
                }
            }
        }

        public bool IsExpanded
        {
            get => this.isExpanded;
            set => base.OnPropertyChanged(ref this.isExpanded, value);
        }

        public string Image_Path
        {
            get => this.image_path;
            set => base.OnPropertyChanged(ref this.image_path, value);
        }

        private void BtnCategorySelect()
        {
            this.SelectEvent?.Invoke(this);
        }
    }
}
