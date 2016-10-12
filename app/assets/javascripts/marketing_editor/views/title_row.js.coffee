class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'
    'change': 'valueChanged'

  initialize: (options={})->
    @listenTo(@model, 'destroy', this.remove)
    @fields = @fieldsOfRowType(@model.get('rowType'))
    @parentView = options.parentView

  render: ()->
    @$el.html(@template(data: @model.attributes, fields: @fields))
    @valueChanged()
    @

  removeRow: ->
    @model.destroy()
    if @parentView && @parentView.tilesChanged?
      @parentView.tilesChanged()

  valueChanged: ->
    $.each(@$('[data-name]'), (index, el)=>
      if $(el).attr('type') == 'checkbox'
        if $(el).is(':checked')
          @model.set($(el).attr('data-name'), $(el).val())
        else
          @model.set($(el).attr('data-name'), 0)
      else
        @model.set($(el).attr('data-name'), $(el).val())
    )

  fieldsOfRowType: (rowType)->
    _.find(MarketingEditorApp.tilesDefinitions, (tileData)-> tileData.name == rowType).fields
