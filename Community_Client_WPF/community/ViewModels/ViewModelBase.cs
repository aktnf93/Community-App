using community.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class ViewModelBase : Notify
    {
        /// <summary>
        /// 메뉴 화면 타입
        /// </summary>
        public enum MenuType
        {
            Login,      // 로그인
            Post,       // 게시글
            Chat,       // 채팅방
            Project,    // 프로젝트 관리
            Customer,   // 고객 관리
            Product,    // 제품 관리
            Employee,   // 직원 관리
            System      // 시스템
        }
    }
}
