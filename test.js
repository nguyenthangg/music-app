import http from 'k6/http';
import { check, sleep, group } from 'k6';

export let options = {
  stages: [
         // Ramp up to 500 users in 5 minutes
    { duration: '2m', target: 1000 },    // Ramp up to 1000 users in 2 minutes   
    { duration: '2m', target: 0 },       // Ramp down to 0 users in 2 minutes
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],   // 95% of requests must complete within 500ms
  },
};

export default function () {
  group('Visit Homepage', function () {
    let res = http.get('https://registry.terraform.io/providers');
    check(res, { 'status is 200': (r) => r.status === 200 });
  });

  sleep(50);
}
