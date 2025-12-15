using System;

namespace community.Common
{
    public abstract class Singleton<T> where T : class
    {
        private static readonly Lazy<T> _instance = new Lazy<T>(() =>
        {
            // 파생 클래스의 protected 생성자를 호출
            return (T)Activator.CreateInstance(typeof(T), true);
        });

        public static T Instance => _instance.Value;

        // 외부에서 직접 생성하지 못하도록 보호
        protected Singleton() { }
    }
}
