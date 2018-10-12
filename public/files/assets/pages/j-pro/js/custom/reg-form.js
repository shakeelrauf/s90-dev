$(document).ready(function(){
			// Validation

$("#new-artist").validate({
      rules: {
       
        "person_artist[email]": {
        	required: true,
        	email: true
        },
        "person_artist[first_name]": {
        	required: true
        },
        "person_artist[last_name]": {
        	required: true
        }

      },
      messages: {
        "person_artist[email]": {
        	required: "PLease enter email",
        	email: "PLease enter valid email"
        }
      }
    });
});


