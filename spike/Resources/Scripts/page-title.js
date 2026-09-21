function main(input) {
  var html = http.get(input || "https://example.com");
  var m = /<title[^>]*>([^<]*)<\/title>/i.exec(html);
  return m ? m[1].trim() : "no title";
}
