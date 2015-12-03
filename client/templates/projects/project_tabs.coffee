Template.projectTabs.onCreated ->
  Session.setDefault 'currentProjectTab', 'projectlid'
  self = this
  self.autorun ->
    self.subscribe "photos", Template.parentData()._id

Template.projectTabs.onRendered ->
  current = this.$('a[href="#' + Session.get('currentProjectTab') + '"]')
  current.tab 'show'

Template.projectTabs.events
  'shown.bs.tab': (e) ->
    Session.set 'currentProjectTab', e.target.href.split('#')[1]
  'click .add-kind': (e) ->
    start_submitting Session.get 'currentProjectTab'

Template.projectTabs.helpers
  photos: -> Photos.find {}, {sort: {uploadTimestamp: -1}}
  kind: -> Session.get 'currentProjectTab'
  member_count: ->
    project = Template.parentData()
    return project.members.length

  can_add_item: ->
    currentTab = Session.get 'currentProjectTab'
    # Check if add-functionality is allowed. Now always true
    return currentTab != 'projectlid'
