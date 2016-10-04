function teamModals(modalId) {
  $('.js-tooltip-trigger').tooltip();

  $(modalId).on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget);
    var name = button.data('name');
    var title = button.data('title');
    var bio = button.data('bio');

    var modal = $(this);
    modal.find('.modal-name').text(name);
    modal.find('.modal-title strong').text(title);
    modal.find('.modal-body').html(bio);
  });
}
