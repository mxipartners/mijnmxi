# Hack to access parentTemplate. Code taken from:
#   http://stackoverflow.com/questions/27949407/how-to-get-the-parent-template-instance-of-the-current-template
Blaze.TemplateInstance.prototype.parentTemplate = (levels) ->
  view = this.view
  if typeof levels is "undefined"
    levels = 1
  while(view)
    if (view.name.substring(0, 9) is "Template." && !(levels--))
      return view.templateInstance()
    view = view.parentView
