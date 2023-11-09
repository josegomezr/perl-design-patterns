/**
 * This is all cursed code I just janked off plant-uml to encode the zopfli
 * compression result of each *.plantuml diagram into a URL-safe encoding they
 * use.
 * 
 * No clue how it works, all I know is you need `zoplfi` (zypper in zopfli),
 * and:
 * 
 * zopfli $diagram_source --deflate -c > $tmp
 * node tools/encode-plant-uml.js $tmp # prints the encoded result
 * 
 */
const fs = require('fs');

function encode64_(e) {
  for (r = '', i = 0; i < e.length; i += 3) i + 2 == e.length ? r += append3bytes(e[i], e[i + 1], 0) : i + 1 == e.length ? r += append3bytes(e[i], 0, 0) : r += append3bytes(e[i], e[i + 1], e[i + 2]);
  return r
}

function append3bytes(e, n, t) {
  return c1 = e >> 2,
  c2 = (3 & e) << 4 | n >> 4,
  c3 = (15 & n) << 2 | t >> 6,
  c4 = 63 & t,
  r = '',
  r += encode6bit(63 & c1),
  r += encode6bit(63 & c2),
  r += encode6bit(63 & c3),
  r += encode6bit(63 & c4),
  r
}

function encode6bit(e) {
  return e < 10 ? String.fromCharCode(48 + e) : (e -= 10) < 26 ? String.fromCharCode(65 + e) : (e -= 26) < 26 ? String.fromCharCode(97 + e) : 0 == (e -= 26) ? '-' : 1 == e ? '_' : '?'
}

var filename = process.argv.pop();

console.log(encode64_(fs.readFileSync(filename)));
