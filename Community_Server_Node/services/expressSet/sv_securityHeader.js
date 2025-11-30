const helmet = require('helmet');

// 보안 헤더 설정
const securitySet = helmet({
  // contentSecurityPolicy: 외부 CDN, 이미지, 폰트 등 로딩에 영향을 줄 수 있으니 주의
  contentSecurityPolicy: true, // 외부 리소스 로딩 제한 (스크립트, 이미지 등) → XSS 방지

  crossOriginEmbedderPolicy: true,      // 교차 출처 리소스 임베딩 제한 → 보안 격리 강화
  crossOriginOpenerPolicy: true,        // 새 창/탭과의 공유 제한 → Spectre 공격 방지
  crossOriginResourcePolicy: true,      // 외부 리소스 공유 제한 → 민감 리소스 보호
  dnsPrefetchControl: true,             // DNS 프리페치 제어 → 정보 노출 방지
  expectCt: true,                       // Certificate Transparency 정책 설정 → SSL 인증서 위조 방지
  frameguard: true,                     // iframe 삽입 차단 → 클릭재킹 방지
  hidePoweredBy: true,                  // X-Powered-By 헤더 제거 → Express 노출 방지

  hsts: false,                          // HTTPS 강제 → 중간자 공격 방지

  ieNoOpen: true,                       // IE에서 다운로드된 파일 자동 실행 방지
  noSniff: true,                        // MIME 타입 추측 방지 → 악성 콘텐츠 실행 차단
  originAgentCluster: true,             // 브라우저의 Origin 격리 활성화
  permittedCrossDomainPolicies: true,   // Adobe 플러그인 정책 제한
  referrerPolicy: true,                 // 리퍼러 정보 제한 → 개인정보 보호
  xssFilter: true                       // XSS 필터 활성화 (구형 브라우저용) → 최신 브라우저에선 무의미
});

module.exports = securitySet;