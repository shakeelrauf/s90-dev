
function initFiler(f) {

		f.filer({
        limit: 25,
        maxSize: 45,
        extensions: null,
        changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Drag & Drop files here</h3> <span style="display:inline-block; margin: 15px 0">or</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Browse Files</a></div></div>',
        showThumbs: true,
        theme: "dragdropbox",
        templates: {
            box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
            item: '<li class="jFiler-item">\
                        <div class="jFiler-item-container">\
                            <div class="jFiler-item-inner">\
                                <div class="jFiler-item-thumb">\
                                    <div class="jFiler-item-status"></div>\
                                    <div class="jFiler-item-info">\
                                        <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
                                        <span class="jFiler-item-others">{{fi-size2}}</span>\
                                    </div>\
                                    {{fi-image}}\
                                </div>\
                                <div class="jFiler-item-assets jFiler-row">\
                                    <ul class="list-inline pull-left">\
                                        <li>{{fi-progressBar}}</li>\
                                    </ul>\
                                    <ul class="list-inline pull-right">\
                                        <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
                                    </ul>\
                                </div>\
                            </div>\
                        </div>\
                    </li>',
            itemAppend: '<li class="jFiler-item">\
                            <div class="jFiler-item-container">\
                                <div class="jFiler-item-inner">\
                                    <div class="jFiler-item-thumb">\
                                        <div class="jFiler-item-status"></div>\
                                        <div class="jFiler-item-info">\
                                            <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
                                            <span class="jFiler-item-others">{{fi-size2}}</span>\
                                        </div>\
                                        {{fi-image}}\
                                    </div>\
                                    <div class="jFiler-item-assets jFiler-row">\
                                        <ul class="list-inline pull-left">\
                                            <li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
                                        </ul>\
                                        <ul class="list-inline pull-right">\
                                            <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
                                        </ul>\
                                    </div>\
                                </div>\
                            </div>\
                        </li>',
            progressBar: '<div class="bar"></div>',
            itemAppendToEnd: false,
            removeConfirmation: true,
            _selectors: {
                list: '.jFiler-items-list',
                item: '.jFiler-item',
                progressBar: '.bar',
                remove: '.jFiler-item-trash-action'
            }
        },
        dragDrop: {
            dragEnter: null,
            dragLeave: null,
            drop: null,
        },
        uploadFile: {
            url: f.data('url'),
            data: (getUploadData != null ? getUploadData() : null),
            type: 'POST',
            enctype: 'multipart/form-data',
            beforeSend: function(){},
            success: function(data, el){
              var parent = el.find(".jFiler-jProgressBar").parent();
              el.find(".jFiler-jProgressBar").fadeOut("slow", function(){
                $("<div class=\"jFiler-item-others text-success\"><i class=\"icon-jfi-check-circle\"></i> Success</div>").hide().appendTo(parent).fadeIn("slow");
              });
              data.forEach(function(e){
                if(e['duration']==null){
                    var duration = '';
                }else{
                    var duration = e['duration'];
                }
                var template = "<tr id='row-no-"+e['id']+"'><td> "+e['order'] +"</td><td>"+ e['title']+"</td><td>"+ duration +"</td><td>"+e['ext']+"</td><td><button class='btn btn-danger'  data-toggle='modal' data-target='#exampleModal"+e['id']+"'>Delete</button><div class='modal fade' id='exampleModal"+ e['id']+"' tabindex='-1' role='dialog' aria-labelledby='exampleModalLabel' aria-hidden='true'><div class='modal-dialog' role='document'><div class='modal-content'><div class='modal-header'><h5 class='modal-title' id='exampleModalLabel'>Do you want to delete this song?</h5><button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div><div class='modal-footer'><button type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button><button type='button' id='delete-song-"+e['id']+"' class='btn btn-danger delete-song' data-song="+ e['id']+">Delete</button></div></div></div></div></tr></td>"
                $(template).appendTo('.table tbody');
                 $(".delete-song").click(function(){
                  console.log("ASsa")
                   var $this =  $(this);
                    var a = $this.parent().parent();
                     var id = $this.data("song");
                    $.ajax({
                      url: '/al/remove_song',
                      method: 'POST',
                      async: true,
                      data: {id: id},
                      success: function(){
                        $("#row-no-"+id).remove()
                      }
                    })
                    $("#exampleModal"+id).modal("hide");
                  });
              });
            },
            error: function(el){
                var parent = el.find(".jFiler-jProgressBar").parent();
                el.find(".jFiler-jProgressBar").fadeOut("slow", function(){
                    $("<div class=\"jFiler-item-others text-error\"><i class=\"icon-jfi-minus-circle\"></i> Error</div>").hide().appendTo(parent).fadeIn("slow");
                });
            },
            statusCode: null,
            onProgress: null,
            onComplete: function(data, el) {
							if (onUploadComplete) {
								onUploadComplete();
							}
						}
        },
				chunk: true,
				synchron: true,
        addMore: false,
        clipBoardPaste: true,
        excludeName: null,
        beforeRender: null,
        afterRender: null,
        beforeShow: null,
        beforeSelect: null,
        onSelect: null,
        afterShow: null,
        onRemove: function(itemEl, file, id, listEl, boxEl, newInputEl, inputEl){
            var file = file.name;
						var d = getCSRFHash();
						d[file] = file
            $.post(f.data('url-remove'), d);
        },
        onEmpty: null,
        options: null,
        captions: {
            button: "Choose Files",
            feedback: "Choose files To Upload",
            feedback2: "files were chosen",
            drop: "Drop file here to Upload",
            removeConfirmation: "Are you sure you want to remove this file?",
            errors: {
                filesLimit: "Only {{fi-limit}} files are allowed to be uploaded.",
                filesType: "Only Images are allowed to be uploaded.",
                filesSize: "{{fi-name}} is too large! Please upload file up to {{fi-maxSize}} MB.",
                filesSizeAll: "Files you've choosed are too large! Please upload files up to {{fi-maxSize}} MB."
            }
        }
    });
}
