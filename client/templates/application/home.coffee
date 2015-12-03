Template.home.helpers
  projects: -> Projects.find {}, {sort: {submitted: -1}}
  kind: -> Session.get 'currentHomeTab'

Template.home.onCreated ->
  Session.setDefault 'currentHomeTab', 'project'

Template.home.onRendered ->
  current = this.$('a[href="#' + Session.get('currentHomeTab') + '"]')
  current.tab 'show'

Template.home.events
  'shown.bs.tab': (e) ->
    Session.set 'currentHomeTab', e.target.href.split('#')[1]
  'click .add-kind': (e) ->
    start_submitting Session.get 'currentHomeTab'
