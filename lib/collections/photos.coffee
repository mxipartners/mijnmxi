@Photos = new Mongo.Collection 'photos'

Photos.allow
  update: (userId, photo, fieldNames, modifier) -> false
  remove: (userId, photo) -> userId == photo.userId

Meteor.methods
  createPhoto: (photoAttributes) ->
    check Meteor.userId(), String
    validatePhoto photoAttributes
    user = Meteor.user()
    photo = _.extend photoAttributes,
      userId: user._id
      uploadTimestamp: new Date()
    photoId = Photos.insert photo
    return {_id: photoId}

@createPhoto = (photoAttributes) ->
  Meteor.call 'createPhoto', photoAttributes, (error, result) ->
    if error
      throwError error.reason
