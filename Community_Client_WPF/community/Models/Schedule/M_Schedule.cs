using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Schedule : Notify
    {
        public event ActionHandler<M_Schedule> SelectEvent;

        private int id;
        private int employee_id;
        private string title;
        private DateTime start_at;
        private DateTime end_at;
        private int color_code;
        private DateTime created_at;
        private DateTime updated_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "employee_id")]
        public int Employee_Id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        [DataMember(Name = "title")]
        public string Title
        {
            get => this.title;
            set => base.OnPropertyChanged(ref this.title, value);
        }

        [DataMember(Name = "start_at")]
        public DateTime Start_At
        {
            get => this.start_at;
            set => base.OnPropertyChanged(ref this.start_at, value);
        }

        [DataMember(Name = "end_at")]
        public DateTime End_At
        {
            get => this.end_at;
            set => base.OnPropertyChanged(ref this.end_at, value);
        }

        [DataMember(Name = "color_code")]
        public int Color_Code
        {
            get => this.color_code;
            set => base.OnPropertyChanged(ref this.color_code, value);
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

        public Dictionary<int, string> Color_CodeList { get; set; } = new Dictionary<int, string>
        {
            { 0, "#AEC6CF" }, // 파스텔 블루
            { 1, "#B5EAD7" }, // 파스텔 그린
            { 2, "#FFFACD" }, // 파스텔 옐로우
            { 3, "#FFD1DC" }, // 파스텔 핑크
            { 4, "#CBAACB" }, // 파스텔 퍼플
            { 5, "#FFDAC1" }, // 파스텔 오렌지
            { 6, "#EE0F7FA" }, // 파스텔 민트
            { 7, "#E6E6FA" }  // 파스텔 라벤더
        };

        public string Color
        {
            get
            {
                if (this.Color_CodeList.TryGetValue(this.Color_Code, out string hex))
                {
                    return hex;
                }
                else
                {
                    return "";
                }
            }
        }

        public string StartEnd
        {
            get
            {
                var start = Start_At.Date;
                var end = End_At.Date;

                if (Start_At.Date != End_At.Date)
                {
                    return $"{start.Month:D2}.{start.Day:D2}~{end.Day:D2}";
                }
                else
                {
                    return $"{start.Month:D2}.{start.Day:D2}";
                }
            }
        }

        private void OnSelect()
        {
            this.SelectEvent?.Invoke(this);
        }
    }
}
