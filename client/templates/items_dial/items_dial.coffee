Template.items_dial.onCreated ->
  Session.setDefault 'selectedItems', []

# Calculate length of vector
length = (a, b) ->
  Math.sqrt a * a + b * b

# Handle drag stop on item(s)
dragStop = (center_item_id) ->
  # Test if item is dropped within circle
  left = parseFloat $(this).css "left"
  top = parseFloat $(this).css "top"
  if length(left, top) < 70
    template = if Router.current().route.getName() is "projectPage" then "memberPage" else "projectPage"
    Router.go template, { _id: $(this).attr("data-id") }
  else if length(left, top) > 200
    if Router.current().route.getName() is "projectPage"
      projectId = center_item_id
      userId = $(this).attr("data-id")
    else
      projectId = $(this).attr("data-id")
      userId = center_item_id

    project = Projects.findOne projectId
    members = (member for member in project.members when member != userId)
    if members.length > 0
      projectProperties =
        members: members
      Projects.update projectId, {$set: projectProperties}, (error) ->
        if error
          throwError error.reason
        else
          if Meteor.userId() not in members
            Router.go 'memberPage', {_id: Meteor.userId}
    else
      Projects.remove projectId, (error) ->
        if error
          throwError error.reason
        else
          Router.go 'memberPage', {_id: userId}
  else
    $(this).css("left", $(this).attr "data-orig-x")
    $(this).css("top", $(this).attr "data-orig-y")

Template.items_dial.onRendered ->
  Session.set 'selectedItems', []
  SVGInjector $(".embed_svg"), { evalScipts: 'never' }
  $(".circular").each(->
    $(this).attr("data-orig-x", "" + $(this).css("left"))
    $(this).attr("data-orig-y", "" + $(this).css("top"))
  )
  $(".circular").draggable()
  center_item_id = Template.parentData()._id
  $(".circular").on("dragstop", -> dragStop.apply this, [center_item_id])

Template.items_dial.helpers
  title: ->
    if Router.current().route.getName() is "projectPage"
        @title
    else
        if @name then @name else @emails[0].address
  item_title: ->
    if Router.current().route.getName() is "projectPage"
        if @name then @name else @emails[0].address
    else
        @title
  svg_icon: ->
    if Router.current().route.getName() is "projectPage"
      "/images/Personicon.svg"
    else
      "/images/Projecticon.svg"
  items: ->
    if Router.current().route.getName() is "projectPage"
      project = Template.parentData()
      return Meteor.users.find {_id: {$in: project.members}}
    else
      user = Template.parentData()
      return Projects.find {members: user._id}

Template.items_dial.events
  'click .circular': (e) ->
    e.preventDefault()
    $(e.currentTarget).toggleClass "selected"
    item_id = $(e.currentTarget).attr("data-id")
    selected_items = Session.get('selectedItems').slice()
    if $(e.currentTarget).hasClass "selected"
      selected_items.push item_id
    else
      index = selected_items.indexOf item_id
      selected_items.splice(index, 1)
    Session.set 'selectedItems', selected_items

  'click .title': (e) ->
    e.preventDefault()
    if Router.current().route.getName() is "projectPage"
      Router.go 'projectEdit', {_id: @_id}
    else
      Router.go 'profilePage', {_id: @_id}


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
