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
                  captionable: {
                    label: 'Image Caption',
                    required: false
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
                  var img, imgClass;

                  if(values.image_left) {
                    imgClass = "left";
                  } else if(values.image_right) {
                    imgClass = "right";
                  } else {
                    imgClass = "full";
                  }

                  img = '<figure class="figure-blog figure-blog--' + imgClass + '"><img src="' + values.image_link + '">';

                  if(values.captionable) {
                    img += "<figcaption class='image_caption'>" + values.captionable + "</figcaption>";
                  }

                  img += '</figure>';
                  img = $(img);

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
