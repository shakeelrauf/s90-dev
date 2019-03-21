'use strict';
// $(document).ready(function() {
//   pageSpecificReady();
// });

// For the inner navigation
// function pageSpecificReady() {
$(document).ready(function() {

$('.edit-name').editable({
     validate: function(value) {
          if($.trim(value) == '') return 'This value is required.';
      },
      type: 'text',
      url: '/songs',
      pk: 1,
      title: 'Enter Freight Value',
      params: function(params) {
          var id = $(this).data("id");
          var data = {};
          var name = $(this).data("name");
          data['field'] = name;
          data['value'] = params.value;
          data['id'] = id;
          return data;
      },
      ajaxOptions: {
          dataType: 'json'
      }
    });
  $('.edit-order').editable({
     validate: function(value) {
          if($.trim(value) == '') return 'This value is required.';
      },
      type: 'number',
      url: '/songs',
      pk: 1,
      title: 'Enter Freight Value',
      params: function(params) {
          var id = $(this).data("id");
          var data = {};
          Id = id;
          var name = $(this).data("name");
          data['field'] = name;
          data['value'] = params.value;
          data['id'] = id;
          return data;
      },
      ajaxOptions: {
          dataType: 'json'
      }
    });

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

  // $( "#btn-save" ).click(function() {
  //   localStorage.setItem('song-save', true);
  // });

  $("#btn-suspend").click(function(){
    var $this =  $(this);
     var id = $this.data("id");
    $.ajax({
      url: '/al/suspend_album',
      method: 'POST',
      async: true,
      data: {id: id},
      success: function(){
        if ($this.text().replace(/\s/g, '') == "Unsuspend"){
          $this.text("Suspend");
        }
        else{
          $this.text("Unsuspend"); 
        }
      }
    })
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
            get_url =  $(this).data("get"),
            imageurl =  $(this).data("imageurl"),
            coverOrProfile = $(this).data("coverprofile"),
            id =  $(this).data("id");
        if(coverOrProfile=="cover"){
            $("#exampleModalLongTitle").text("Upload Cover")
        }
        $("#images-ul").html('');
        $.ajax({
            url: get_url,
            data: {id: id},
            success: function (res) {
                if(res["msg"] == undefined){
                    $("#images-ul").append(res["images"])
                }
            }
        });
        $(".export").attr("data-url", url);
        $(".modal2").modal("toggle")
    })
  $("#btn-new-release").click(() => {
    // document.location = "/album/newr/" + $("#pid").val();
    navigateInner("/album/newr/" + $("#pid").val());
    $("#new_release").validate({
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
    });

  $(".delete-song").click(function(){

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

  $(".delete-album").click(function(){

    var $this =  $(this);
     var id = $this.data("id");
    $.ajax({
      url: '/al/remove_album',
      method: 'POST',
      async: true,
      data: {id: id},
      success: function(){
        document.location = "/al/my/" + $("#pid").val();

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
            if(img != undefined && $("#exampleModalLongTitle").text() == "Upload Cover") {
                var url = $(".export").attr("data-url")
                var pid = $(".pid").data("pid")
                $this.val("Please Wait..").attr("disabled",true)
                $.ajax({
                    url: url,
                    data: {files: img, pid: pid},
                    type: 'POST',
                    success: function (res) {
                        $(".export").val("Upload").attr("disabled",false)
                        $(".images-ul").prepend(res["image_html"])
                        $this.val("Upload").attr("disabled",false)
                    }
                })


            }
        });
    }
    if($(".export").length != 0 ){
        cropit();
    }
    
    $(".atrist_cover").click(function(){
      $(".cropit-preview-image").attr("src", "");
      $("#exampleModalLongTitle").text("Upload Cover");
      $("#cover_img").attr("src", $(this).attr("data-imageurl"));
      $("#filer_inputs").attr("data-url", $(this).attr("data-url"));
      $("#filer_inputs").attr("data-url-remove", $(this).attr("data-url"));
      $(".export").attr("data-url", $(this).attr("data-url"));
      $(".export").attr("data-url-remove", $(this).attr("data-url"));
      $(".cover_art").hide();
      $(".cvr-img").show();
      if ($(".cvr-img").find(".images-ul").length >= 1){
        $(".jFiler-item").hide();
      }
    });

    $(".atrist_profile").click(function(){
      $(".cropit-preview-image").attr("src", "");
      $("#exampleModalLongTitle").text("Profile Picture Upload");
      $(".cover_art").show();
      $(".cvr-img").hide();
      if ($(".cvr-img").find(".images-ul").length >= 1){
        $(".jFiler-item").show();
      }
    });

});
