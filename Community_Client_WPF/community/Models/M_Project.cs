using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.Models
{
    public class M_Project
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Status { get; set; }
        public int OwnerId { get; set; }
        public string OwnerName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public int Progress { get; set; }

        private void CalculateProgress()
        {
            // Example logic to calculate progress
            var totalDuration = (EndDate - StartDate).TotalDays;
            var elapsedDuration = (DateTime.Now - StartDate).TotalDays;
            Progress = (int)((elapsedDuration / totalDuration) * 100);
            if (Progress < 0) Progress = 0;
            if (Progress > 100) Progress = 100;
        }

        private void UpdateStatus()
        {
            if (DateTime.Now < StartDate)
            {
                Status = "Not Started";
            }
            else if (DateTime.Now >= StartDate && DateTime.Now <= EndDate)
            {
                Status = "In Progress";
            }
            else
            {
                Status = "Completed";
            }
        }

        private void UpdateTimestamps()
        {
            UpdatedAt = DateTime.Now;
            if (CreatedAt == default(DateTime))
            {
                CreatedAt = DateTime.Now;
            }
        }

        private void ValidateDates()
        {
            if (EndDate < StartDate)
            {
                throw new ArgumentException("EndDate cannot be earlier than StartDate");
            }
        }

        private void OnPropertyChanged()
        {
            ValidateDates();
            UpdateStatus();
            CalculateProgress();
            UpdateTimestamps();
        }

        private void BtnView_Click()
        {
            MessageBox.Show($"Project Details:\n\nName: {Name}\nDescription: {Description}\nStart Date: {StartDate.ToShortDateString()}\nEnd Date: {EndDate.ToShortDateString()}\nStatus: {Status}\nProgress: {Progress}%");
        }

        private void BtnEdit_Click()
        {
            MessageBox.Show("Edit functionality is not implemented yet.");
        }

        private void BtnDelete_Click()
        {
            var result = MessageBox.Show("Are you sure you want to delete this project?", "Confirm Delete", MessageBoxButton.YesNo);
            if (result == MessageBoxResult.Yes)
            {
                MessageBox.Show("Delete functionality is not implemented yet.");
            }
        }
    }
}
