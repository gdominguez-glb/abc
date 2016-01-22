class MarketingEditorApp.Views.Editor extends Backbone.View

  template: JST['marketing_editor/templates/editor']

  initialize: (opts={})->
    tilesData         = opts.tilesData || {}
    @rows             = new MarketingEditorApp.Collections.RowsCollection(tilesData.rows || [])
    @updateUrl        = opts.updateUrl

  render: ->
    @rows.each((row)->
      rowView = new MarketingEditorApp.Views.TileRowView(model: row)
      @$('.rows').append(rowView.render().el)
    )
    @initEditor()
    @

  events:
    "click .add-tile-row-btn": "addNewTileRow"
    "click .save-btn": "saveRows"

  addNewTileRow: (e)->
    e.preventDefault()
    row = new MarketingEditorApp.Models.RowModel({ rowType: @$('.row-type-select').val() })
    @rows.add(row)
    rowView = new MarketingEditorApp.Views.TileRowView(model: row)
    @$('.rows').append(rowView.render().el)
    @$('.tile-notice').html('Tile added, please scroll to bottom to edit.')
    @$('.tile-notice').fadeIn(1000)
    setTimeout(=>
      @$('.tile-notice').fadeOut(500)
    , 3000)
    @initEditor()

  saveRows: (e)->
    $.ajax(
      url: @updateUrl,
      type: 'POST',
      data: { page: { tiles: { rows: @rows.toJSON() } } }
    )

  initEditor: ->
    @$('.rich-editor').trumbowyg(
      fullscreenable: false
      closable: false
      removeformatPasted: true
      btns: ['bold', 'italic', 'underline', 'strikethrough', '|', 'formatting', '|', 'unorderedList', 'orderedList', '|', 'link', '|', 'removeformat']
    ).on('tbwchange', (e)->
      $(e.target).trigger('change')
    )
