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
    console.log("ASsa")

    var $this =  $(this);
     var id = $this.data("artist");
    $.ajax({
      url: '/ad/person/reinitialize_password',
      method: 'get',
      data: {id: id},
      success: function(){
        $this.css({"background-color" : "red"});
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