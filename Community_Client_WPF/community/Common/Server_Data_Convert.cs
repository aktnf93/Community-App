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
        // // Json 문자열을 객체로 변환
        // public static T FromJson<T>(string json)
        // {
        //     if (string.IsNullOrWhiteSpace(json))
        //         throw new ArgumentException("json 문자열이 비어 있습니다.", nameof(json));
        // 
        //     var serializer = new DataContractJsonSerializer(typeof(T));
        //     using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(json)))
        //     {
        //         return (T)serializer.ReadObject(ms);
        //     }
        // }
        // 
        // // 객체를 Json 문자열로 변환
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

        // Json 문자열을 객체로 변환 (Newtonsoft.Json 사용)
        public static T FromJson<T>(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                throw new ArgumentException("json 문자열이 비어 있습니다.", nameof(json));
        
            return JsonConvert.DeserializeObject<T>(json);
        }
        
        // 객체를 Json 문자열로 변환 (Newtonsoft.Json 사용)
        public static string ToJson(object obj)
        {
            if (obj == null)
                throw new ArgumentNullException(nameof(obj));
        
            return JsonConvert.SerializeObject(obj);
        }
    }
}