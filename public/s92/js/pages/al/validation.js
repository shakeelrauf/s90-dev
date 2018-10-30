   $(document).ready(function(){

      if ($("#the_form") && $("#the_form").length > 0) {
        $("#the_form").validate({
          rules: {
            field_year: {
              required: true,
              min: 1901
            },
            field_name: {
              required: true
            }
          },
          messages: {
            field_year: {
              min: "Release year should be greater than 1900"
            }
          }
        });
      }  
    });
