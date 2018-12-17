'use strict';
$(document).ready(function() {


  $("#btn-manager-new").click(function() {
    document.location.href = "/ad/manager_new";
  })


  $(".footable-page").on("click", function() {
    window.scrollTo(0, 0);
  })
  $(".footable-page-link").on("click", function() {
    window.scrollTo(0, 0);
  })

  $(".btn-albums").click(function() {
    document.location = "/al/my/" + $(this).data('artist');
  });
  $(".footable-page").on("click", function() {
    window.scrollTo(0, 0);
  })
  $(".footable-page-link").on("click", function() {
    window.scrollTo(0, 0);
  });

 
  $(".btn-reinitial-manager").click(function() {
    console.log("ASsa")

    var $this = $(this);
    var id = $this.data("manager");
    $.ajax({
      url: '/ad/person/reinitialize_password',
      method: 'get',
      data: {
        id: id
      },
      success: function() {
        $this.css({
          "background-color": "red"
        });
      }
    })

  });
});
