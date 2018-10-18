'use strict';
$(document).ready(function() {
  $("#j-pro").submit(function(e) {
    e.preventDefault();

    apost("/ad/artist/validate_email", "email=" + $("#email").val(), (json)=> {
      if (json.res == 'ok') {
        apost("/ad/artist/artist_create", $("#j-pro").serialize(), (json)=> {
          if (json.id != null) {
            document.location.replace("/p/p/" + json.id);
          }
        });

        // Submit
      } else if (json.res == 'exists') {
        alert("A person with this email already exists");
      }
    });
  })
});
