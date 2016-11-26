# Retrieve parent template
parentTemplate = null

# Initialize page for rendering
Template.items_dial.onRendered ->

  # Start with subject (if missing move to 'home' page)
  parentTemplate = Template.instance().parentTemplate()
  subject = parentTemplate.subject()
  if !subject
    Router.go "memberPage", {_id: Meteor.userId()}

  # Show subject in centre of page (add handler to replace icon by gravatar)
  subjectGroup = d3.select("g.center")
    .append("g")
      .attr("class", "subject")
      .attr("data-id", subject._id)
      .on("click", () ->
        Router.go parentTemplate.subjectEditTemplate(), { _id: subject._id }
      )
  subjectGroup
    .append("text")
      .attr("y", 80)
      .attr("text-anchor", "middle")
      .text(parentTemplate.subjectTitle())
  subjectGroup
    .append("use")
      .attr("y", -30)
      .attr("xlink:href", parentTemplate.subjectIcon())
      .each(() -> replaceItemIconByGravatar(d3.select(this)))

  # Add event handler for select-all items (and start with empty selection)
  Session.set("selectedItems", [])
  d3.select("g.select-all")
    .on("click", () -> Session.set("selectedItems", Session.get("items").map((x) -> x._id)))

  # Update related items (reactive on "items" from session)
  this.autorun(() ->
    items = Session.get("items")
    selectedItems = Session.get("selectedItems")
    itemCount = items.length
    itemElements = d3.select("g.center").selectAll(".item")
      .data(items, (d) -> d._id)

    # Add new items (add click/select and drag handlers)
    newItems = itemElements
      .enter()
        .append("g")
          .attr("class", "item")
          .attr("data-id", (d) -> d._id)
          .attr("transform", "translate(-500,0)scale(0.1)")
          .on("click", () -> selectItem(d3.select(this)))
          .call(handleDragItem)

    # Animate new and updating items into position
    newItems
      .merge(itemElements)
        .classed("selected", (d) -> selectedItems.indexOf(d._id) >= 0)
        .transition()
          .duration(300)
          .attr("transform", (d, i) ->
            d.position = { x: positionX(i, itemCount, 365), y: positionY(i, itemCount, 365) }
            "translate(" + d.position.x + "," + d.position.y + ")scale(1)")

    # Append text and icon to new items (add handler to replace icon by gravatar)
    newItems
      .append("text")
        .attr("y", 80)
        .attr("text-anchor", "middle")
        .text((d) -> parentTemplate.relatedItemTitle(d))
    newItems
      .append("use")
        .attr("y", -30)
        .attr("xlink:href", (d) -> parentTemplate.relatedItemIcon(d))
        .each((d) -> replaceRelatedItemIconByGravatar(d3.select(this), d))

    # Remove old items by animation
    itemElements
      .exit()
        .transition()
          .duration(300)
          .attr("transform", "translate(500,0)scale(0.1)")
          .on("end", () ->
            d3.select(this).remove()
          )
  )

# Deselect/Select related item (store list of selected items in session)
selectItem = (itemElement) ->
  if d3.event.defaultPrevented  # Needed because of dragging
    return
  id = itemElement.datum()._id
  currentSelectedItems = Session.get("selectedItems")
  if itemElement.classed("selected")
    itemElement.classed("selected", false)
    currentSelectedItems = currentSelectedItems.filter((x) -> x != id)
    Session.set("selectedItems", currentSelectedItems)
  else
    itemElement.classed("selected", true)
    currentSelectedItems.push(id)
    Session.set("selectedItems", currentSelectedItems)

# Handle drag of related item
handleDragItem = (selection) ->
  d3.drag()
    .on("start", () ->
      itemElement = d3.select(this)
      itemElement
        .classed("dragging", true)
      d3.event
        .on("drag", (d) ->
          itemElement
            .raise()
            .attr("transform", (d) ->
              d.dragPosition = { x: d3.event.x, y: d3.event.y }
              "translate(" + d.dragPosition.x + "," + d.dragPosition.y + ")")
        )
        .on("end", () ->
          itemElement.classed("dragging", false)
          handleDraggedItem(itemElement)
        )
    )(selection)

