class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['cms/marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'
    'change': 'valueChanged'
    'change .select-container select': 'customSelectChanged'

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
        if $(el).attr('data-name') == 'image_url'
          @setAltText(el)
    )

  fieldsOfRowType: (rowType)->
    _.find(MarketingEditorApp.tilesDefinitions, (tileData)-> tileData.name == rowType).fields

  customSelectChanged: (e)->
    $(e.target).siblings('span').text($(e.target).val())

  setAltText: (el)->
    url = $(el).val()
    url_parts = $.parseParams(url)
    if url_parts['alt']?
      alt_text = url_parts['alt']
      $(el).closest('.col-sm-6').next('.col-sm-6').find('[data-name="alt_text"]').val(alt_text)
