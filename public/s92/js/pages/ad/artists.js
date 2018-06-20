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
          $(".btn-albums").click(function() {
            document.location = "/al/my/" + $(this).data('artist');
          });
  		   }
      }
  });

  $("#btn-artist-new").click(function() {
    document.location.href = "/ad/artist_new";
  })
});
