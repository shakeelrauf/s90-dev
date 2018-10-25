'use strict';
$(document).ready(function() {
  var call_back =  function(){
  $(".btn-albums").click(function() {
    document.location = "/al/my/" + $(this).data('artist');
  });
  $(".footable-page").on("click", function(){
    window.scrollTo(0, 0);
  })
  $(".footable-page-link").on("click", function(){
    window.scrollTo(0, 0);
  })
  $(".btn-reinitial").click(function(){

    var $this =  $(this);
     var id = $this.data("artist");
    $.ajax({
      url: '/ad/person/reinitialize_password',
      method: 'get',
      data: {id: id},
      success: function(res){
        if(res["res"] == "ok"){
          var ref = $this;        
          var popup = $('#popup');
          popup.html("Password reset email sent");
          var popper = new Popper(ref, popup, {
              placement: 'top'
          });
          $("#popup").show()
          
          $('#popup').fadeOut(5000);
        }
        else{

          var ref = $this;        
          var popup = $('#popup');
          popup.html("Something went wrong");
          var popper = new Popper(ref,popup,{
             placement: 'top'
                                  
          });
          $("#popup").show();

          $('#popup').fadeOut(5000);
        }
      }
    })

  });
  $(".btn-reinitial-manager").click(function(){
    console.log("ASsa")

    var $this =  $(this);
     var id = $this.data("manager");
    $.ajax({
      url: '/ad/person/reinitialize_password',
      method: 'get',
      data: {id: id},
      success: function(){
        $this.css({"background-color" : "red"});
      }
    })

  });
}
  $('.table').footable({
      "paging": {
          "enabled": true
      },
      "sorting": {
          "enabled": true
      },
      "on": {
  			"ready.ft.table": function(e, ft) {
          call_back();
  		   },
         "after.ft.paging": function(e,ft){
          call_back();
         }
      }
  });

  $("#btn-artist-new").click(function() {
    document.location.href = "/ad/artist_new";
  })
  $("#btn-manager-new").click(function() {
    document.location.href = "/ad/manager_new";
  })


});
$(document).on('page:change', function() {
    // your stuff here
});
$(".footable-page").on("click", function(){
  window.scrollTo(0, 0);
})
$(".footable-page-link").on("click", function(){
  window.scrollTo(0, 0);
})

