using community.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.Common
{
    /// <summary>
    /// GlobalData (전역 데이터)
    /// </summary>
    public class GD : Singleton<GD>
    {
        protected GD() { }

        public List<M_Organization_Company> Companies { get; set; } = new List<M_Organization_Company>();
        public List<M_Organization_Department> Departments { get; set; } = new List<M_Organization_Department>();
        public List<M_Organization_Team> Teams { get; set; } = new List<M_Organization_Team>();
        public List<M_Organization_Rank> Ranks { get; set; } = new List<M_Organization_Rank>();
        public List<M_Organization_Position> Positions { get; set; } = new List<M_Organization_Position>();
        public List<M_Organization_Role> Roles { get; set; } = new List<M_Organization_Role>();
        public List<M_Organization_Privilege> Privileges { get; set; } = new List<M_Organization_Privilege>();

        public async Task LoadBaseCode()
        {
            var post            = HTTP_Server.Method.POST;
            var companies       = await HTTP_Server.API.HttpSendAsync<M_Organization_Company[]>("/organization/company/select", post, null);
            var departments     = await HTTP_Server.API.HttpSendAsync<M_Organization_Department[]>("/organization/department/select", post, null);
            var teams           = await HTTP_Server.API.HttpSendAsync<M_Organization_Team[]>("/organization/team/select", post, null);
            var ranks           = await HTTP_Server.API.HttpSendAsync<M_Organization_Rank[]>("/organization/rank/select", post, null);
            var positions       = await HTTP_Server.API.HttpSendAsync<M_Organization_Position[]>("/organization/position/select", post, null);
            var roles           = await HTTP_Server.API.HttpSendAsync<M_Organization_Role[]>("/organization/role/select", post, null);
            var privileges      = await HTTP_Server.API.HttpSendAsync<M_Organization_Privilege[]>("/organization/privileg/select", post, null);

            this.Companies      = new List<M_Organization_Company>(companies);
            this.Departments    = new List<M_Organization_Department>(departments);
            this.Teams          = new List<M_Organization_Team>(teams);
            this.Ranks          = new List<M_Organization_Rank>(ranks);
            this.Positions      = new List<M_Organization_Position>(positions);
            this.Roles          = new List<M_Organization_Role>(roles);
            this.Privileges     = new List<M_Organization_Privilege>(privileges);

            if (companies is null)
            {
                Console.WriteLine("회사 정보 로드 실패");
            }

            if (departments is null)
            {
                Console.WriteLine("부서 정보 로드 실패");
            }

            if (teams is null)
            {
                Console.WriteLine("팀 정보 로드 실패");
            }

            if (ranks is null)
            {
                Console.WriteLine("직급 정보 로드 실패");
            }

            if (positions is null)
            {
                Console.WriteLine("직책 정보 로드 실패");
            }

            if (roles is null)
            {
                Console.WriteLine("담당 정보 로드 실패");
            }

            if (privileges is null)
            {
                Console.WriteLine("권한 정보 로드 실패");
            }
        }

    }
}
