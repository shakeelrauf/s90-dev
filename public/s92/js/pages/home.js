$(document).ready(function() {
  var v = $("#a-next").prop("href");
  if (v == null || v == "") {
    alert("Error, next link is not defined");
  } else {
    navigateInner($("#a-next").prop("href"));
  }
});
