/*
// 이벤트 루프 지연 모니터링
const toobusy = require('toobusy-js'); // 이벤트 루프 지연 모니터링
toobusy.maxLag(50); // 50ms 이상 지연되면 busy로 판단 (최소 10ms)

app.use((req, res, next) => {

    res.setTimeout(3000); // ms 타임아웃 설정 (선택)

    res.on('timeout', () => {
      console.warn(`⏱️ Timeout on ${req.method} ${req.originalUrl}`);
      // 선택적으로 응답 시도 (주의: 이미 응답했을 수도 있음)
      if (!res.headersSent) {
        res.status(503).send('Request timed out');
      }
    });


    // 이벤트 루프 지연 모니터링.
    if (toobusy()) {
        // log if you see necessary
        res.status(503).send("Server Too Busy");
    } else {
      next();
    }
});

setInterval(() => {
  console.log(`Event loop lag: ${toobusy.lag()} ms`);
}, 1000);
*/