class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'

  initialize: (options={})->

  render: ()->
    @$el.html(@template(this.model.attributes))
    @

  removeRow: ->
    @$el.remove()

