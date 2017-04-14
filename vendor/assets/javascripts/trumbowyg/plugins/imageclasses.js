(function ($) {
  'use strict';

  $.extend(true, $.trumbowyg, {
    langs: {
      en: {
      }
    },

    plugins: {
      imageClasses: {
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
                  image_left: {
                    label: 'Image on left',
                    required: false,
                    type: 'checkbox'
                  },
                  image_right: {
                    label: 'Image on Right',
                    required: false,
                    type: 'checkbox'
                  }
                },

                // Callback
                function (values) {
                  var img = $('<img src="'+ values.image_link+'" /> ');
                  var imageLeft = "img-blog-square img-blog-square-left";
                  var imageRight = "img-blog-square img-blog-square-right";
                  var imageFull = "img-blog-full";

                  if(values.image_left) {
                    img.addClass(imageLeft);
                  } else if(values.image_right) {
                    img.addClass(imageRight);
                  } else {
                    img.addClass(imageFull);
                  }
                  var node = img.get(0);
                  trumbowyg.range.deleteContents();
                  trumbowyg.range.insertNode(node);
                  return true;
                }
              );
            }
          };
          
          trumbowyg.addBtnDef('imageClasses', btnDef);
        }
      }
    }
  });

})(jQuery);
