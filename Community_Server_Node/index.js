const express = require('express');
const app = express();
app.use(express.json());
const PORT = process.env.PORT || 3000;
const mysql = require('mysql2/promise');

// MariaDB 접속 정보
const dbConfig = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '1111',
};

/*
const connection = mysql.createConnection({
  host: 'localhost',
  user: '...',
  password: '...',
  database: '...',
  timezone: 'local', // 'Z' 또는 '+00:00', 'local' 등
  
  typeCast: function (field, next) {
    if (field.type === 'DATETIME') {
      return field.string(); // 그대로 문자열로 반환
    }
    return next();
  }
    
});
*/



function Now() {
    const date = new Date();
    // YYYY-MM-DD HH:mm:ss 형식으로 변환
    const formattedDate = date.toISOString()
      .replace('T', ' ')   // 'T'를 공백으로 대체
      .replace(/\..+/, ''); // 소수점 이하 시간(밀리초) 제거

    return formattedDate;
}


// 사용할 DB명 변수
let databaseName = 'community';

// DB 연결 함수
async function getConnection() {
  if (!databaseName) throw new Error('databaseName을 먼저 지정하세요.');
  return mysql.createConnection({ 
    ...dbConfig, 
    database: databaseName, 
    typeCast: function (field, next) {
      if (field.type === 'DATETIME') {
        return field.string(); // 그대로 문자열로 반환
      }
      return next();
    }

  });

}

// DB명 지정 API (예시)
app.post('/set-db', async (req, res) => {
  const { dbName } = req.body;
  if (!dbName) return res.status(400).json({ error: 'dbName 필요' });
  databaseName = dbName;
  res.json({ message: `DB명 설정됨: ${databaseName}` });
});

// -------------------------------------------------------

// 서버 확인
app.get('/', (req, res) => {
  res.send('Hello, REST API!');
});

// 사용자 로그인
app.post('/login', async (req, res) => {
  try {
    const { id, pw } = req.body;
    if (!id || !pw) {
      return res.status(400).json({ error: 'id와 pw가 필요합니다.' });
    }
    const conn = await getConnection();
    const [rows] = await conn.query('CALL p_user_select(?, ?)', [id, pw]);
    await conn.end();

    // console.log(rows);

    const user = rows[0] && rows[0][0];
    if (!user) {
      return res.status(401).json({ error: '로그인 실패' });
    }
    res.json({ message: '로그인 성공', user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 전체 게시글 조회
app.get('/board', async (req, res) => {
  try {
    const conn = await getConnection();
    const [rows] = await conn.query('SELECT * FROM v_board LIMIT 10 OFFSET 0;');
    await conn.end();

    console.log(`${Now()} \t 전체 게시글 조회`);

    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 게시글 조건 조회
app.get('/board/page/search', async (req, res) => {
  try {
    const conn = await getConnection();

    // http://localhost:3000/board/page/search?category=title&search_term=쿠&limit=10&offset=0
    // const { category, search_term, limit, offset } = req.query;

    // const { category, search_term, limit, offset } = req.body;

    const sql = `SELECT * FROM v_board b WHERE b.${category} LIKE \'%${search_term}%\' LIMIT ${limit} OFFSET ${offset};`;


    console.log(`${Now()} \t 게시글 조건 조회 \t ${sql}`);

    // const [rows] = await conn.query('SELECT * FROM v_board b WHERE b.? LIKE \'%?%\' LIMIT ? OFFSET ?;'
    //   , [category, search_term, limit, offset]
    // );

    const [rows] = await conn.query(sql);
    await conn.end();

    // res.json(rows);
    res.status(201).json(rows);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// LIMIT 10 OFFSET 10

// 게시글 생성
app.post('/board/new', async (req, res) => {
  try {
    const conn = await getConnection();

    console.log(req.body);

    // {"user_id":0,"title":"123","content":"123"}
    const { user_id, title, content } = req.body;

    const [result] = await conn.query(
      'INSERT INTO `community`.`tb_board` (`user_id`, `title`, `content`) VALUES (?, ?, ?);',
      [user_id, title, content]);
    
    await conn.end();

    res.status(201).json({ id: result.insertId, affectedRows: result.affectedRows });
  } catch (err) {
    console.log(err.message);
    res.status(500).json({ error: err.message });
  }
});

// 게시글 수정
app.put('/board/update', async (req, res) => {
  try {
    const conn = await getConnection();
    const { id, title, content } = req.body;
    const [result] = await conn.query('UPDATE tb_board SET title = ?, content = ? where id = ?;', [title, content, id]);

    await conn.end();
    res.status(201).json({ id: result.updateId, affectedRows: result.affectedRows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 게시글 삭제
app.delete('/board/delete/:id', async (req, res) => {
  try {
    const conn = await getConnection();

    const [result] = await conn.query('DELETE FROM tb_board WHERE id = ?;', [req.params.id]);
    await conn.end();

    console.log(`${new Date()} \t /board/delete \t board:${req.params.id}`);

    res.status(201).json({ message: '삭제됨', id: req.params.id });
    // res.status(201).json({ id: result.deleteId, affectedRows: result.affectedRows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 댓글 조회
app.get('/board/:id', async (req, res) => {
  try {
    const conn = await getConnection();
    const [rows] = await conn.query('CALL p_comment_board(?)', [req.params.id]);
    await conn.end();

    // console.log(rows[0]);

    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 댓글 생성
app.post('/comment/new', async (req, res) => {
  try {
    const conn = await getConnection();

    console.log(req.body);

    const { board_id, user_id, content } = req.body;

    const [result] = await conn.query(
      'INSERT INTO `community`.`tb_comment` (`user_id`, `board_id`, `content`) VALUES (?, ?, ?);',
      [user_id, board_id, content]);

    res.status(201).json({ id: result.insertId, affectedRows: result.affectedRows });
  } catch (err) {
    console.log(err.message);
    res.status(500).json({ error: err.message });
  }
});



// ------------------------------------------


// 전체 사용자 조회
app.get('/users', async (req, res) => {
  try {
    const conn = await getConnection();
    const [rows] = await conn.query('SELECT * FROM users');
    await conn.end();
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});




// 예시: 사용자 생성
app.post('/users', async (req, res) => {
  try {
    const conn = await getConnection();
    const { name } = req.body;
    const [result] = await conn.query('INSERT INTO users (name) VALUES (?)', [name]);
    await conn.end();
    res.status(201).json({ id: result.insertId, name });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 예시: 사용자 단일 조회
app.get('/users/:id', async (req, res) => {
  try {
    const conn = await getConnection();
    const [rows] = await conn.query('SELECT * FROM users WHERE id = ?', [req.params.id]);
    await conn.end();
    res.json(rows[0] || null);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 예시: 사용자 정보 수정
app.put('/users/:id', async (req, res) => {
  try {
    const conn = await getConnection();
    const { name } = req.body;
    await conn.query('UPDATE users SET name = ? WHERE id = ?', [name, req.params.id]);
    await conn.end();
    res.json({ id: req.params.id, name });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 예시: 사용자 삭제
app.delete('/users/:id', async (req, res) => {
  try {
    const conn = await getConnection();
    await conn.query('DELETE FROM users WHERE id = ?', [req.params.id]);
    await conn.end();
    res.json({ message: '삭제됨', id: req.params.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});