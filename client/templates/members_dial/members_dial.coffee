Template.members_dial.onCreated ->
  Session.setDefault 'selectedMembers', []

Template.members_dial.onRendered ->
  SVGInjector $(".embed_svg"), { evalScipts: 'never' }

Template.members_dial.helpers
  project_members: ->
    project = Template.parentData()
    return Meteor.users.find {_id: {$in: project.members}}
  email: -> @emails[0].address

Template.members_dial.events
  'click .dial_member': (e) ->
    e.preventDefault

    $(e.currentTarget).toggleClass "selected"

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
