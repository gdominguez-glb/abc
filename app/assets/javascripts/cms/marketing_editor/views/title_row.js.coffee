class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['cms/marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'
    'change .update-row-type': 'updateRowType',
    'change': 'valueChanged'
    'change .select-container select': 'customSelectChanged'
    'change .featured-img-title-input': 'featuredImageChanged'

  initialize: (options={})->
    @listenTo(@model, 'destroy', this.remove)
    @fields = @fieldsOfRowType(@model.get('rowType'))
    @parentView = options.parentView

  render: ()->
    @$el.html(@template(data: @model.attributes, fields: @fields, row_id: @model.cid))
    @valueChanged()
    @

  removeRow: ->
    @model.destroy()
    if @parentView && @parentView.tilesChanged?
      @parentView.tilesChanged()

  updateRowType: ->
    newType = @$('.update-row-type').val()
    row = new MarketingEditorApp.Models.RowModel(@model.attributes)
    row.attributes.rowType = newType

    @parentView.rows.add(row)
    rowView = new MarketingEditorApp.Views.TileRowView(model: row, parentView: @parentView)
    @$el.after(rowView.render().el)
    @parentView.initEditor()

    this.removeRow()

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

  featuredImageChanged: (e)->
    chkbox_id = e.target.id
    selected_value =
      if $("#"+e.target.id).is(":checked")
        "checked"
      else
        "unchecked"
    $(".#{chkbox_id}").val(selected_value)
    chkboxs = $(document).find($("input[type='checkbox'].featured-img-title-input"))

    $.each(chkboxs, (index, el)=>
      if el.id != chkbox_id && el.checked == true
        $(el).prop('checked', false)
        $("." + el.id).val('unchecked')
        $("." + el.id).attr('value', 'unchecked')
        $("." + el.id).trigger('change')
    )
