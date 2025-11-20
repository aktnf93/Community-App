# 📒 Server API

# 📌Server
- URL : http://localhost:12070
- Setup: node.js install / npm install --save / node index.js
- 
# 📌HTTP

- node.js, npm package : http v24, express ^5.1.0
- C#, System.Net.Http.HttpClient
- ※ DB 요청은 URL 파라미터(쿼리 스트링)를 사용하지 않고, body.json을 사용함.
- ※ Response의 종류는 없음, rows, db result, error object, image가 있음.
- ※ API 항목에 Request 의 \"-\" 는 case를 나타냄.
- 

## 📜API

| No  | Use | Method | URL                             | Description   | Request                                              | Response    |
| --- | --- | ------ | ------------------------------- | ------------- | ---------------------------------------------------- | ----------- |
| 1   | N   | get    | /                               | none          | none                                                 | 200         |
| 2   | N   | get    | /favicon.ico                    | none          | none                                                 | 404         |
| 3   | Y   | get    | /uploads/ { image.png }         | 이미지 불러오기      | none                                                 | 200 : image |
|     |     |        |                                 |               |                                                      |             |
| 4   | Y   | post   | /post/category/select           | 게시판 카테고리 불러오기 | - name \*like<br>- ...                               | rows        |
| 5   | Y   | post   | /post/category/insert           | 게시판 카테고리 추가하기 | - ...                                                | db result   |
| 6   | Y   | put    | /post/category/update           | 게시판 카테고리 수정하기 | - id, ...                                            | db result   |
| 7   | Y   | delete | /post/category/delete           | 게시판 카테고리 삭제하기 | - id                                                 | db result   |
| 8   | Y   | post   | /post/list/select               | 게시판 불러오기      | - title \*like<br>- content \* like<br>- category_id | rows        |
| 9   | Y   | post   | /post/list/insert               | 게시판 추가하기      | - ...                                                | db result   |
| 10  | Y   | put    | /post/list/update               | 게시판 수정하기      | - id, ...                                            | db result   |
| 11  | Y   | delete | /post/list/delete               | 게시판 삭제하기      | - id                                                 | db result   |
| 12  | Y   | post   | /post/comment/select            | 게시글 댓글 불러오기   | - post_id                                            | rows        |
| 13  | Y   | post   | /post/comment/insert            | 게시글 댓글 추가하기   | - ...                                                | db result   |
| 14  | Y   | put    | /post/comment/update            | 게시글 댓글 수정하기   | - id, ...                                            | db result   |
| 15  | Y   | delete | /post/comment/delete            | 게시글 댓글 삭제하기   | - id                                                 | db result   |
|     |     |        |                                 |               |                                                      |             |
| 16  | Y   | post   | /chat/room/select               | 채팅방 불러오기      | - ...                                                | rows        |
| 17  | Y   | post   | /chat/room/insert               | 채팅방 추가하기      | - ...                                                | db result   |
| 18  | Y   | put    | /chat/room/update               | 채팅방 수정하기      | - id, ...                                            | db result   |
| 19  | Y   | delete | /chat/room/delete               | 채팅방 삭제하기      | - id                                                 | db result   |
| 20  | N   | post   | /chat/member/select             | 채팅방 멤버 불러오기   |                                                      |             |
| 21  | N   | post   | /chat/member/insert             | 채팅방 멤버 추가하기   |                                                      | db result   |
| 22  | N   | put    | /chat/member/update             | 채팅방 멤버 수정하기   |                                                      | db result   |
| 23  | N   | delete | /chat/member/delete             | 채팅방 멤버 삭제하기   |                                                      | db result   |
| 24  | N   | post   | /chat/message/select            | 채팅방 메시지 불러오기  |                                                      |             |
| 25  | N   | post   | /chat/message/insert            | 채팅방 메시지 추가하기  |                                                      | db result   |
| 26  | N   | put    | /chat/message/update            | 채팅방 메시지 수정하기  |                                                      | db result   |
| 27  | N   | delete | /chat/message/delete            | 채팅방 메시지 삭제하기  |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |
| 28  | Y   | post   | /project/list/select            | 프로젝트 불러오기     | - ...                                                | rows        |
| 29  | Y   | post   | /project/list/insert            | 프로젝트 추가하기     | - ...                                                | db result   |
| 30  | Y   | put    | /project/list/update            | 프로젝트 수정하기     | - id, ...                                            | db result   |
| 31  | Y   | delete | /project/list/delete            | 프로젝트 삭제하기     | - id                                                 | db result   |
| 32  | Y   | post   | /project/member/select          | 멤버 불러오기       | - project_id                                         | rows        |
| 33  | Y   | post   | /project/member/insert          | 멤버 추가하기       | - project_id, ...                                    | db result   |
| 34  | Y   | put    | /project/member/update          | 멤버 수정하기       | - id, ...                                            | db result   |
| 35  | Y   | delete | /project/member/delete          | 멤버 삭제하기       | - id                                                 | db result   |
| 36  | Y   | post   | /project/task/select            | 작업 불러오기       | - project_id                                         | rows        |
| 37  | Y   | post   | /project/task/insert            | 작업 추가하기       | - ...                                                | db result   |
| 38  | Y   | put    | /project/task/update            | 작업 수정하기       |                                                      | db result   |
| 39  | Y   | delete | /project/task/delete            | 작업 삭제하기       |                                                      | db result   |
| 40  | Y   | post   | /project/taskmember/select      | 작업 멤버 불러오기    | - task_id                                            | rows        |
| 41  | Y   | post   | /project/taskmember/insert      | 작업 멤버 추가하기    |                                                      | db result   |
| 42  | Y   | put    | /project/taskmember/update      | 작업 멤버 수정하기    |                                                      | db result   |
| 43  | Y   | delete | /project/taskmember/delete      | 작업 멤버 삭제하기    |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |
| 44  | Y   | post   | /customer/list/select           | 고객사 불러오기      | - ...                                                | rows        |
| 45  | Y   | post   | /customer/list/insert           | 고객사 추가하기      | - ...                                                | db result   |
| 46  | Y   | put    | /customer/list/update           | 고객사 수정하기      | - id, ...                                            | db result   |
| 47  | Y   | delete | /customer/list/delete           | 고객사 삭제하기      | - id                                                 | db result   |
| 48  | Y   | post   | /customer/product/select        | 고객사 제품 불러오기   | - customer_id                                        | rows        |
| 49  | Y   | post   | /customer/product/insert        | 고객사 제품 추가하기   |                                                      | db result   |
| 50  | Y   | put    | /customer/product/update        | 고객사 제품 수정하기   |                                                      | db result   |
| 51  | Y   | delete | /customer/product/delete        | 고객사 제품 삭제하기   |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |
| 52  | Y   | post   | /product/list/select            | 제품 불러오기       |                                                      | rows        |
| 53  | Y   | post   | /product/list/insert            | 제품 추가하기       |                                                      | db result   |
| 54  | Y   | put    | /product/list/update            | 제품 수정하기       |                                                      | db result   |
| 55  | Y   | delete | /product/list/delete            | 제품 삭제하기       |                                                      | db result   |
| 56  | Y   | post   | /product/inventory/select       | 제품 이력 불러오기    |                                                      | rows        |
| 57  | Y   | post   | /product/inventory/insert       | 제품 이력 추가하기    |                                                      | db result   |
| 58  | Y   | put    | /product/inventory/update       | 제품 이력 수정하기    |                                                      | db result   |
| 59  | Y   | delete | /product/inventory/delete       | 제품 이력 삭제하기    |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |
| 60  | Y   | post   | /employee/list/select           | 직원 불러오기       | - ...                                                | rows        |
| 61  | Y   | post   | /employee/list/insert           | 직원 추가하기       | - ...                                                | db result   |
| 62  | Y   | put    | /employee/list/update           | 직원 수정하기       | - id, ...                                            | db result   |
| 63  | Y   | delete | /employee/list/delete           | 직원 삭제하기       | - id                                                 | db result   |
| 64  | Y   | post   | /employee/leave/select          | 직원평가 불러오기     |                                                      | rows        |
| 65  | Y   | post   | /employee/leave/insert          | 직원평가 추가하기     |                                                      | db result   |
| 66  | Y   | put    | /employee/leave/update          | 직원평가 수정하기     |                                                      | db result   |
| 67  | Y   | delete | /employee/leave/delete          | 직원평가 삭제하기     |                                                      | db result   |
| 68  | Y   | post   | /employee/review/select         | 직원휴가 불러오기     |                                                      | rows        |
| 69  | Y   | post   | /employee/review/insert         | 직원휴가 추가하기     |                                                      | db result   |
| 70  | Y   | put    | /employee/review/update         | 직원휴가 수정하기     |                                                      | db result   |
| 71  | Y   | delete | /employee/review/delete         | 직원휴가 삭제하기     |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |
| 72  | Y   | post   | /organization/location/select   | 지역 정보 불러오기    |                                                      | rows        |
| 73  | Y   | post   | /organization/location/insert   | 지역 정보 추가하기    |                                                      | db result   |
| 74  | Y   | put    | /organization/location/update   | 지역 정보 수정하기    |                                                      | db result   |
| 75  | Y   | delete | /organization/location/delete   | 지역 정보 삭제하기    |                                                      | db result   |
| 76  | Y   | post   | /organization/company/select    | 회사 정보 불러오기    | - ...                                                | rows        |
| 77  | Y   | post   | /organization/company/insert    | 회사 정보 추가하기    | - name<br>- description                              | db result   |
| 78  | Y   | put    | /organization/company/update    | 회사 정보 수정하기    | - id<br>- name<br>- description                      | db result   |
| 79  | Y   | delete | /organization/company/delete    | 회사 정보 삭제하기    | - id                                                 | db result   |
| 80  | Y   | post   | /organization/department/select | 부서 정보 불러오기    |                                                      | rows        |
| 81  | Y   | post   | /organization/department/insert | 부서 정보 추가하기    |                                                      | db result   |
| 82  | Y   | put    | /organization/department/update | 부서 정보 수정하기    |                                                      | db result   |
| 83  | Y   | delete | /organization/department/delete | 부서 정보 삭제하기    |                                                      | db result   |
| 84  | Y   | post   | /organization/team/select       | 팀 정보 불러오기     |                                                      | rows        |
| 85  | Y   | post   | /organization/team/insert       | 팀 정보 추가하기     |                                                      | db result   |
| 86  | Y   | put    | /organization/team/update       | 팀 정보 수정하기     |                                                      | db result   |
| 87  | Y   | delete | /organization/team/delete       | 팀 정보 삭제하기     |                                                      | db result   |
| 88  | Y   | post   | /organization/rank/select       | 직급 정보 불러오기    |                                                      | rows        |
| 89  | Y   | post   | /organization/rank/insert       | 직급 정보 추가하기    |                                                      | db result   |
| 90  | Y   | put    | /organization/rank/update       | 직급 정보 수정하기    |                                                      | db result   |
| 91  | Y   | delete | /organization/rank/delete       | 직급 정보 삭제하기    |                                                      | db result   |
| 92  | Y   | post   | /organization/position/select   | 직책 정보 불러오기    |                                                      | rows        |
| 93  | Y   | post   | /organization/position/insert   | 직책 정보 추가하기    |                                                      | db result   |
| 94  | Y   | put    | /organization/position/update   | 직책 정보 수정하기    |                                                      | db result   |
| 95  | Y   | delete | /organization/position/delete   | 직책 정보 삭제하기    |                                                      | db result   |
| 96  | Y   | post   | /organization/role/select       | 담당 정보 불러오기    |                                                      | rows        |
| 97  | Y   | post   | /organization/role/insert       | 담당 정보 추가하기    |                                                      | db result   |
| 98  | Y   | put    | /organization/role/update       | 담당 정보 수정하기    |                                                      | db result   |
| 99  | Y   | delete | /organization/role/delete       | 담당 정보 삭제하기    |                                                      | db result   |
| 100 | Y   | post   | /organization/privileg/select   | 권한 정보 불러오기    |                                                      | rows        |
| 101 | Y   | post   | /organization/privileg/insert   | 권한 정보 추가하기    |                                                      | db result   |
| 102 | Y   | put    | /organization/privileg/update   | 권한 정보 수정하기    |                                                      | db result   |
| 103 | Y   | delete | /organization/privileg/delete   | 권한 정보 삭제하기    |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |
| 104 | Y   | post   | /system/config/select           | 시스템 정보 불러오기   |                                                      | rows        |
| 105 | Y   | put    | /system/config/update           | 시스템 정보 수정하기   |                                                      | db result   |
| 106 | Y   | post   | /system/log/select              | 시스템 로그 불러오기   |                                                      | rows        |
| 107 | Y   | post   | /system/log/insert              | 시스템 로그 추가하기   |                                                      | db result   |
|     |     |        |                                 |               |                                                      |             |

