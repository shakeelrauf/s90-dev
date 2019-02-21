$(document).ready(function () {
    $(".song_image").on('click', function(e){
        e.preventDefault()
        var data = $(this).data("json"),
            sid = data.id;
        // resetPlayer()
        changeButtonType(btnPlayPause, 'icon-play')
        updateStickyPlayer(data)
        changeButtonType(btnPlayPause, 'icon-pause')

        runNewSong(sid)
    })

    $('.song-likes').click(function (e) {
        e.preventDefault()
        var sid = $(this).data("id"),
            liked = $(this).data("liked");
        likeOrDislikeSong(sid, liked)
    })
    $('#myPlaylists').on('shown.bs.modal', function () {
        loadPlaylists()
    })

    $(".song_id").on("click", function(e){
        $(".list-of-playlists").attr("data-sid", $(this).data("id"))
    })

    $(".add-new-playlist").on("click", function(e){
        var sId = $("#the_form").data("sid"),
            title = $("#nameOfPlaylist").val();
        addNewplaylist(title,sId, function(){
            addSongToPlaylsit(sId)
        })
    })



})