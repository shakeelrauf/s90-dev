$(document).ready(function() {

  $("#btn-signin").click(function() {
    data = "field_email=" + $("input[name=field_email]").val();
    data += "&field_pw=" + $("input[name=field_pw]").val();
    apost("/sec/auth", data, function(j) {
      if (j.res == 'ok') {
        document.location = "/home";
      } else {
        notify("center", "center", "", "inverse",
               "animated fadeIn", "animated fadeOut",
               "", j.res);
      }
    });
  });

  $("input[name=field_email]:first").focus();

  $("#field_email").rules( "add", {
		 required: true,
		 minlength: 2,
		 maxlength: 100
	});
	$("#field_password").rules( "add", {
		 required: true,
		 minlength: 2,
		 maxlength: 100
	});

});
