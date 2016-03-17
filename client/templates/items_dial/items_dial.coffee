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
    $(this).css("left", $(this).attr("data-orig-x") + "px")
    $(this).css("top", $(this).attr("data-orig-y") + "px")

gravatar_url = (email_address) ->
  hash = CryptoJS.MD5 email_address.trim().toLowerCase()
  "http://www.gravatar.com/avatar/" + hash + "?d=404&s=50"

Template.items_dial.onRendered ->
  if Router.current().route.getName() is "projectPage"
    members = []
  else if Template.parentData()._id == Meteor.userId()
    members = []
  else
    members = [Template.parentData()._id]
  Session.set 'selectedItems', members

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
      "/images/Projecticon.svg"
    else
      "/images/Personicon.svg"
  item_svg_icon: ->
    if Router.current().route.getName() is "projectPage"
      if @_id == Meteor.userId()
        "/images/Selficon.svg"
      else
        "/images/Personicon.svg"
    else
      "/images/Projecticon.svg"
  self: ->
    if @_id == Meteor.userId()
      "self"
    else
      ""
  items: ->
    if Router.current().route.getName() is "projectPage"

      # Read all users for current project (into array)
      project = Template.parentData()
      users = Meteor.users.find({_id: {$in: project.members}}).map((x) -> x)

      # Store length of array for later usage
      Session.set 'membersCount', users.length

      # Find current user
      currentUserId = Meteor.userId()
      currentUserIndex = users.reduce(((index, user, i) ->
        if index >= 0
          return index
        else if user._id == currentUserId
          return i
        return -1), -1)

      # Remove current user from array and store it separately
      currentUser = users.splice(currentUserIndex, 1)[0];
      
      # Sort remaining users based on main email address
      users.sort((a, b) ->
        a.emails[0].address.localeCompare(b.emails[0].address))

      # Insert current user at front and return result
      users.splice(0,  0, currentUser)
      users
    else
      user = Template.parentData()
      projects = Projects.find({members: user._id}).map((x) -> x)
      Session.set 'membersCount', projects.length
      projects
  items_count: ->
    Session.get 'membersCount'
  redraw: ->
    center_item_id = Template.parentData()._id
    Meteor.defer ->
      SVGInjector $(".embed_svg:not(.injected-svg)"), { evalScipts: 'never' }
      $(".circular").draggable()
      $(".circular").on("dragstop", -> dragStop.apply this, [center_item_id])
    ""
  gravatar: ->
    hash = CryptoJS.MD5 @emails[0].address.trim().toLowerCase()
    "http://www.gravatar.com/avatar/" + hash + "?d=mm&s=50"
  member_page: -> Router.current().route.getName() is "memberPage"
  get_gravatar: ->
    url = gravatar_url(@emails[0].address)
    this_id = @_id
    HTTP.get url, (error, response) ->
      # If you're wondering why there's a 404 exception in the console log,
      # see https://github.com/meteor/meteor/issues/6215
      if not error
        console.log "Showing: " + this_id
        html = ''
        if not Router.current().route.getName() is "memberPage"
          html = '<span class="img-selected"></span>'
        html += '<img class="img-circle" src="' + url + '"/>'
        $('#' + this_id).html(html)
    ""

Template.items_dial.events
  'click .circular': (e) ->
    e.preventDefault()
    item_id = $(e.currentTarget).attr("data-id")
    if Router.current().route.getName() is "projectPage" and item_id != Meteor.userId()
      $(e.currentTarget).toggleClass "selected"
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

angle = (index, count) ->
  Math.PI * 2 / count * index - Math.PI / 2

positionX = (index, count, radius) ->
  Math.cos(angle(index, count)) * radius

positionY = (index, count, radius) ->
  Math.sin(angle(index, count)) * radius

Handlebars.registerHelper "positionX", (index, count, radius) ->
  positionX index, count, radius

Handlebars.registerHelper "positionY", (index, count, radius) ->
  positionY index, count, radius

Handlebars.registerHelper "positionCircular", (index, count, radius) ->
  left = positionX index, count, radius
  top = positionY index, count, radius
  "left:" + left + "px;top:" + top + "px"