## 📜Status

| Code | Description                               |
| :--: | ----------------------------------------- |
| 200  | 정상 혹은 미정의 API 응답                          |
| 400  | body.json 의 형식이 알맞지 않음 (오타 등)             |
| 404  | 접속 차단 (ip 차단, api 키 차단 등)                 |
| 409  | db 요청 api 시 필드나 값이 알맞지 않음 (없는 필드, 중복 값 등) |
| 500  | 서버에 정의되지 않은 오류 발생                         |
|      |                                           |

## 💡Example : C\#
```
string BaseUrl = "http://localhost:123";
string url = "/project/list/select";
object data = new { id = 1 };
HttpClient httpClient = new HttpClient()
{
	BaseAddress = new Uri(BaseUrl)
};

HttpRequestMessage req = new HttpRequestMessage();
req.RequestUri = new Uri(httpClient.BaseAddress, url);
req.Headers.Add("authorization", " ... ");
req.Headers.Add("User-Agent", "ClientWPF");
req.Method = HttpMethod.Get;

string json = JsonConvert.SerializeObject(data);
req.Content = new StringContent(json, Encoding.UTF8, "application/json");

HttpResponseMessage res = httpClient.SendAsync(req).Result;

HttpStatusCode statusCode = res.StatusCode;
string body = res.Content.ReadAsStringAsync().Result;

T result = JsonConvert.DeserializeObject<T>(body);

* T : object, class, class[], list<class> ... *
```


