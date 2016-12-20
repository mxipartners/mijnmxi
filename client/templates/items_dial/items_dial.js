// Retrieve parent template
var parentTemplate = null;

// Initialize page for rendering
Template.items_dial.onRendered(function() {

  // Start with subject (if missing move to 'home' page)
  parentTemplate = Template.instance().parentTemplate();
  var subject = parentTemplate.subject();
  if(!subject) {
    Router.go("memberPage", {_id: Meteor.userId()});
    return;
  }

  // Show subject in centre of page (add handler to replace icon by gravatar)
  var subjectGroup = d3.select("g.center")
    .append("g")
      .attr("class", "subject")
      .attr("data-id", subject._id)
      .attr("transform", "translate(0,30)")
      .on("mousedown", function() {
        // Keep track of time when clicking (to distinguish short/long press)
        var element = d3.select(this);
        element.datum({ clickStart: Date.now() });
      })
      .on("click", function() {
        var element = d3.select(this);
        var now = Date.now();
        // Check for short press (< 1 second)
        if(now - element.datum().clickStart < 1000) {
          Router.go(parentTemplate.subjectEditTemplate(), parentTemplate.subjectEditParameters(subject));
        } else {
          Router.go(parentTemplate.subjectLongPressEditTemplate(), parentTemplate.subjectLongPressEditParameters(subject));
        }
        return;
      })
  ;
  subjectGroup
    .append("text")
      .attr("y", 80)
      .attr("text-anchor", "middle")
      .text(parentTemplate.subjectTitle())
  ;
  subjectGroup
    .append("use")
      .attr("y", -30)
      .attr("xlink:href", parentTemplate.subjectIcon())
      .each(function() { replaceItemIconByGravatar(d3.select(this)); })
  ;

  // Add event handler for select-all items (and start with empty selection)
  Session.set("selectedItems", []);
  d3.select("g.select-all")
    .on("click", function() {
      if(d3.selectAll(".selected").size() !== d3.selectAll(".item").size()) {
        Session.set("selectedItems", Session.get("items").map(function(x) { return x._id; }));
      } else {
        Session.set("selectedItems", []);
      }
    })
  ;

  // Update related items (reactive on "items" from session)
  this.autorun(function() {
    var items = Session.get("items");
    var selectedItems = Session.get("selectedItems");
    var itemCount = items.length;
    var itemElements = d3.select("g.center")
      .selectAll(".item")
        .data(items, function(d) { return d._id; })
    ;

    // Add new items (add click/select and drag handlers)
    var newItems = itemElements
      .enter()
        .append("g")
          .attr("class", "item")
          .attr("data-id", function(d) { return d._id; })
          .attr("transform", "translate(-500,0)scale(0.1)")
          .call(handleDragItem)
          .on("click", function() { selectItem(d3.select(this)); })
    ;

    // Animate new and updating items into position
    newItems
      .merge(itemElements)
        .classed("selected", function(d) { return selectedItems.indexOf(d._id) >= 0; })
        .transition()
          .duration(300)
          .attr("transform", function(d, i) {
            d.position = { x: positionX(i, itemCount, 365), y: positionY(i, itemCount, 365) };
            return "translate(" + d.position.x + "," + d.position.y + ")scale(1)";
          })
    ;

    // Append text and icon to new items (add handler to replace icon by gravatar)
    newItems
      .append("text")
        .attr("y", 80)
        .attr("text-anchor", "middle")
        .text(function(d) { return parentTemplate.relatedItemTitle(d); })
    ;
    newItems
      .append("use")
        .attr("y", -30)
        .attr("xlink:href", function(d) { return parentTemplate.relatedItemIcon(d); })
        .each(function(d) { replaceRelatedItemIconByGravatar(d3.select(this), d); })
    ;

    // Remove old items by animation
    itemElements
      .exit()
        .transition()
          .duration(300)
          .attr("transform", "translate(500,0)scale(0.1)")
          .on("end", function() {
            d3.select(this).remove();
          })
    ;
  });
});

// Deselect/Select related item (store list of selected items in session)
var selectItem = function(itemElement) {
  if(d3.event.defaultPrevented) {  // Needed because of dragging
    return;
  }
  var id = itemElement.datum()._id;
  var currentSelectedItems = Session.get("selectedItems");
  if(itemElement.classed("selected")) {
    itemElement.classed("selected", false);
    currentSelectedItems = currentSelectedItems.filter(function(x) { return x !== id; });
    Session.set("selectedItems", currentSelectedItems);
  } else {
    itemElement.classed("selected", true);
    currentSelectedItems.push(id);
    Session.set("selectedItems", currentSelectedItems);
  }
};

