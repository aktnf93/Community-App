using System;

namespace community.Models
{
    public class M_Employee
    {
        /// <summary>
        /// 사원 번호
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// 사원 이름
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// 부서
        /// </summary>
        public string Department { get; set; }

        /// <summary>
        /// 담당 직책
        /// </summary>
        public string Position { get; set; }

        /// <summary>
        /// 상태
        /// </summary>
        public int Status { get; set; }

        /// <summary>
        /// 입사일
        /// </summary>
        public DateTime HireDate { get; set; }

        /// <summary>
        /// 이메일
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// 연락처
        /// </summary>
        public string Phone { get; set; }
        
        /// <summary>
        /// 급여
        /// </summary>
        public decimal Salary { get; set; }

        /// <summary>
        /// 이미지
        /// </summary>
        public string Icon { get; set; }
    }
}
