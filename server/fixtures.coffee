# server/fixtures.coffee

if Photos.find().count() == 0
  [
    {userId : 1, uploadTimestamp : 123456789}
    {userId : 2, uploadTimestamp : 123456789}
  ].forEach (data) -> Photos.insert(data)
