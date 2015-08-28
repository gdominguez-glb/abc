class MarketingEditorApp.Views.Editor extends Backbone.View

  template: JST['marketing_editor/templates/editor']

  initialize: (opts={})->
    @rows = new MarketingEditorApp.Collections.RowsCollection([
      {  rowType: 'A' }
      {  rowType: 'B' }
    ])

  render: ->
    @rows.each((row)->
      rowView = new MarketingEditorApp.Views.TileRowView(model: row)
      @$('.rows').append(rowView.render().el)
    )
    @

  events:
    "click .add-tile-row-btn": "addNewTileRow"

  addNewTileRow: (e)->
    e.preventDefault()
    row = new MarketingEditorApp.Models.RowModel({ rowType: @$('.row-type-select').val() })
    rowView = new MarketingEditorApp.Views.TileRowView(model: row)
    @$('.rows').append(rowView.render().el)
