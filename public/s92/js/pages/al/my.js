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
    $(".uploadable").click(function (e) {
        e.preventDefault()
        var url = $(this).data("url"),
            imageurl =  $(this).data("imageurl");
        $(".export").attr("data-url", url);
        $("#cover_img").attr("src" , imageurl);
        $(".modal2").modal("toggle")
        // cropit()
    })
  $("#btn-new-release").click(() => {
    // document.location = "/album/newr/" + $("#pid").val();
    navigateInner("/album/newr/" + $("#pid").val());
  });

  $(".delete-song").click(function(){
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
        $("#row-no-"+id).remove()
      }
    })
    $("#exampleModal"+id).modal("hide");
  });
    var cropit = function(){
        var options, preview;
        preview = $('.cropit-preview');
        options = {
            allowDragNDrop: false,
            '$preview': preview
        };
        var imageEditor = $('#image-cropper');
        var img = imageEditor.cropit(options);
        $('.export').on('click', function(img){
            var $this = $(this)
            img = $('#image-cropper').cropit("export", {
                type: 'image/jpeg',
                quality: 0.33,
                originalSize: true,
            });
            if(img != undefined) {
                var url = $(".export").attr("data-url")
                var pid = $(".pid").data("pid")
                $this.val("Please Wait..").attr("disabled",true)
                $.ajax({
                    url: url,
                    data: {files: img, pid: pid},
                    type: 'POST',
                    success: function (res) {
                      debugger
                        $this.val("Upload").attr("disabled",false)
                        $("#cover_img").attr("src",res["image_url"])
                    }
                })


            }
        });
    }
    if($(".uploadable").length != 0){
        cropit();
    }


    $(".atrist_cover").click(function(){
      $("#cover_img").attr("src", $(this).attr("data-imageurl"));
      $("#filer_inputs").attr("data-url", $(this).attr("data-url"));
      $("#filer_inputs").attr("data-url-remove", $(this).attr("data-url"));
      $(".upload-img-btn").attr("data-url", $(this).attr("data-url"));
      $(".upload-img-btn").attr("data-url-remove", $(this).attr("data-url"));
      $(".cover_art").hide();
      $(".cvr-img").show();
    });

    $(".atrist_profile").click(function(){
      $(".cover_art").show();
      $(".cvr-img").hide();
    });

});
