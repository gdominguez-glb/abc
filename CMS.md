# CMS
## Create new tile
The tiles are the building blocks for the CMS on Greatminds marketing pages, it represents blocks of html with dynamic content defined on the CMS application. The tiles are composed of 2 parts, the tile fields and the tile template.

### The tile form fields

The fields of a tile form are configured on a file called `config/tiles.yml`, to add new tile form you need to add a new entry on the that list.

The following fields are available to create the form for a tile:

| Field Name | Value type | Description          |
|------------|------------|----------------------|
| :name      | String     | The name of the tile. |
| :fields    | Array of fields |A group of fields to define the form inputs and labels. |

The values available for fields are:

| Field Name | Value type | Description          |
|------------|------------|----------------------|
| :name      | String     | The html name of the field. |
| :label     | String     | The label used to identify the field input. |
| :input_type| String     | The different type of html inputs available:<br /><ul><li>text</li><li>select</li><li>checkbox</li><li>text_area</li> |
| :input_options | Array of strings | In case of add a select an input_options are required to have the html options on the html select tag on the form. |

This is a basic example of a tile form configuration.

```
---
- :name: Slider                                                                  
  :fields:                                                                       
    - :name: title_1                                                               
      :label: Title of first slide                                                 
      :input_type: text
    - :name: select_1                                                               
      :label: Select multiple options                                                
      :input_type: select
      :input_options:
        - Cat
        - Dog
        - Bird
```
### The tile template

To render the form values creates through the CMS app you have to add it to a file called `config/marketing_page.yml`

The following fields are available to create the template for a tile:

| Field Name | Value type | Description          |
|------------|------------|----------------------|
| name      | String      | The name of the tile. Be sure that you are using the same name for the tile on the template entry. |
| content    | HTML       | The html used to render the values of the tile form, you could use the erb syntaxis |

This is an example of an entry on the `config/marketing_page.yml` file.
```
  -                                                                              
    name: 'Slider'                                                               
    content: !xml |                                                              
      <div id="tileSlider<%= position %>" class="row intro masthead image-bg">   
        <h1><%= title_1 %></h1>                                                  
      </div>
```

With these 2 entries on the tiles files (`config/marketing_page.yml` and `config/tiles.yml`) you should be able to add these tile on the CMS app and correctly rendered on pages.
