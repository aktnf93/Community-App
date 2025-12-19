using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_ApprovalDetail
    {
        public ObservableCollection<M_Approval_Line> CurrentApprovalLines { get; set; } = new ObservableCollection<M_Approval_Line>();
        public M_Approval CurrentApproval { get; set; } = new M_Approval();

        public VM_ApprovalDetail()
        {
            
        }
    }
}
