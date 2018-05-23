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
          $(".btn-songs").click(function() {
            document.location = "/al/s/" + $("#pid").val() + "/" + $(this).data('album');
          });
          $(".btn-cover").click(function() {
            document.location = "/al/cover/" + $("#pid").val() + "/" + $(this).data('album');
          });
  		   }
      }
  });
});
