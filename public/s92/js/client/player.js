
var rotation = 0;

var player = document.getElementById('music'); // id for audio element
var duration; // Duration of audio clip
btnPlayPause = document.getElementById('btnPlayPause');
btnMute      = document.getElementById('btnMute');
progressBar  = document.getElementById('progress-bar');
volumeBar    = document.getElementById('volume-bar');
source       = document.getElementById('audioSource');
currentSongId = $('#currentSong').data("id");
// Update the video volume
if(volumeBar != undefined){
    volumeBar.addEventListener("change", function(evt) {function displayMessage(message, canPlay) {
        var element = document.querySelector('#message');
        element.innerHTML = message;
        element.className = canPlay ? 'info' : 'error';
    }
        player.volume = parseInt(evt.target.value) / 10;
    });
}



if(player != undefined){
    // Add a listener for the timeupdate event so we can update the progress bar
    player.addEventListener('timeupdate', updateProgressBar, false);

// Add a listener for the play and pause events so the buttons state can be updated
    player.addEventListener('icon-play', function() {
        // Change the button to be a pause button
        changeButtonType(btnPlayPause, 'icon-pause');
    }, false);

    player.addEventListener('icon-pause', function() {
        // Change the button to be a play button
        changeButtonType(btnPlayPause, 'icon-play');
    }, false);

    player.addEventListener('volumechange', function(e) {
        // Update the button to be mute/unmute
        if (player.muted) changeButtonType(btnMute, 'fas fa-volume-off');
        else changeButtonType(btnMute, 'ico-volume');
    }, false);

    player.addEventListener('ended', function() { this.pause(); }, false);

    progressBar.addEventListener("click", seek);

    function seek(e) {
        if (player.src) {
            var percent = e.offsetX / this.offsetWidth;
            player.currentTime = percent * player.duration;
            e.target.value = Math.floor(percent / 100);
            e.target.innerHTML = progressBar.value + '% played';
        }
    }

    function playPauseAudio() {
        if (player.src) {
            if (player.paused || player.ended) {
                // Change the button to a pause button
                changeButtonType(btnPlayPause, 'icon-pause');
                player.play();
            }
            else {
                // Change the button to a play button
                changeButtonType(btnPlayPause, 'icon-play');
                player.pause();
            }
        }
    }

    function nextSong(event){
        var count = songList.length
        for(let index in songList){
            index = parseInt(index)
            if(count == 1){

                resetPlayer()
                updateStickyPlayer(songList[index])
                runNewSong(songList[index].id)
                changeButtonType(btnPlayPause, 'icon-pause');
                // player.play();
                break;
            }else{
                if (songList[index].id == currentSongId){
                    if(count-1 == index){
                        navigateToAllSongs()
                        resetPlayer()
                        updateStickyPlayer(songList[0])
                        runNewSong(songList[0].id)
                        currentSongId = songList[0].id
                        changeButtonType(btnPlayPause, 'icon-pause');
                        // player.play();
                        break;
                    }else{
                        updateStickyPlayer(songList[index+1])
                        runNewSong(songList[index+1].id)
                        currentSongId = songList[index+1].id
                        // player.play();
                        break ;
                    }
                }
            }
        }
    }

    function prevSong(){
        var count = songList.length
        for(let [index,song] in songList){
            if(count == 1){
                resetPlayer()
                updateStickyPlayer(songList[index])
                runNewSong(songList[index].id)
                changeButtonType(btnPlayPause, 'icon-pause');
                break;
            }else{
                if (songList[index].id == currentSongId){
                    if(index == 0){
                        resetPlayer()
                        updateStickyPlayer(songList[count-1])
                        runNewSong(songList[count-1].id)
                        currentSongId = songList[count-1].id
                        changeButtonType(btnPlayPause, 'icon-pause');
                        break;
                    }else{
                        updateStickyPlayer(songList[index - 1])
                        currentSongId = songList[index - 1].id
                        runNewSong(songList[index - 1].id)
                        break;

                    }
                }
            }
        }
    }

// Stop the current media from playing, and return it to the start position
    function stopAudio() {
        if (player.src) {
            player.pause();
            if (player.currentTime) player.currentTime = 0;
        }
    }

// Toggles the media player's mute and unmute status
    function muteVolume() {
        if (player.src) {
            if (player.muted) {
                // Change the button to a mute button
                changeButtonType(btnMute, 'ico-volume');
                player.muted = false;
            }
            else {
                // Change the button to an unmute button
                changeButtonType(btnMute, 'fas fa-volume-off');
                player.muted = true;
            }
        }
    }

// Replays the media currently loaded in the player
    function replayAudio() {
        if (player.src) {
            resetPlayer();
            player.play();
        }
    }

// Update the progress bar
    function updateProgressBar() {
        // Work out how much of the media has played via the duration and currentTime parameters
        var percentage = Math.floor((100 / player.duration) * player.currentTime);
        // Update the progress bar's value
        progressBar.value = percentage;
        if(percentage == 100){
            console.log("ended playing next song")
            nextSong()
        }
        jQuery.fn.rotate = function(degrees) {
            $(this).css({'-webkit-transform' : 'rotate('+ degrees +'deg)',
                '-moz-transform' : 'rotate('+ degrees +'deg)',
                '-ms-transform' : 'rotate('+ degrees +'deg)',
                'transform' : 'rotate('+ degrees +'deg)'});
        };

        rotation += 5;
        $(".player__image").rotate(rotation);
        progressBar.innerHTML = progressBar.title = percentage + '% played';
    }
    $('input[type=range]').on('input', function(e){
        var min = e.target.min,
            max = e.target.max,
            val = e.target.value;

        $(e.target).css({
            'backgroundSize': (val - min) * 100 / (max - min) + '% 100%'
        });
    }).trigger('input');

// Updates a button's title, innerHTML and CSS class
    function changeButtonType(btn, value) {
        btn.title     = value;
        btn.className = value;
    }

    function resetPlayer() {
        progressBar.value = 0;
        //clear the current song
        player.src = '';
        // Move the media back to the start
        player.currentTime = 0;
        // Set the play/pause button to 'play'
        changeButtonType(btnPlayPause, 'icon-play');
    }

    function displayMessage(message, canPlay) {
        var element = document.querySelector('#message');
        element.innerHTML = message;
        element.className = canPlay ? 'info' : 'error';
    }
}
