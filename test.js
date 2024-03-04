import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 10 },  // Start with 10 users for 1 minute
    { duration: '1m', target: 100 },    // Start with 100 users for 1 minute
    { duration: '2m', target: 1000 },  // Ramp up to 1000 users over 4 minutes
  ],
};

export default function () {
  let response = http.get('https://music.filetransfer-thangnguyen.com');
  
  // Add custom checks based on your application's response
  check(response, { 'status is 200': (r) => r.status === 200 });
  
  // Simulate user think time
  sleep(1);
}
