@Photos = new Mongo.Collection 'photos'

Photos.allow
  update: (userId, photo, fieldNames, modifier) -> false
  remove: (userId, photo) -> userId == photo.userId

@createPhoto = (photoAttributes) ->
  check Meteor.userId(), String
  user = Meteor.user()
  photo = _.extend photoAttributes,
    userId: user._id
    uploadTimestamp: new Date()
  photoId = Photos.insert photo
  return {_id: photoId}
