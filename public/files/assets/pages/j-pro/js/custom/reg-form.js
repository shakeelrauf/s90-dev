$(document).ready(function(){
			// Validation

$("#new-artist").validate({
      rules: {
       
        "person_artist[email]": {
        	required: true,
        	email: true
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


