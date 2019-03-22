 $(".btn-suspend-compilation").click(function(){
    var $this =  $(this);
     var id = $this.data("id");
    $.ajax({
      url: '/admin/compilations/suspend',
      method: 'POST',
      async: true,
      data: {id: id},
      success: function(){
        if ($this.text().replace(/\s/g, '') == "Unsuspend"){
          $this.text("Suspend");
        }
        else{
          $this.text("Unsuspend"); 
        }
      }
    })
  });
  $(window).load(function ()
  {
      setInterval(function ()
      {
          if($(".footable-first-visible").text()=="TitleNo results"){
              $("tfoot").remove();
              $(".fooicon-plus").remove();
          }
      }, 10);
  });


  $(".footable-detail-row").remove();