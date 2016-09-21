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
    "change": "tilesChanged"

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
    @$('.save-btn').text('Saving').attr('disabled', true)
    $.ajax(
      url: @updateUrl,
      type: 'POST',
      data: { page: { tiles: { rows: @rows.toJSON() } } }
    )

  tilesChanged: ->
    if @tilesTimer?
      window.clearTimeout(@tilesTimer)

    func = =>
      @processTiles()

    @tilesTimer = setTimeout(
      func
      1500
    )

  processTiles: ->
    $.ajax(
      url: '/cms/pages/process_tiles'
      type: 'POST'
      data: { page: { tiles: { rows: @rows.toJSON() } } }
      success: (res)=>
        $('[name="page[body_draft]"]').trumbowyg('html', res.body)
    )

  tilesJSON: ->
    @rows.toJSON()

  initEditor: ->
    @$('.rich-editor').trumbowyg(
      fullscreenable: false
      closable: false
      removeformatPasted: true
      btns: ['bold', 'italic', 'underline', 'strikethrough', '|', 'formatting', '|', 'unorderedList', 'orderedList', '|', 'link', '|', 'viewHTML', 'removeformat']
    ).on('tbwchange', (e)->
      $(e.target).trigger('change')
    )
