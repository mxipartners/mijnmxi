@validatePhoto = (photo) ->
  check photo, Match.ObjectIncluding
    bitmap: String
  ## Add additional checks here if necessary
  errors = []
  return errors
