class MarketingEditorApp.Views.Editor extends Backbone.View

  template: JST['marketing_editor/templates/editor']

  initialize: (opts={})->
    @rows = new MarketingEditorApp.Collections.RowsCollection([])

  render: ->
    @rows.each((row)->
      rowView = new MarketingEditorApp.Views.TileRowView(model: row)
      @$('.rows').append(rowView.render().el)
    )
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

  saveRows: (e)->
    console.log @rows.toJSON()
