# Community-App
WPF client, Node.js server, MariaDB backend / React client planned

## 📌 개요
- **목적**: C#/WPF, Node.js, MariaDB 기반의 CRUD 커뮤니티 애플리케이션 제작
- **구성**: 클라이언트(WPF v4.7.2), 서버(Node.js/Express v22.15.1), DB(MariaDB v11.8)

---

## 📌 구조
```mermaid
flowchart LR
    Client[WPF Client] <--> Server[Node.js Express]
    Server <--> DB[(MariaDB)]
```

```
Community-App/
│
├── Community_Client_WPF/     # WPF 클라이언트 코드
├── Community_Server_Node/    # Node.js 서버 코드
├── Community_DB_MariaDB/     # DB 스키마, SQL
├── Community_Document/       # 기능 설명, 캡쳐 이미지, API/쿼리 정리
└── README.md                 # 전체 설명
```

---

## 📌 WPF Client

| Function | Description           |
| -------- | --------------------- |
| 사용자      | 회원가입 / 로그인 / 로그아웃     |
| 게시판      | 게시글 등록 / 조회 / 수정 / 삭제 |
| 댓글       | 게시글별 댓글 작성 / 수정 / 삭제  |
| 파일 업로드   | 이미지 첨부 및 미리보기         |
| 관리자      | 사용자 관리, 게시글 관리        |

---

## 📌 Node.js API

| Method | Endpoint           | Description |
| ------ | ------------------ | ----------- |
| GET    | /                  | 서버 확인       |
| POST   | /login             | 사용자 로그인     |
| GET    | /board             | 게시글 목록 조회   |
| GET    | /board/page/search | 게시글 조건 조회   |
| POST   | /board/new         | 새 게시글 작성    |
| PUT    | /board/update      | 게시글 수정      |
| DELETE | /board/delete/:id  | 게시글 삭제      |
| GET    | /board/:id         | 댓글 조회       |
| POST   | /comment/new       | 댓글 작성       |

---

## 📌 MariaDB

| Table        | 주요 컬럼                               | 설명     |
| ------------ | ----------------------------------- | ------ |
| `tb_user`    | user_id, pw, name                   | 사용자 계정 |
| `tb_board`   | board_id, title, content, user_id   | 게시글 정보 |
| `tb_comment` | comment_id, board_id, text, user_id | 댓글     |

![ERD](./Community_Document/images/ERD_20251002_211152.png)

