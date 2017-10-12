this.UnreadItems = new Mongo.Collection("unreadItems");

// Document:
//  {
//    "_id": "<id of UnreadItems>",
//    "userId": "<id of user>",
//    "projectId": "<id of project>",
//    "messages": [
//      "<id of message>",
//      ...
//    ]
//  }
//
// Chosen to have projects as Object instead of Array since updating nested Arrays is not supported.
//

//UnreadItems.allow({
//  update: function(userId, unreadItems) {
//    return true;
//  }
//});

Meteor.methods({
  updateUnreadItems: function(project, messageId) {

    // Only run this on the server
    if(this.isSimulation) {
      return;
    }

    // Validate input
    validateProject(project);
    check(messageId, String);

    // Remove UnreadItems for non-members
    var removeResult = UnreadItems.remove(
      // Selector
      {
        userId: { $nin: project.members },
        projectId: project._id
      }
    );
    if(removeResult.writeConcernError) {
      throwError(removeResult.writeConcernError);
    }

    // Add UnreadItems for new users
    project.members.forEach(function(member) {
      var unreadItems = UnreadItems.findOne({ userId: member, projectId: project._id });
      if(!unreadItems) {

        // No UnreadItems exists for this user, create document
        UnreadItems.insert({ userId: member, projectId: project._id, messages: [] });
      }
    });

    // Update UnreadItems for members
    UnreadItems.update(
      // Selector
      {
        userId: { $ne: Meteor.userId() },
        projectId: project._id,
      },
      // Modifier
      {
        $addToSet: { messages: messageId }
      },
      // Options
      {
        multi: true
      },
      // Callback
      function(error, result) {
        if(error) {
          throwError(error);
        }
      }
    );
  },
  messagesRead: function(projectId) {

    // Only run this on the server
    if(this.isSimulation) {
      return;
    }

    // Validate input
    check(projectId, String);

    UnreadItems.update(
      // Selector
      {
        userId: Meteor.userId(),
        projectId: projectId
      },
      // Modifier
      {
        $set: { messages: [] }
      },
      // Options
      {
        multi: false
      },
      // Callback
      function(error, result) {
        if(error) {
          throwError(error);
        }
      }
    );
  }
});
