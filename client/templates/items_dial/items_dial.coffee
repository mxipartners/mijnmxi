Template.items_dial.onCreated ->
  Session.setDefault 'selectedItems', []
  Session.setDefault 'context', 'project'  # 'member' or 'project'

# Calculate length of vector
length = (a, b) ->
  Math.sqrt a * a + b * b

# Handle drag stop on item(s)
dragStop = ->
  # Test if item is dropped within circle
  left = $(this).css "left"
  top = $(this).css "top"
  console.log left + " " + top
  $(this).css("left", $(this).attr "data-orig-x")
  $(this).css("top", $(this).attr "data-orig-y")

Template.items_dial.onRendered ->
  SVGInjector $(".embed_svg"), { evalScipts: 'never' }
  $(".circular").each(->
    $(this).attr("data-orig-x", "" + $(this).css("left"))
    $(this).attr("data-orig-y", "" + $(this).css("top"))
  )
  $(".circular").draggable()
  $(".circular").on("dragstop", dragStop)

Template.items_dial.helpers
  title: ->
    if ((Session.get 'context') is 'project')
        @emails[0].address
    else
        @title
  items: ->
    if ((Session.get 'context') is 'project')
      project = Template.parentData()
      return Meteor.users.find {_id: {$in: project.members}}
    else  # 'member'
      return Projects.find {}, {sort: {submitted: -1}}

Template.items_dial.events
  'click .dial_item': (e) ->
    e.preventDefault()
    $(e.currentTarget).toggleClass "selected"
    user_id = $(e.currentTarget).attr("user_id")
    selected_items = Session.get('selectedItems').slice()
    if $(e.currentTarget).hasClass "selected"
      selected_items.push user_id
    else
      index = selected_items.indexOf user_id
      selected_items.splice(index, 1)
    Session.set 'selectedItems', selected_items

Handlebars.registerHelper "positionCircular", (index, count, radius) ->
  angle = Math.PI * 2 / count * index - Math.PI / 2
  top = (Math.sin angle) * radius
  left = (Math.cos angle) * radius
  return "left:" + left + "px;top:" + top + "px";

Handlebars.registerHelper "circularTick", (items, radiusStart, radiusEnd, fn) ->
  buffer = ""
  if items
    count = items.count
    for item, index in items
      do (item, index) ->
        angle = Math.PI * 2 / count * index - Math.PI / 2
        item.x1 = ((Math.cos angle) * radiusStart).toFixed 5
        item.y1 = ((Math.sin angle) * radiusStart).toFixed 5
        item.x2 = ((Math.cos angle) * radiusEnd).toFixed 5
        item.y2 = ((Math.sin angle) * radiusEnd).toFixed 5
        buffer += fn item
  return buffer
