
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


    $(".del_pic").on("click", function (e) {
        e.preventDefault()

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
        if(img != undefined) {
            var pid = $(".pid").data("pid")
            $.ajax({
                url: '/a/sp_base',
                data: {files: img, pid: pid},
                type: 'POST',
                success: function (res) {
                    $("img#profile_pic" + pid).attr("src", res["image_url"])
                    $(".images-ul").prepend(res["image_html"])
                }
            })
            console.log(img)
        }
    });
};