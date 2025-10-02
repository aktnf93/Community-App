using community.Models;
using community.Views;
using Mysqlx.Session;
using MySqlX.XDevAPI.Common;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;

namespace community.Common
{
    public class Server_REST_API
    {
        public static Server_REST_API Instance { get; } = new Server_REST_API("http://localhost:3000/");

        private readonly HttpClient _httpClient;

        private Server_REST_API()
        {
            
        }

        private Server_REST_API(string baseUrl)
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri(baseUrl)
            };
        }

        // GET 요청
        public async Task<string> GetAsync(string endpoint)
        {
            var response = await _httpClient.GetAsync(endpoint);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        // POST 요청
        public async Task<string> PostAsync(string endpoint, HttpContent content)
        {
            var response = await _httpClient.PostAsync(endpoint, content);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        // PUT 요청
        public async Task<string> PutAsync(string endpoint, HttpContent content)
        {
            var response = await _httpClient.PutAsync(endpoint, content);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        // DELETE 요청
        public async Task<string> DeleteAsync(string endpoint)
        {
            var response = await _httpClient.DeleteAsync(endpoint);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        public M_Board[] GetBoards()
        {
            var response = _httpClient.GetAsync("board").Result;
            
            var status_code = response.EnsureSuccessStatusCode().StatusCode;

            var json = response.Content.ReadAsStringAsync().Result;
            
            var result = Server_Data_Convert.FromJson<M_Board[]>(json);

            return result;
        }

        public M_Comment[] GetComments(int board_id)
        {
            var response = _httpClient.GetAsync($"board/{board_id}").Result;

            var status_code = response.EnsureSuccessStatusCode().StatusCode;

            var json = response.Content.ReadAsStringAsync().Result;

            var result = Server_Data_Convert.FromJson<M_Comment[]>(json);

            return result;
        }

        public M_User PostUser(string u_id, string u_pw)
        {
            var data = new { id = u_id, pw = u_pw };

            var json = Server_Data_Convert.ToJson(data);

            var content = new StringContent(json, Encoding.UTF8, "application/json");

            var response = _httpClient.PostAsync("login", content).Result;
            var status_code = response.EnsureSuccessStatusCode().StatusCode;
            var result_json = response.Content.ReadAsStringAsync().Result;

            // {"message":"로그인 성공","user":{"id":1,"nickname":"Admin"}}
            dynamic obj = Server_Data_Convert.FromJson<object>(result_json);
            var result = new M_User()
            {
                Id = obj.user.id,
                Nickname = obj.user.nickname
            };

            return result;
        }

        public void Post_Insert_Board(M_Board board)
        {
            try
            {
                var data = new { user_id = board.User_Id, title = board.Title, content = board.Content };

                var json = Server_Data_Convert.ToJson(data);
                
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                
                var response = _httpClient.PostAsync("/board/new", content).Result;
                var status_code = response.EnsureSuccessStatusCode().StatusCode;
                var result_json = response.Content.ReadAsStringAsync().Result;
                
                dynamic result = Server_Data_Convert.FromJson<object>(result_json);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void Put_Update_Board(M_Board board)
        {
            try
            {
                var data = new { id = board.Id, title = board.Title, content = board.Content };

                var json = Server_Data_Convert.ToJson(data);

                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = _httpClient.PutAsync("/board/update", content).Result;
                var status_code = response.EnsureSuccessStatusCode().StatusCode;
                var result_json = response.Content.ReadAsStringAsync().Result;

                dynamic result = Server_Data_Convert.FromJson<object>(result_json);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void Put_Delete_Board(int board_id)
        {
            try
            {

                // var response = await _httpClient.DeleteAsync(endpoint);
                // response.EnsureSuccessStatusCode();
                // return await response.Content.ReadAsStringAsync();

                var response = _httpClient.DeleteAsync($"/board/delete/{board_id}").Result;
                var status_code = response.EnsureSuccessStatusCode().StatusCode;
                var result_json = response.Content.ReadAsStringAsync().Result;

                dynamic result = Server_Data_Convert.FromJson<object>(result_json);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public M_Comment[] PostComment(int board_id, int login_id, string comment)
        {
            try
            {
                var data = new { board_id = board_id, user_id = login_id, content = comment };

                var json = Server_Data_Convert.ToJson(data);

                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = _httpClient.PostAsync("/comment/new", content).Result;
                var status_code = response.EnsureSuccessStatusCode().StatusCode;
                var result_json = response.Content.ReadAsStringAsync().Result;

                dynamic result = Server_Data_Convert.FromJson<object>(result_json);

                return GetComments(board_id);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

                return new M_Comment[] {  };
            }
        }

        public void Logout()
        {
            // 로그아웃 처리 (예: 토큰 삭제 등)
            _httpClient.DefaultRequestHeaders.Authorization = null;

        }

        public void SetAuthToken(string token)
        {
            // 인증 토큰 설정 (예: JWT 토큰)
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public void Dispose()
        {
            _httpClient.Dispose();
        }


        public async Task PostExampleAsync()
        {
            // 서버 기본 URL
            var api = new Server_REST_API("http://localhost:3000/");

            // 전송할 데이터 객체
            var data = new { name = "홍길동", age = 30 };

            // 객체를 JSON 문자열로 변환
            string json = Server_Data_Convert.ToJson(data);

            // HttpContent 생성 (application/json)
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            // POST 요청 실행 (예: /users 엔드포인트)
            string result = await api.PostAsync("users", content);

            // 결과 출력
            System.Diagnostics.Debug.WriteLine(result);
        }
    }
}