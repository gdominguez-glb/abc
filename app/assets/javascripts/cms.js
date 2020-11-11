// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery.parse_params
//= require trumbowyg.min
//= require plugins/imageclasses
//= require_tree ./cms

$.trumbowyg.svgPath = '/icons.svg';

function initEditor() {
  $('.rich-editor').trumbowyg({
    fullscreenable: false,
    closable: false,
    removeformatPasted: true,
    semantic: false,
    btns: [
      ['bold', 'italic', 'underline', 'strikethrough'],
      ['superscript', 'subscript'],
      ['unorderedList', 'orderedList'],
      ['link'],
      ['formatting'],
      ['viewHTML'],
      ['removeformat'],
    ],
  });
}

$(function(){
  initEditor();
})
