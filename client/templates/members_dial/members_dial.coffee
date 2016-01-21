Template.members_dial.onCreated ->
  Session.setDefault 'selectedMembers', []
  Session.setDefault 'context', 'members'

Template.members_dial.onRendered ->
  SVGInjector $(".embed_svg"), { evalScipts: 'never' }
  $(".dial_member").each(->
    $(this).attr("data-orig-x", "" + $(this).css("left"))
    $(this).attr("data-orig-y", "" + $(this).css("top"))
  )
  $(".dial_member").draggable()
  $(".dial_member").on("dragstop", ->
    $(this).css("left", $(this).attr("data-orig-x"))
    $(this).css("top", $(this).attr("data-orig-y"))
  )

Template.members_dial.helpers
  context: ->
    if ((Session.get 'context') is 'members') then Template.parentData().title else 'Gebruiker'
  email: -> @emails[0].address
  items: ->
    if ((Session.get 'context') is 'members')
      project = Template.parentData()
      return Meteor.users.find {_id: {$in: project.members}}
    else
      return projects
  users: -> Meteor.users.find {}
  userIsMember: ->
    project = Template.parentData()
    this._id in project.members

Template.members_dial.events
  'click .dial_member': (e) ->
    e.preventDefault()
    $(e.currentTarget).toggleClass "selected"
    user_id = $(e.currentTarget).attr("user_id")
    selected_members = Session.get('selectedMembers').slice()
    if $(e.currentTarget).hasClass "selected"
      selected_members.push user_id
    else
      index = selected_members.indexOf user_id
      selected_members.splice(index, 1)
    Session.set 'selectedMembers', selected_members

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
