using System;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using Newtonsoft.Json;

namespace community.Common
{
    public static class Server_Data_Convert
    {
        // // Json ���ڿ��� ��ü�� ��ȯ
        // public static T FromJson<T>(string json)
        // {
        //     if (string.IsNullOrWhiteSpace(json))
        //         throw new ArgumentException("json ���ڿ��� ��� �ֽ��ϴ�.", nameof(json));
        // 
        //     var serializer = new DataContractJsonSerializer(typeof(T));
        //     using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(json)))
        //     {
        //         return (T)serializer.ReadObject(ms);
        //     }
        // }
        // 
        // // ��ü�� Json ���ڿ��� ��ȯ
        // public static string ToJson(object obj)
        // {
        //     if (obj == null)
        //         throw new ArgumentNullException(nameof(obj));
        // 
        //     var serializer = new DataContractJsonSerializer(obj.GetType());
        //     using (var ms = new MemoryStream())
        //     {
        //         serializer.WriteObject(ms, obj);
        //         return Encoding.UTF8.GetString(ms.ToArray());
        //     }
        // }

        // Json ���ڿ��� ��ü�� ��ȯ (Newtonsoft.Json ���)
        public static T FromJson<T>(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                throw new ArgumentException("json ���ڿ��� ��� �ֽ��ϴ�.", nameof(json));
        
            return JsonConvert.DeserializeObject<T>(json);
        }
        
        // ��ü�� Json ���ڿ��� ��ȯ (Newtonsoft.Json ���)
        public static string ToJson(object obj)
        {
            if (obj == null)
                throw new ArgumentNullException(nameof(obj));
        
            return JsonConvert.SerializeObject(obj);
        }
    }
}