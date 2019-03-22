    var genre = $("#genre-data").data("rec");
      $('#input-tags').selectize({
        maxItems: 5,
        valueField: 'id',
        labelField: 'name',
        searchField: 'name',
        options: genre,
        create: false
      });
      function select2Artist(){
        if($("select[name=artist_id]").length != 0){
          $("select[name=artist_id]").select2({
              tags: false,
              dataType: 'json',
              ajax: {
                  url: '/artist/search',
                  data: function (params) {
                      var query = {
                          search: params.term||"",
                          offset: params.page||0,
                          limit: 10
                      }
                      return query;
                  }
              }
          });
          $("select[name=artist_id]").on('select2:select', function (e) {
              var artistId = $(this).select2('data')[0].id;
              var songId = $(this).data("song");
              if(Number.isInteger(Number(artistId))){
                 $.ajax({
                  url: "/songs",
                  type: "post",
                  data: {"field": "artist_id", "value": artistId, "id": songId}
                 })
              }
          });
        }
      }
      select2Artist()
      $("#btn-save-compilation").on("click", function(e){
        if($("#form_of").valid()){
          let data = $("#form_of").serialize();
          let id = $("#id").data("id");
            aput("/admin/compilations/"+id, data, (j) => {
                  doGrowling("saved!", "success")

           });
      }

      })