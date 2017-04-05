(function ($) {
  'use strict';

  $.extend(true, $.trumbowyg, {
    langs: {
      en: {
      }
    },

    plugins: {
      imageText: {
        init: function (trumbowyg) {
          var btnDef = {
            fn: function () {

              var $modal = trumbowyg.openModalInsert(
                // Title
                trumbowyg.lang.square_left,

                // Fields
                {
                  image_link: {
                    label: 'Image Link',
                    required: true
                  },
                  text: {
                    label: 'Text',
                    required: true,
                    type: 'text'
                  },
                  image_left: {
                    label: 'Image on left',
                    required: false,
                    type: 'checkbox'
                  }
                },

                // Callback
                function (values) {
                  var html = $('<div class="row"></div>');
                  var image = $('<img class="col-md-3" src="'+ values.image_link+'" />')
                  var text = $('<p class="col-md-9">'+values.text+'</p>');
                  if(values.image_left) {
                    html.append(image);
                    html.append(text);
                  } else {
                    html.append(text);
                    html.append(image);
                  }
                  var node = html.get(0);
                  trumbowyg.range.deleteContents();
                  trumbowyg.range.insertNode(node);
                  return true;
                }
              );
            }
          };
          
          trumbowyg.addBtnDef('imageText', btnDef);
        }
      }
    }
  });

})(jQuery);
