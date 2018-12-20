
/* Named function used in jquery.fileuploads.s92.js */
function getUploadData() {
  //alert("getUploadData");
  var h = getCSRFHash()
  h["pid"] = $("#pid").val();
  return h;
}

$(document).ready(function(){
	'use-strict';
  initFiler($("#filer_input"));


    $(".del_pic").on("click", function () {
        var $this = $(this),
            id =  $this.data("id");
        $.ajax({
            url: '/images/del_img',
            type: 'POST',
            data: {id: id},
            success:  function () {
                debugger
                $("#img"+id).remove()
            }
        })
    })
});

window.onload = function() {
    var options, preview;
    preview = $('.cropit-preview');
    options = {
        allowDragNDrop: false,
        '$preview': preview
    };
    this.imageEditor = this.$('#image-cropper');
    var img = this.imageEditor.cropit(options);
    return this.$('.export').on('click', function(img){
        img = $('#image-cropper').cropit("export", {
            type: 'image/jpeg',
            quality: 0.33,
            originalSize: true,
        });
        console.log(img)
    });
};