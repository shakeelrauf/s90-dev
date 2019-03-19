navigator.geolocation.getCurrentPosition((position) => {
  localStorage.setItem("lat", position.coords.latitude)
  localStorage.setItem("lng", position.coords.longitude)
    send_coords();
});
navigator.permissions.query({name: 'geolocation'}).then(function(status) {
  if(status.state == "granted"){
    send_coords();
  }
});
function send_coords(){
  $.ajax({
    url: "/set_coords",
    data: {lat: localStorage.getItem("lat"), lng: localStorage.getItem("lng")},
    mehod: "get",
    success: function res(res){
    }
  });
}