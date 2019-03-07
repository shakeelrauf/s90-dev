$(document).ready(function(){
			// Validation

$("#new-artist").validate({
      rules: {
       
        "person_artist[email]": {
          email: true
        },
        "person_artist[first_name]": {
          required: true
        }

      },
      messages: {
        "person_artist[email]": {
          email: "PLease enter valid email"
        }
      }
    });
$("#new-manager").validate({
      rules: {
       
        "person_manager[email]": {
          email: true
        },
        "person_manager[first_name]": {
          required: true
        },
        "person_manager[last_name]": {
          required: true
        }

      },
      messages: {
        "person_manager[email]": {
          email: "PLease enter valid email"
        }
      }
    });
});


