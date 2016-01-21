To **validate items** we check that they have a `title` and an optional
`description`.

Items can both be containers like projects, as well as
singular items such as sources and subjects.

    @validateItem = (item) ->

First, check that the item has the right structure.

      check item, Match.ObjectIncluding
        title: Match.Optional(String)
        description: Match.Optional(String)

Then, check that a title is present.

      errors = {}
      if item.title == ''
        if Meteor.isServer

When running on the server, a missing title is a fatal error.

          throw new Meteor.Error('invalid-item', 'You must add a title to an item')
        else

When running on the client, we will tell the user to provide a title.

          errors.title = "Een titel is verplicht"
      return errors
