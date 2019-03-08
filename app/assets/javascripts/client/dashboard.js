$(document).ready(function () {
  runJs();
  jQuery.validator.addMethod("noSpace", function(value, element) { 
    return (value.trim(' ') != "") && value != ""; 
  }, "Don't leave it empty");

});
$("body").on("click", ".ajaxLink", function(e){
  mainJS()
  runJs();
})
function runJs(){
    $("body").on("click", ".song_image", function(e){
      e.preventDefault()
      var data = $(this).data("json"),
          sid = data.id;
      // resetPlayer()
      if($("#currentSong").length == 0){
        getPlayer(sid)
      }else{
        changeButtonType(btnPlayPause, 'icon-play')
        updateStickyPlayer(data)
        changeButtonType(btnPlayPause, 'icon-pause')
        runNewSong(sid)
      }
    })

    $("body").on("click", ".ajaxLink", function(e){
      e.preventDefault()
      $('.ajax-loader').css("visibility", "visible");
      var url = $(this).attr("href");
      if(url != undefined){
          window.history.pushState('page', 'Title', url);
          $(".loader").show()
          ajaxRequestToGetAllContentOfURL(url)
      }
    })
    $("body").on("submit",".searhAjax", function(e){
      e.preventDefault();
      $('.ajax-loader').css("visibility", "visible");
      var url = $(this).attr("action") + "?q=" + $(this).find('input[name="q"]').val();;
      if(url != undefined){
          window.history.pushState('page', 'Title', url);
          $(".loader").show()
          ajaxRequestToGetAllContentOfSearch(url);
      }
    });

    $("body").on("click", ".playlist-songs", function(e){
       e.preventDefault();
      if(songs.length == 0){
          doGrowlingWarning("Nothing to play")

      }else {
          var sid = songs[0].id;
          $("#currentSong").attr("data-listofsongs", songs)
          songList = songs
          if($("#currentSong").length == 0){
              getPlayer(sid)
          }else{
              changeButtonType(btnPlayPause, 'icon-play')
              updateStickyPlayer(songs)
              changeButtonType(btnPlayPause, 'icon-pause')
              runNewSong(sid)
          }
      }
    })

    $("body").on("click",".play-album", function(e){
      e.preventDefault();
      var $this = $(this),
          id = $this.data("id"),
          url =  $this.data("url");
      if(url != undefined){
        $.ajax({
          url: url,
          success: function(res){
              songs = res.songs;
              if(songs.length == 0){
                  doGrowlingWarning("Nothing to play")
              }else {
                  var sid = songs[0].id;
                  $("#currentSong").attr("data-listofsongs", songs)
                  songList = songs
                  if($("#currentSong").length == 0){
                      getPlayer(sid)
                  }else{
                      changeButtonType(btnPlayPause, 'icon-play')
                      updateStickyPlayer(songs)
                      changeButtonType(btnPlayPause, 'icon-pause')
                      runNewSong(sid)
                  }
              }
          }
        })
      }
    })
   
    $('body').on("click", ".song-likes",function (e) {
      e.preventDefault()
      var sid = $(this).data("id"),
          liked = $(this).data("liked");
      likeOrDislikeSong(sid, liked, $(this))
    })

    $('body').on("click", ".album-likes",function (e) {
      e.preventDefault()
      var aid = $(this).data("id"),
          liked = $(this).data("liked");
      likeOrDislikeAlbum(aid, liked)
    })

    $('.body').on("click", ".playlist-likes", function (e) {
      e.preventDefault()
      var sid = $(this).data("id"),
          liked = $(this).data("liked");
      likeOrDislikePlaylist(sid, liked)
    })
    $('body').on('shown.bs.modal',"#myPlaylists", function () {
      loadPlaylists()
    })
    $("body").on("click", ".song_id", function(e){
      $(".list-of-playlists").attr("data-sid", $(this).data("id"))  
    })
    $("#the_form").validate({
      rules: {
        nameOfPlaylist: {
          required: true,
          noSpace: true
        }
      },
      submitHandler: function(form) {
        var aId = $("#the_form").data("aid"),
         sId = $("#the_form").data("sid"),
            title = $("#nameOfPlaylist").val();
        addNewplaylist(title,sId,aId, function(){
            addSongToPlaylsit(sId)
        })
        $("#newPlaylist").modal("hide")
        return false;  // block the default submit action
      }
    })
    
    $("body").on('click', '.add-new-playlist',function(e){
      e.preventDefault();
      $("#the_form").submit()
    })

    $("#the_form_1").validate({
      rules: {
          nameOfAlbum: {
              required: true
          }
      }
    })
    $("body").on('submit', "#the_form_1",function(e){
      e.preventDefault();
      if($("#the_form_1").valid()){
          var aId = $("#the_form_1").data("aid"),
           sId = $("#the_form_1").data("sid"),
              title = $("#nameOfAlbum").val();
              year = $("#yearOfAlbum").val();
          addNewalbum(title,sId,aId, function(){
              addSongToPlaylsit(sId)
          })
          $("#newAlbum").modal("hide")
          setTimeout(
            function() 
            {
              location.reload();
            }, 1000);
      }
    })
    $("body").on('click', '.add-new-album', function(){
        $("#the_form_1").submit()
    })
}