# Handle related item after dragging ended
handleDraggedItem = (itemElement) ->
  dragItem = itemElement.datum()
  dragPosition = dragItem.dragPosition
  if !dragPosition
    return
  radius = length(dragPosition.x, dragPosition.y)
  if radius > 520
    # FIXME: check if user is allowed to remove relation (or should drag be prevented)?
    parentTemplate.removeItemRelation(dragItem)
    # FIXME: which page to show after remove (now a check is made for empty data in project_page and member_page)?
  else if radius > 190
    position = dragItem.position
    itemElement.transition()
      .duration(300)
        .attr("transform", "translate(" + position.x + "," + position.y + ")")
  else
    Router.go parentTemplate.relatedItemTemplate(dragItem), { _id: dragItem._id }

# Replace icon by gravator
replaceItemIconByGravatar = (iconElement) ->
  emailAddress = parentTemplate.subjectEmailAddress()
  replaceIconByGravatar(iconElement, emailAddress)

replaceRelatedItemIconByGravatar = (iconElement, relatedItem) ->
  emailAddress = parentTemplate.relatedItemEmailAddress(relatedItem)
  replaceIconByGravatar(iconElement, emailAddress)

replaceIconByGravatar = (iconElement, emailAddress) ->
  if !emailAddress || !emailAddress.length
    return

  # Calculate hash for gravatar and check if it is in cache
  hash = CryptoJS.MD5 emailAddress.trim().toLowerCase()
  if window.gravatarCache
    imageDataURL = window.gravatarCache[hash]
    if imageDataURL != undefined
      if imageDataURL.length > 0
        replaceIconByImageData(iconElement, imageDataURL)
      return
  else
    window.gravatarCache = {}

  # Retrieve gravatar
  url = "http://www.gravatar.com/avatar/" + hash + "?d=404&s=160"
  d3.request(url)
    .mimeType("image/jpeg")
    .responseType("arraybuffer")
    .get((error, data) ->

      # Store gravatar (or "" in absence) in cache for later usage
      if !error && data && data.response
        arrayBuffer = new Uint8Array(data.response)
        binary = ""
        for i in [0..arrayBuffer.length]
          binary += String.fromCharCode(arrayBuffer[i])
        imageDataURL = "data:image/jpeg;base64," + window.btoa(binary)
        window.gravatarCache[hash] = imageDataURL

        # Gravatar found replace icon with new gravatar
        replaceIconByImageData(iconElement, imageDataURL)
      else if error && error.target && error.target.status == 404
        window.gravatarCache[hash] = ""
    )

replaceIconByImageData = (iconElement, imageDataURL) ->
  d3.select(iconElement.node().parentNode)
    .append("image")
      .attr("xlink:href", imageDataURL)
      .attr("width", 160)
      .attr("height", 160)
      .attr("clip-path", "url(#clip-circle)")
      .attr("transform", "translate(-80,-110)")

  # Update icon to be a kind of halo around gravatar (so selections can be made visible)
  iconElement.attr("xlink:href", "#person-image")

Template.items_dial.onCreated ->
  # FIXME: new approach for handling page specific buttons from footer
  #window.addHandler = (d) ->
  #  window.alert d

Template.items_dial.onDestroyed ->
  # FIXME: new approach for handling page specific buttons from footer
  # Probably better to set empty default handler since it will allow a call to the handler (instead of having an exception).
  # A general (script for all templates) with a register/unregister functionality will be best.
  #delete window.addHandler

# Helper functions for positioning
length = (a, b) ->
  Math.sqrt a * a + b * b

angle = (index, count) ->
  Math.PI * 2 / count * index - Math.PI / 2

positionX = (index, count, radius) ->
  Math.cos(angle(index, count)) * radius

positionY = (index, count, radius) ->
  Math.sin(angle(index, count)) * radius
