// ffi.mjs
export function every(interval, cb) {
  window.setInterval(cb, interval);
}
