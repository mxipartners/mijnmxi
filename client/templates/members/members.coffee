Template.members.onCreated ->
  Session.setDefault 'selectedMembers', []

Template.members.helpers
  project_members: ->
    project = Template.parentData()
    return Meteor.users.find {_id: {$in: project.members}}, {sort: {username: 1}}

Template.members.events
  'change .select_member': (e) ->
    e.preventDefault()

    user_id = $(e.target).val()
    selected_members = Session.get('selectedMembers').slice()
    if e.target.checked
      selected_members.push user_id
    else
      index = selected_members.indexOf user_id
      selected_members.splice(index, 1)
    Session.set('selectedMembers', selected_members)
    console.log Session.get('selectedMembers')
