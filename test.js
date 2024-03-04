import http from 'k6/http';
import { check, sleep, group } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 10 },      // Ramp up to 10 users in 1 minute
    { duration: '3m', target: 100 },     // Ramp up to 100 users in 3 minutes
    { duration: '5m', target: 500 },     // Ramp up to 500 users in 5 minutes
    { duration: '2m', target: 1000 },    // Ramp up to 1000 users in 2 minutes
    { duration: '3m', target: 1000 },    // Hold 1000 users for 3 minutes
    { duration: '2m', target: 0 },       // Ramp down to 0 users in 2 minutes
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],   // 95% of requests must complete within 500ms
  },
};

export default function () {
  group('Visit Homepage', function () {
    let res = http.get('https://music.filetransfer-thangnguyen.com');
    check(res, { 'status is 200': (r) => r.status === 200 });
  });

  // You can add more groups to simulate different user actions
  // Example:
  // group('Search and Browse', function () {
  //   // Simulate user actions for searching and browsing
  // });

  sleep(1);
}
