$(document).ready(function() {
  $("#btn-signin").click(function() {
    data = "email=" + $("input[name=email]").val();
    data += "&password=" + $("input[name=password]").val();
    apost("/sec/auth", data, function(j) {
        document.location = "/home";
    });
  });

  $("input[name=email]:first").focus();
});
