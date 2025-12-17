using community.ViewModels;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Windows.Data;

namespace community.View_Converters
{
    public class Converter_DateToSchedules : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            var schedules = values[0] as IEnumerable<DaySchedule>;
            var date = values[1] as DateTime?;

            if (schedules == null || date == null)
                return Enumerable.Empty<ScheduleItem>();

            var day = schedules.FirstOrDefault(s => s.Date.Date == date.Value.Date);
            return day?.Items ?? Enumerable.Empty<ScheduleItem>();
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