// Handle drag of related item
var handleDragItem = function(selection) {
  d3.drag()
    .on("start", function() {
      var itemElement = d3.select(this);
      // Test for ios buggy behaviour
      // If ios does not drag correct (see comment at "drag" below)
      // the current element is already marked for dragging and will
      // be the top most element (ie no next sibling). For this to be
      // evident, the user must drag an item, see it fail and try to
      // drag the same item again. Exactly that behaviour is tested
      // for below (because it seems a logical reaction for the user).
      // This fact is then stored in localStorage (which persists
      // across different application runs).
      if(!this.nextSibling && itemElement.classed("dragging")) {
        window.localStorage.setItem("buggyDragBehaviour", "true");
      }
      itemElement
        .classed("dragging", true)
      ;
    })
    .on("drag", function(d) {
      var itemElement = d3.select(this);
      // Raise the element so it is on top of other items
      // Under ios this raise will cause the drag event to stop working.
      // The element will remain marked for dragging (ie class "dragging").
      // Since on ios our finger will be on top of the dragged element
      // it will not be a major issue that the dragged element is not
      // the top most element (ie it will now remain at a lower z-index).
      // Therefore if the buggy behaviour is detected (see comment at
      // "start" above), the element is not raised.
      if(window.localStorage.getItem("buggyDragBehaviour") !== "true") {
        itemElement.raise();
      }
      itemElement
        .attr("transform", function(d) {
          d.dragPosition = { x: d3.event.x, y: d3.event.y };
          return "translate(" + d.dragPosition.x + "," + d.dragPosition.y + ")";
        })
      ;
    })
    .on("end", function() {
      var itemElement = d3.select(this);
      itemElement.classed("dragging", false);
      handleDraggedItem(itemElement);
    })(selection);
};

// Handle related item after dragging ended
var handleDraggedItem = function(itemElement) {
  var dragItem = itemElement.datum();
  var dragPosition = dragItem.dragPosition;
  if(!dragPosition) {
    return;
  }
  var radius = length(dragPosition.x, dragPosition.y);
  if(radius > 520) {
    // FIXME: check if user is allowed to remove relation (or should drag be prevented)?
    parentTemplate.removeItemRelation(dragItem);
    // FIXME: which page to show after remove (now a check is made for empty data in project_page and member_page)?
  } else if(radius > 190) {
    var position = dragItem.position;
    itemElement.transition()
      .duration(300)
        .attr("transform", "translate(" + position.x + "," + position.y + ")")
    ;
  } else {
    Router.go(parentTemplate.relatedItemTemplate(dragItem), { _id: dragItem._id });
    return;
  }
};

// Replace icon by gravator
var replaceItemIconByGravatar = function(iconElement) {
  var emailAddress = parentTemplate.subjectEmailAddress();
  replaceIconByGravatar(iconElement, emailAddress);
};

var replaceRelatedItemIconByGravatar = function(iconElement, relatedItem) {
  var emailAddress = parentTemplate.relatedItemEmailAddress(relatedItem);
  replaceIconByGravatar(iconElement, emailAddress);
};

var replaceIconByGravatar = function(iconElement, emailAddress) {
  if(!emailAddress || !emailAddress.length) {
    return;
  }

  // Replace icon by gravatar
  Gravatar.retrieve(emailAddress, function(imageDataURL) {
    replaceIconByImageData(iconElement, imageDataURL);
  });
};

var replaceIconByImageData = function(iconElement, imageDataURL) {
  d3.select(iconElement.node().parentNode)
    .append("image")
      .attr("xlink:href", imageDataURL)
      .attr("width", 160)
      .attr("height", 160)
      .attr("clip-path", "url(#clip-circle)")
      .attr("transform", "translate(-80,-110)")
  ;

  // Update icon to be a kind of halo around gravatar (so selections can be made visible)
  iconElement.attr("xlink:href", "#person-image");
};

// Helper functions for positioning
var length = function(a, b) {
  return Math.sqrt(a * a + b * b);
};

var angle = function(index, count) {
  return Math.PI * 2 / count * index - Math.PI / 2;
};

var positionX = function(index, count, radius) {
  return Math.cos(angle(index, count)) * radius;
};

var positionY = function(index, count, radius) {
  return Math.sin(angle(index, count)) * radius;
};
