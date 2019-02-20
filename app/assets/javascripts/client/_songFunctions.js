function updateStickyPlayer(data) {
    $("#song_title").html(data.title)
    $("#artist_name").html(data.artist_name)
    $("#album_name").html(data.album_name)
    $("#player_image").attr("src",data.pic)
    $("#stickylike").data("id", data.id)
    $("#stickylike").attr("class", " ")
    $("#stickylike").addClass("songlike"+data.id)
    $(".songlike"+data.id).data("liked", data.liked)
    if(data.liked== true){
        $(".songlike"+data.id).children("i").removeClass("icon-hearth").addClass("fas fa-heart")
    }else{
        $(".songlike"+data.id).children("i").removeClass("fas fa-heart").addClass("icon-hearth")
    }
}

function loadPlaylists(){
    $.ajax({
        url: '/client/get_profile',
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
        url: '/client/songs/get_playable_url',
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

function playSong(song){
    $(".player-sticky").attr("data-src", song.download_link)
    // play song function will be replaced in future
}

function likeOrDislikeSong(oid, liked){
    if(liked == true){
        dislike("song", oid, liked)
    }else{
        like("song", oid, liked)
    }
}

function like(ot,oid, liked){
    $(".songlike"+oid).children("i").removeClass("icon-hearth").addClass("fas fa-heart")
    $.ajax({
        url: '/client/songs/like',
        method: 'post',
        data: {ot: ot, oid: oid},
        success:  function(res){
            $(".songlike"+oid).data("liked", true)
        }
    })
}

function dislike(ot,oid, liked){
    $(".songlike"+oid).children("i").removeClass("fas fa-heart").addClass("icon-hearth")
    $.ajax({
        url: '/client/songs/dislike',
        method: 'post',
        data: {ot: ot, oid: oid},
        success:  function(res){
            $(".songlike"+oid).data("liked", false)

        }
    })
}


function addNewplaylist(title,sid, callback) {
    $.ajax({
        url: '/client/songs/create_playlist',
        data: {title: title},
        method: 'post',
        success: function(res){
            debugger
            if(callback)
            callback(sid,arguments[0],res.playlist.id)
        }
    })
}