```mermaid
erDiagram
	tb_organization_companies }o--|| tb_organization_locations : references
	tb_organization_departments }o--|| tb_organization_companies : references
	tb_employees }o--|| tb_organization_departments : references
	tb_employees }o--|| tb_organization_teams : references
	tb_employees }o--|| tb_organization_ranks : references
	tb_employees }o--|| tb_organization_positions : references
	tb_employees }o--|| tb_organization_roles : references
	tb_employee_reviews }o--|| tb_employees : references
	tb_employee_reviews }o--|| tb_employees : references
	tb_employee_leaves }o--|| tb_employees : references
	tb_employee_leaves }o--|| tb_employees : references
	tb_employee_account ||--|| tb_employees : references
	tb_employee_permissions }o--|| tb_employees : references
	tb_employee_permissions }o--|| tb_system_permissions : references
	tb_organization_locations ||--o{ tb_customers : references
	tb_customers ||--o{ tb_customer_products : references
	tb_customer_products }o--|| tb_products : references
	tb_product_inventory }o--|| tb_employees : references
	tb_product_inventory }o--|| tb_employees : references
	tb_product_inventory }o--|| tb_products : references
	tb_customers ||--o{ tb_projects : references
	tb_project_members }o--|| tb_projects : references
	tb_project_members }o--|| tb_employees : references
	tb_projects ||--o{ tb_project_tasks : references
	tb_project_tasks ||--o{ tb_project_task_members : references
	tb_employees ||--o{ tb_project_task_members : references
	tb_chat_rooms ||--o{ tb_chat_messages : references
	tb_chat_members }o--|| tb_chat_rooms : references
	tb_posts ||--o{ tb_post_comments : references
	tb_employees ||--o{ tb_chat_messages : references
	tb_employees ||--o{ tb_chat_members : references
	tb_employees ||--o{ tb_posts : references
	tb_employees ||--o{ tb_post_comments : references

	tb_system_settings {
		INTEGER id
		VARCHAR(255) name
		INTEGER value_number
		VARCHAR(255) value_text
		VARCHAR(255) description
		TIMESTAMP created_at
		TIMESTAMP updated_at
	}

	tb_system_monitor {
		INTEGER id
		VARCHAR(255) name
		INTEGER state
		VARCHAR(255) status
		VARCHAR(255) description
		INTEGER check_interval
		TIMESTAMP checked_at
		TIMESTAMP created_at
		TIMESTAMP updated_at
	}

	tb_system_logs {
		INTEGER id
		INTEGER log_code
		VARCHAR(255) content
		TIMESTAMP created_at
	}

	tb_system_permissions {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER category
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_posts {
		INTEGER id
		INTEGER employee_id
		VARCHAR(255) title
		VARCHAR(255) content
		INTEGER comments
		TIMESTAMP comment_at
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_post_comments {
		INTEGER id
		INTEGER post_id
		INTEGER employee_id
		VARCHAR(255) content
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_chat_rooms {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		TIMESTAMP message_at
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_chat_messages {
		INTEGER id
		INTEGER chat_room_id
		INTEGER employee_id
		VARCHAR(255) message
		TIMESTAMP created_at
		INTEGER is_deleted
	}

	tb_chat_members {
		INTEGER id
		INTEGER chat_room_id
		INTEGER employee_id
		TIMESTAMP created_at
		INTEGER is_deleted
	}

	tb_projects {
		INTEGER id
		INTEGER customer_id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER progress
		TIMESTAMP start_date
		TIMESTAMP end_date
		INTEGER status
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_project_members {
		INTEGER id
		INTEGER project_id
		INTEGER employee_id
		TIMESTAMP created_at
		INTEGER is_deleted
	}

	tb_project_tasks {
		INTEGER id
		INTEGER project_id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER progress
		TIMESTAMP start_date
		TIMESTAMP end_date
		INTEGER status
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_project_task_members {
		INTEGER id
		INTEGER project_task_id
		INTEGER employee_id
		TIMESTAMP created_at
		INTEGER is_deleted
	}

	tb_customers {
		INTEGER id
		INTEGER location_id
		VARCHAR(255) name
		VARCHAR(255) description
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_customer_products {
		INTEGER id
		INTEGER product_id
		INTEGER customer_id
		TIMESTAMP created_at
		INTEGER is_deleted
	}

	tb_products {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) content
		VARCHAR(255) description
		VARCHAR(255) image_path
		INTEGER total_count
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_product_inventory {
		INTEGER id
		INTEGER product_id
		INTEGER from_employee_id
		INTEGER to_employee_id
		INTEGER movement_type
		INTEGER count
		VARCHAR(255) content
		VARCHAR(255) description
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_employees {
		INTEGER id
		VARCHAR(255) employee_code
		VARCHAR(255) name
		INTEGER gender
		DATE birth_date
		VARCHAR(255) email
		VARCHAR(255) phone
		VARCHAR(255) address
		VARCHAR(255) description
		VARCHAR(255) image_path
		INTEGER department_id
		INTEGER team_id
		INTEGER rank_id
		INTEGER position_id
		INTEGER role_id
		INTEGER status
		TIMESTAMP joined_at
		TIMESTAMP resigned_at
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_employee_reviews {
		INTEGER id
		INTEGER employee_id
		INTEGER reviewer_id
		VARCHAR(255) review_period
		INTEGER category
		INTEGER score
		VARCHAR(255) comment
		INTEGER recommendation
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_employee_leaves {
		INTEGER id
		INTEGER employee_id
		INTEGER approver_id
		INTEGER category
		TIMESTAMP start_dt
		TIMESTAMP end_dt
		VARCHAR(255) comment
		INTEGER status
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_employee_account {
		INTEGER id
		INTEGER employee_id
		VARCHAR(255) login_id
		VARCHAR(255) login_pw
		VARCHAR(255) name
		VARCHAR(255) description
		VARCHAR(255) backup_email
		INTEGER account_status
		VARCHAR(255) login_ip
		INTEGER login_status
		INTEGER login_success_count
		INTEGER login_fail_count
		TIMESTAMP login_at
		TIMESTAMP logout_at
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_employee_permissions {
		INTEGER id
		INTEGER employee_id
		INTEGER permissions_id
		INTEGER is_allowed
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_organization_locations {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_organization_companies {
		INTEGER id
		INTEGER location_id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER score
		TIMESTAMP created_id
		TIMESTAMP updated_id
		INTEGER is_deleted
	}

	tb_organization_departments {
		INTEGER id
		INTEGER company_id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER salary
		INTEGER score
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_organization_teams {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER salary
		INTEGER score
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_organization_ranks {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER salary
		INTEGER score
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_organization_positions {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER salary
		INTEGER score
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}

	tb_organization_roles {
		INTEGER id
		VARCHAR(255) name
		VARCHAR(255) description
		INTEGER salary
		INTEGER score
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INTEGER is_deleted
	}
```
