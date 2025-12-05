using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace community.View_Converters
{
    public class Converter_Visibility_Bool : IValueConverter
    {
        // ViewModel → View
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool)
            {
                return (bool)value ? Visibility.Visible : Visibility.Collapsed; 
            }

            return Binding.DoNothing;
        }

        // View → ViewModel
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is Visibility)
            {
                return (Visibility)value == Visibility.Visible ? true : false;
            }

            return Binding.DoNothing;
        }
    }
}
