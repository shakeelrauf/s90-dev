    
  var form = $("#newform");
  form.validate({
      errorPlacement: function errorPlacement(error, element) {  },
      rules: {
          "person[fname]": {
              required: true
          },
          "person[lname]": {
              required: true
          },
          "person[email]": {
              required: true,
              email: true
          },
          "person[pw]": {
              required: true,
              minlength : 6
          },
          "person[pw_confirmation]": {
              required: true,
              minlength : 6,
              equalTo : "#exampleInputPassword"
          },
      }
  });
  $("#example-basic").steps({
      headerTag: "h3",
      bodyTag: "section",
      transitionEffect: "slideLeft",
      autoFocus: true,
      onStepChanging: function (event, currentIndex, newIndex)
      {
          form.validate().settings.ignore = ":disabled,:hidden";
          return form.valid();
      },
      onFinishing: function (event, currentIndex)
      {
          form.validate().settings.ignore = ":disabled";
          return form.valid();
      },
      onFinished: function (event, currentIndex)
      {
           var form = $(this);
          form.parents('form').submit();
      }
  });

  $(".role_btn").on('click',function () {
    var $this = $(this);
    $('.role_btn').css({"background-color" : "#545b62"})
    $this.css({"background-color" : "#393b3e"});
    $this.siblings().attr('checked', true)
    $("#newform input[type='radio']:checked").val();
  })
  $('.role_btn').css({"background-color" : "#545b62"})
  $("#newform input[type='radio']:checked").siblings('.role_btn').css({"background-color" : "#393b3e"});