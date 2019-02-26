function updateStickyPlayer(data) {
    $("#song_title").html(data.title)
    $("#artist_name").html(data.artist_name)
    $("#album_name").html(data.album_name)
    $("#player_image").attr("src",data.pic)
    $("#stickylike").attr("data-id", data.id)
    $("#stickylike").attr("class", "song-likes")
    $("#stickylike").addClass("songlike"+data.id)
    $(".songlike"+data.id).data("liked", data.liked)
    currentSongId = data.id;
    if(data.liked== true){
        $(".songlike"+data.id).children("i").removeClass("icon-hearth").addClass("fas fa-heart")
    }else{
        $(".songlike"+data.id).children("i").removeClass("fas fa-heart").addClass("icon-hearth")
    }
}

function loadPlaylists(){
    $.ajax({
        url: '/client/profile',
        success: function(res){
            $(".list-of-playlists").empty()
            res.data.playlists.forEach(function(li){
                var list = "<div class='song add_to_playlist' data-id='"+li.id+"'> <div class='song__body'> <div class='song__content'>"+ li.title+ "</div> </div> </div>"
                // var list = "<li>"+ li.title + "</li>"
                $(".list-of-playlists").append(list);

            })
            addClickListenOnPlaylist()
        }
    })
}

function addClickListenOnPlaylist(){
    $(".add_to_playlist").on("click", function(e){
        e.preventDefault()
        var pId = $(this).data("id"),
            sId = $(this).parent().data("sid");

        addSongToPlaylsit(sId, pId);
    })
}

function addSongToPlaylsit(sId, pId){
    $.ajax({
        url: '/client/songs/add_to_playlist',
        method: 'post',
        data: {song_ids: [sId], playlist_id: pId},
        success: function(res){
            $("#myPlaylists").modal("hide")
            doGrowlingMessage("Saved")
        }
    })
}

function runNewSong(sid){
    $.ajax({
        url: '/client/songs/playable_url',
        method: "post",
        data: {sid: sid},
        success: function (res) {
            updateStickyPlayer(res.song);
            if(res.found_on_dropbox == true)
                playSong(res)
        },
        error: function(res){
        }
    })
}

function getPlayer(sid) {
    $.ajax({
        url: '/client/songs/sticky_player',
        data: {sid: sid},
        method: 'post',
        success: function (res) {
            $("body").append(res)
            updatePlayList(songs)
            $('.song-likes').click(function (e) {
                e.preventDefault()
                var sid = $(this).data("id"),
                    liked = $(this).data("liked");
                likeOrDislikeSong(sid, liked)
            })
        }
    })
}

function updatePlayList(songs){
    $("#currentSong").attr("data-listofsongs", songs)
    songList = songs
}

function playSong(song){
    $("#music").attr("src", song.download_link)
    $(".player-sticky").attr("data-src", song.download_link)
    // play song function will be replaced in future
}

function likeOrDislikeSong(oid, liked){
    if(liked == true){
        dislike("song", oid, liked, $(".songlike"+oid))
    }else{
        like("song", oid, liked, $(".songlike"+oid))
    }
}


function likeOrDislikeAlbum(oid, liked){
    if(liked==true){
        dislike("album", oid, liked, $(".albumlike"+oid))
    }else{
        like("album", oid, liked, $(".albumlike"+oid))
    }
}

function like(ot,oid, liked, div){
    div.children("i").removeClass("icon-hearth").addClass("fas fa-heart")
    $.ajax({
        url: '/client/like',
        method: 'post',
        data: {ot: ot, oid: oid},
        success:  function(res){
            div.data("liked", true)
        }
    })
}

function dislike(ot,oid, liked, div){
    div.children("i").removeClass("fas fa-heart").addClass("icon-hearth")
    $.ajax({
        url: '/client/dislike',
        method: 'post',
        data: {ot: ot, oid: oid},
        success:  function(res){
            div.data("liked", false)

        }
    })
}

function likeOrDislikePlaylist(oid, liked){
    if(liked == true){
        dislike_playlist("playlist", oid, liked)
    }else{
        like_playlist("playlist", oid, liked)
    }
}

function like_playlist(ot,oid, liked){
    $(".playlistlike"+oid).children("i").removeClass("icon-hearth").addClass("fas fa-heart")
    $.ajax({
        url: '/client/songs/playlistlike',
        method: 'post',
        data: {ot: ot, oid: oid},
        success:  function(res){
            $(".playlistlike"+oid).data("liked", true)
        }
    })
}

function dislike_playlist(ot,oid, liked){
    $(".playlistlike"+oid).children("i").removeClass("fas fa-heart").addClass("icon-hearth")
    $.ajax({
        url: '/client/songs/playlistdislike',
        method: 'post',
        data: {ot: ot, oid: oid},
        success:  function(res){
            $(".playlistlike"+oid).data("liked", false)

        }
    })
}

function addNewplaylist(title,sid, callback) {
    $.ajax({
        url: '/client/songs/create_playlist',
        data: {title: title},
        method: 'post',
        success: function(res){
            $("#nameOfPlaylist").val(' ')
            if($(".playlists").length != 0){
                var html = res;
                $(".playlists").append(html)
            }
            if(callback)
            callback()
        }
    })
}
