using Newtonsoft.Json;

namespace community.Common
{
    public static class Utility
    {
        // object 타입에 확장 메소드 추가
        public static T DeepCopy<T>(T obj)
        {
            var json = JsonConvert.SerializeObject(obj);
            return JsonConvert.DeserializeObject<T>(json);
        }

        // object 타입에 확장 메소드 추가
        public static string ToDebugString(this object obj)
        {
            if (obj == null) return "null";
            return $"Type: {obj.GetType().Name}, Value: {obj}";
        }
    }
}
