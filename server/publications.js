Meteor.publish('projects', function() {
  return Projects.find({ members: this.userId });
});

Meteor.publish('projectMessages', function(projectId) {
  check(projectId, String);
  // Find all messages for the current project which have our user as sender or recipient
  return Messages.find(
    {
      $and: [
        {
          project: projectId
        },
        {
          $or: [
            { sender: this.userId },                  // User is the sender
            { recipients: { $size: 0 } },             // Everyone is addressed (recipients is empty)
            { recipients: { $in: [ this.userId ] } }  // User is a recipient
          ]
        }
      ]
    }, { sort: { sent: 1 } }
  );
});

Meteor.publish('allMessages', function() {
  return Messages.find(
    {
      $or: [
        { sender: this.userId },                      // User is the sender
        { recipients: { $size: 0 } },                 // Everyone is addressed (recipients is empty)
        { recipients: { $in: [this.userId] } }        // User is a recipient
      ]
    }, {sort: { sent: 1 } }
  );
});

Meteor.publish('usernames', function() {
  return Meteor.users.find({},
    {
      fields: {'emails': 1, '_id': 1, 'telephone_nr': 1, 'skype_id': 1, 'name': 1 }
    }
  );
});

Meteor.publish('unreadItems', function() {
  return UnreadItems.find({ userId: this.userId });
});
