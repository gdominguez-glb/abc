class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'
    'change': 'valueChanged'

  initialize: (options={})->
    @listenTo(@model, 'destroy', this.remove)

  render: ()->
    @$el.html(@template(@model.attributes))
    @

  removeRow: ->
    @model.destroy()

  valueChanged: ->
    @model.set('title', @$('.title-input').val())
    @model.set('content', @$('.content-input').val())
