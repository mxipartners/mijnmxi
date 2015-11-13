Template.members.onCreated ->
  Session.setDefault 'selectedMembers', [Meteor.userId]

Template.members.helpers
  project_members: ->
    project = Template.parentData()
    return Meteor.users.find {_id: {$in: project.members}}, {sort: {username: 1}}
