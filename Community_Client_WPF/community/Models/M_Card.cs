using community.Common;

namespace community.Models
{
    public class M_Card : Notify
    {
        private string title;
        private string content;
        private string description;

        public string Title
        {
            get => this.title;
            set => base.OnPropertyChanged(ref this.title, value);
        }

        public string Content
        {
            get => this.content;
            set => base.OnPropertyChanged(ref this.content, value);
        }

        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }
    }
}
