'use strict';
$(document).ready(function() {
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


});
$(document).on('page:change', function() {
    // your stuff here
});

var call_back =  function(){
  $(".btn-albums").click(function() {
    document.location = "/al/my/" + $(this).data('artist');
  });
  $(".btn-reinitial").click(function(){
    console.log("ASsa")

    var $this =  $(this);
     var id = $this.data("artist");
    $.ajax({
      url: '/ad/artist/reinitialize_password',
      method: 'get',
      data: {id: id},
      success: function(){
        $this.css({"background-color" : "red"});
      }
    })

  });
}