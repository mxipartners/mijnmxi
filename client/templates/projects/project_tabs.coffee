Template.projectTabs.onCreated ->
  Session.setDefault 'currentProjectTab', 'members'

Template.projectTabs.onRendered ->
  current = this.$('a[href="#' + Session.get('currentProjectTab') + '"]')
  current.tab 'show'

Template.projectTabs.events
  'shown.bs.tab': (e) ->
    Session.set 'currentProjectTab', e.target.href.split('#')[1]
  'click .add-kind': (e) ->
    start_submitting Session.get 'currentProjectTab'

Template.projectTabs.helpers
  translated_kind: -> TAPi18n.__ Session.get 'currentProjectTab'
  member_count: ->
    project = Template.parentData()
    return project.members.length

  can_add_item: ->
    currentTab = Session.get 'currentProjectTab'
    return false
