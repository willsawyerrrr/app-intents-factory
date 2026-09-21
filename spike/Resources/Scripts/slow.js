function main(input) {
  var seconds = parseInt(input, 10) || 60;
  for (var i = 1; i <= seconds; i++) {
    sleep(1000);
    console.log("tick " + i);
  }
  return "done after " + seconds + "s";
}