# 📌Socket.io

- node.js, npm package : socket.io ^4.8.1
- C#, NuGet : SocketIOClient v3.1.2
- 연관 DB Tables: 
	- tb_chat_rooms
	- tb_chat_members
	- tb_chat_messages
	- tb_employees

## 📜API

| No  | Event          | Description                                                                                            | Request                                | Response                                                                                           |
| :-- | :------------- | :----------------------------------------------------------------------------------------------------- | :------------------------------------- | :------------------------------------------------------------------------------------------------- |
| 1   | connection     | # 채팅 서버 접속<br><br>1. Connection : Client > Server<br>2. Wait ...                                       | none                                   | - connection event<br>- disconnect event                                                           |
| 2   | joinRoom       | # 채팅 방 조인<br><br>1. Send: Client > Server<br>2. DB Table Insert & Select<br>3. next welcome event ...  | - join {<br>  roomId,<br>  userId<br>} | - welcome event<br>- disconnect event                                                              |
| 3   | welcome        | # 채팅 방 데이터 조회(멤버, 메시지)<br><br>1. DB Table Select<br>2. Send: Server > Client                           | none                                   | - ChatRoom {<br>  ... ,<br>  Members : [ ... ],<br>  Messages : [ ... ]<br>}<br>- disconnect event |
| 4   | sendMessage    | # 채팅 메시지 보내기<br><br>1. Send: Client > Server<br>2. DB Table Insert<br>3. next receiveMessage event ... | - Message {<br>  ...<br>}              | - receiveMessage event<br>- disconnect event                                                       |
| 5   | receiveMessage | # 채팅 메시지 받기<br><br>1. DB Table Select<br>2. Broadcast Send : Server > Client<br>3. Client View Show    | none                                   | - Message {<br>  ...<br>}<br>- disconnect event                                                    |
| 6   | disconnect     | # 채팅 서버 연결 끊김<br><br>1. Disconnect : Server > Client                                                   | none                                   | none                                                                                               |

