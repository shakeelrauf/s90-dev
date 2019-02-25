$(document).ready(function () {
    $(".song_image").on('click', function(e){
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
    $(".playlist-songs").on("click", function(e){
        e.preventDefault();
        if(songs.length == 0){
            doGrowlingWarning("Nothing to play")

        }else {
            var sid = songs[0].id;
            $("#currentSong").attr("data-listofsongs", songs)
            songList = songs
            if($("#currentSong").length == 0){
                getPlayer(sid)
            }
        }
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
    $("#the_form").validate({
        rules: {
            nameOfPlaylist: {
                required: true
            }
        },
        submitHandler: function(){
            var sId = $("#the_form").data("sid"),
                title = $("#nameOfPlaylist").val();
            if($(this).valid()){
                addNewplaylist(title,sId, function(){
                    addSongToPlaylsit(sId)
                })
                $("#newPlaylist").modal("hide")
            }
        }
    })
    $(".add-new-playlist").click(function(){
        $("#the_form").submit()
    })
})