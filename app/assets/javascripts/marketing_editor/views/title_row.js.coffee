class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'
    'change': 'valueChanged'

  initialize: (options={})->
    @listenTo(@model, 'destroy', this.remove)
    @fields = @fieldsOfRowType(@model.get('rowType'))

  render: ()->
    @$el.html(@template(data: @model.attributes, fields: @fields))
    @

  removeRow: ->
    @model.destroy()

  valueChanged: ->
    $.each(@$('[data-name]'), (index, el)=>
      @model.set($(el).attr('data-name'), $(el).val())
    )

  fieldsOfRowType: (rowType)->
    _.find(MarketingEditorApp.tilesDefinitions, (tileData)-> tileData.name == rowType).fields
