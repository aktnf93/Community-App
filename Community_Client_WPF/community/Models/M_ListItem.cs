using community.Common;

namespace community.Models
{
    public class M_ListItem<T> : Notify where T : M_ListItem<T>
    {
        public event ActionHandler<T> SelectEvent;
        public event ActionHandler<T> EditEvent;
        public event ActionHandler<T> DeleteEvent;

        private void BtnCategorySelect()
        {
            if (this is T)
            {
                this.SelectEvent?.Invoke((T)this);
            }
        }

        private void BtnCategoryEdit()
        {
            if (this is T)
            {
                this.EditEvent?.Invoke((T)this);
            }
        }

        private void BtnCategoryDelete()
        {
            if (this is T)
            {
                this.DeleteEvent?.Invoke((T)this);
            }
        }
    }
}
