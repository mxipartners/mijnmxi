this.UserChannels = new Mongo.Collection('userChannels', {

  // Add transformation function which adds a count on the unread messages
  transform: function(userChannel) {
    userChannel.messageCount = Messages.find({
      project: userChannel.projectId,
      sent: { $gt: userChannel.lastSeen }
    }).count();

    return userChannel;
  }
});

UserChannels.allow({
  update: function(userId, userChannel) {
    return true;
  }
});