## 💡Example : C\#
```
using Client = SocketIOClient.SocketIO;

...

/* Socket.id Server Connect URL Init - example: "http://localhost:123" */
this.client = new Client(Server.API.BaseUrl);

/* connection event : 채팅 서버 접속 후 joinRoom event를 보내서 특정 채팅방에 조인 요청을 보내야 함 */
this.client.OnConnected += async (sender, e) =>
{
	this.OnConnectedMessage?.Invoke(default(T));

	await this.client.EmitAsync("joinRoom", joinMessage);
};

/* receiveMessage event : 채팅방의 새로운 메시지를 받은 경우 */
this.client.On("receiveMessage", (response) =>
{
	var m = response.GetValue<T>();
	this.OnReceiveMessage?.Invoke(m);
});

/* welcome event : 채팅방에 대한 멤버, 이전 메시지들을 받은 경우 */
this.client.On("welcome", (response) =>
{
	var m = response.GetValue<M_Chat_Room>();
	this.OnWelcomeMessage?.Invoke(m);
});

/* disconnect event : 채팅 서버로부터 끊김 (ex: 타임아웃, 추방 등) */
this.client.OnDisconnected += async (sender, e) =>
{
	this.OnDisconnectedMessage?.Invoke(default(T));
};

/* Socket.io Server Connect : 채팅 서버로 접속 시도 */
this.client.ConnectAsync().Wait(5000);

/* Socket.io Server Data Send : 채팅방으로 새로운 메시지 전달 */
this.client.EmitAsync("sendMessage", message);

/* Socket.io Server Disconnect : 채팅 서버와 연결 해제 시도 */
this.client.DisconnectAsync().Wait(5000);
```
