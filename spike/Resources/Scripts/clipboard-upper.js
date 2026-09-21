function main(input) {
  var text = (input || clipboard.read() || "").toUpperCase();
  clipboard.write(text);
  return text;
}
