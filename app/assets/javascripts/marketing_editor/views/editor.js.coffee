class MarketingEditorApp.Views.Editor extends Backbone.View

  template: JST['marketing_editor/templates/editor']

  render: ->
    @$el.html(@template())
    @

  events:
    "click .add-tile-row-btn": "addNewTileRow"

  addNewTileRow: (e)->
    e.preventDefault()
    tileView = new MarketingEditorApp.Views.TileRowView({ rowType: @$('.row-type-select').val() })
    this.$el.find('.rows').append(tileView.render().$el)
