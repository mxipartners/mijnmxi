Template.photoItem.helpers
  submitted_date: -> this.uploadTimestamp.toString()
  author_name: -> Meteor.users.findOne(this.userId).username
