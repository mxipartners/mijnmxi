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

# Mode of page (add to window to make it global)
window.PageMode = {
  create: "create"
  edit: "edit"
  view: "view"
}

# Create helpers for different modes
Object.keys(PageMode).forEach((mode) ->
  # Generate the name "in<mode>Mode" like "inEditMode"
  modeString = PageMode[mode]
  helperName = "in" + modeString.replace(/^[a-z]/, (firstChar) -> firstChar.toUpperCase()) + "Mode"

  # Add helper which can be used in templates to test for a specific page mode (like in {{#if inEditMode}})
  Template.registerHelper(helperName, ->
    return this.mode == modeString
  )
)

# Add simple localStorage implementation if one is not present
if !window.localStorage
  window.localStorage = {
    keysAndValues: {}
    getItem: (key) -> this.keysAndValues[key]
    setItem: (key, value) -> this.keysAndValues[key] = value
    removeItem: (key) -> delete this.keysAndValues[key]
  }
