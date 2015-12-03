Template.projectTabs.onCreated ->
  Session.setDefault 'currentProjectTab', 'foto'
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
