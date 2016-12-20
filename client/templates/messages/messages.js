var name = function(user) {
  if(user._id == Meteor.userId()) {
    return "Ik";
  } else {
    return user.name ? user.name : user.emails[0].address;
  }
};

Template.messagesPage.helpers({
  messages: function() {
    return Messages.find({});
  },

  sender: function() {
    return name(Meteor.users.findOne({_id: this.sender}));
  },

  sender_location: function() {
    return this.sender == Meteor.userId() ? "right" : "left";
  },

  recipient_names: function() {
    var recipients = Meteor.users.find({"_id": {$in: this.recipients}}).fetch();
    var names = recipients.map(function(recipient) { return name(recipient); });
    return names.length > 0 ? names.join(", ") : "Ik";
  },

  selected_users: function() {
    var users = Meteor.users.find({"_id": {$in: Session.get("selectedItems")}}).fetch();
    return users.map(function(user) { return name(user); }).join(", ");
  }
});


Template.messagesPage.events({
  "click .reply_message": function(e) {
    e.preventDefault();
    //Router.go("messagesPage", 
  },

  "click .send_message": function(e) {
    e.preventDefault();
    var messageProperties = {
      project: this._id,
      content: d3.select("[name=messagecontent]").property("value"),
      recipients: Session.get("selectedItems")
    };
    Meteor.call("messageInsert", messageProperties, function(error, result) {
      if(error) {
        throwError(error.reason);
      }
    });
    messagesDiv = d3.select(".messages");
    messagesDiv.node.scrollTop(messagesDiv.property("scrollHeight"));
  },

  "click .project_title": function(e) {
    e.preventDefault();
    Router.go("projectPage", {_id: this._id});
  }
});
