'use strict';
// $(document).ready(function() {
//   pageSpecificReady();
// });

// For the inner navigation
// function pageSpecificReady() {
$(document).ready(function() {
  // debugger;
  // var song_remove = localStorage.getItem('song_remove');
  // if (song_remove == true) {
  //   $('#song-detail').click();
  //   localStorage.removeItem('song_remove');
  // }
  var a = localStorage.getItem('song-save');
  if (a == 'true') {
    localStorage.clear();
    $('.btn-songs').click();
  }

  var b = localStorage.getItem('song-del');
  if (b == 'true') {
    localStorage.clear();
    $('.btn-songs').click();
  }

  $( "#btn-save" ).click(function() {
    localStorage.setItem('song-save', true);
    location.reload();
  });

  $('#table-albums').footable({
      "paging": {
          "enabled": true
      },
      "sorting": {
          "enabled": true
      },
      "on": {
  			"ready.ft.table": function(e, ft) {
          $(".btn-songs").click(function() {
            // document.location = "/al/s/" + $("#pid").val() + "/" + $(this).data('album');
            navigateInner("/al/s/" + $("#pid").val() + "/" + $(this).data('album'));
          });
          $(".btn-cover").click(function() {
            // document.location = "/al/cover/" + $("#pid").val() + "/" + $(this).data('album');
            navigateInner("/al/cover/" + $("#pid").val() + "/" + $(this).data('album'));
          });
  		   }
      }
  });

  $("#btn-new-release").click(() => {
    // document.location = "/album/newr/" + $("#pid").val();
    navigateInner("/album/newr/" + $("#pid").val());
  });

  var song_id = $(".delete-song").data("song");
  $("#delete-song-"+song_id).click(function(){
    console.log("ASsa")

    var $this =  $(this);
    var a = $this.parent().parent();
     var id = $this.data("song");
    $.ajax({
      url: '/al/remove_song',
      method: 'POST',
      async: true,
      data: {id: id},
      success: function(){
        alert("Song sucessfully delete");
        a.remove();
        localStorage.setItem('song-del', true);
        location.reload();
      }
    })

  });

});
