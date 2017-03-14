var name = function(user) {
  if(user._id === Meteor.userId()) {
    return "Ik";
  } else {
    if(user.name) {
      return user.name;
    }
    var emailAddress = user.emails[0].address;
    var cleanedName = emailAddress
      .replace(/@.*$/, "")              // Remove @domain.com
      .replace(/\./g, " ")              // Replace . with space
      .replace(/(^.| .)/g, function(match, firstChar) {
        return firstChar.toLocaleUpperCase();
      })
    ;
    return cleanedName;
  }
};

var scrollToBottom = function() {
  // Scroll to bottom and select entry field
  window.scrollTo(0, document.body.scrollHeight);
  d3.select("textarea").node().focus();
};

Template.messagesPage.helpers({
  messages: function() {
    return Messages.find({});
  },

  sender: function() {
    return name(Meteor.users.findOne({_id: this.sender}));
  },

  sender_location: function() {
    return this.sender === Meteor.userId() ? "right" : "left";
  },

  message_id: function() {
    return this._id;
  },

  recipient_names: function() {
    if(!this.recipients) {
      return "Iedereen";
    }
    var recipients = Meteor.users.find({"_id": {$in: this.recipients}}).fetch();
    var names = recipients.map(function(recipient) { return name(recipient); });
    return names.length > 0 ? names.join(", ") : "Iedereen";
  },

  selected_users: function() {
    var selectedItems = Session.get("selectedItems");
    if(selectedItems.length === 0 || selectedItems.length === Session.get("items").length) {
      return "Iedereen";
    } else {
      var users = Meteor.users.find({"_id": {$in: selectedItems}}).fetch();
      return users.map(function(user) { return name(user); }).join(", ");
    }
  }
});


Template.messagesPage.events({
  "click .reply_message": function(e) {
    e.preventDefault();

    // Retrieve recipients from selected message
    var messageId = d3.select(e.currentTarget).attr("data-message-id");
    var message = Messages.findOne({ _id: messageId });
    var recipients = message.recipients;

    // Check if message is to selected recipients (instead of all)
    if(recipients.length > 0) {

      // Add sender to recipients and than remove user (user will either be sender or a recipient)
      recipients.splice(0, 0, message.sender);
      recipients = recipients.filter(function(recipient) { return recipient !== Meteor.userId(); });
    }

    // Set recipients as new selected users
    Session.set("selectedItems", recipients);

    // Scroll to bottom to show message entry field and focus field
    scrollToBottom();
  },

  "click .send_message": function(e) {
    e.preventDefault();

    // Create extra message
    var messageProperties = {
      project: this._id,
      content: d3.select("[name=messagecontent]").property("value"),
      recipients: Session.get("selectedItems")
    };
    Meteor.call("messageInsert", messageProperties, function(error, result) {
      if(error) {
        throwError(error.reason);
      }

      // Remove message content
      d3.select("[name=messagecontent]").property("value", "");
    });

    // Scroll to bottom to allow new entry to be given
    scrollToBottom();
  },

  "click .project_title": function(e) {
    e.preventDefault();
    Router.go("projectPage", {_id: this._id});
  }
});

Template.messagesPage.onRendered(function() {
  scrollToBottom();
});
