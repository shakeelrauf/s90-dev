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
    $("body").on("click", ".ajaxLink", function(e){
        e.preventDefault()
        var url = $(this).attr("href");
        if(url != undefined){
            window.history.pushState('page', 'Title', url);
            $(".loader").show()
            ajaxRequestToGetAllContentOfURL(url)
        }
    })
    $("body").on("submit",".searhAjax", function(e){
        e.preventDefault();
        var url = $(this).attr("action") + "?q=" + $(this).find('input[name="q"]').val();;
        if(url != undefined){
            window.history.pushState('page', 'Title', url);
            $(".loader").show()
            ajaxRequestToGetAllContentOfURL(url)
        }
    });

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

    $(".play-album").click(function (e) {
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
                        }
                    }
                }
            })
        }
    })

    $('.song-likes').click(function (e) {
        e.preventDefault()
        var sid = $(this).data("id"),
            liked = $(this).data("liked");
        likeOrDislikeSong(sid, liked)
    })

    $('.album-likes').click(function (e) {
        e.preventDefault()
        var aid = $(this).data("id"),
            liked = $(this).data("liked");
        likeOrDislikeAlbum(aid, liked)
    })

    $('.playlist-likes').click(function (e) {
        e.preventDefault()
        var sid = $(this).data("id"),
            liked = $(this).data("liked");
        likeOrDislikePlaylist(sid, liked)
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
        }
    })
    $("#the_form").submit(function(e){
        e.preventDefault();
        if($("#the_form").valid()){
            var sId = $("#the_form").data("sid"),
                title = $("#nameOfPlaylist").val();
            addNewplaylist(title,sId, function(){
                addSongToPlaylsit(sId)
            })
            $("#newPlaylist").modal("hide")
            location.reload();
        }
    })
    $(".add-new-playlist").click(function(){
        $("#the_form").submit()
    })
})