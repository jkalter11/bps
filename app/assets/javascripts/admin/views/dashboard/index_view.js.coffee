BPS.Admin.Views.Dashboard ||= {}

class BPS.Admin.Views.Dashboard.Index extends Backbone.View
  template: JST["admin/templates/dashboard/index"]

  events:
    'click #bitcoin_addresses .show_keys': 'show_keys'

  render: (bitcoin_addresses) ->
    $(@el).html(@template(bitcoin_addresses: bitcoin_addresses))
   
    return this
    
  show_keys: (event) ->
    $(event.target).parent().children('.keys').toggle()

