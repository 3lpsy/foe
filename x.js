var columnCount = 3;
for (var i = 0; i < 9; i++) {
  var row = Math.floor(i / columnCount);
  var col = i % columnCount;
  console.log(i, row, col);
}
