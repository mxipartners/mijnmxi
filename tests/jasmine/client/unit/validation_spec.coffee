title_error =
  title: jasmine.any(String)


describe 'An item', ->

  it 'is valid when it has a title', ->
    expect(validateItem({title: 'Title'})).toEqual {}

  it 'is valid when it has a title and a description', ->
    expect(validateItem({title: 'Title', 'description': 'Description'})).toEqual {}

  it 'is invalid when it has an empty title', ->
    expect(validateItem({title: ''})).toEqual title_error

  it 'is invalid when it has no title', ->
    expect(validateItem({})).toEqual {title: 'Een titel is verplicht' }

  it 'is invalid when the title is not a string', ->
    expect( -> validateItem({title: 10})).toThrowError Match.Error

  it 'is invalid when the description is not a string', ->
    expect( -> validateItem({title: 'Title', 'description': 10})).toThrowError Match.Error


describe 'A project', ->

  beforeEach ->
    this.project =
      title: 'Title'
      members: ['Dummy user']

  it 'is valid when it has a title and at least one project member', ->
    expect(validateProject(this.project)).toEqual {}

  it 'is invalid when it has no title', ->
    this.project.title = ''
    expect(validateProject(this.project)).toEqual title_error

  it 'is invalid when it has no members', ->
    this.project.members = []
    expect(validateProject(this.project)).toEqual
      members: jasmine.any(String)

  it 'is invalid when it has no title and no members', ->
    this.project.title = ''
    this.project.members = []
    expect(validateProject(this.project)).toEqual
      title: jasmine.any(String)
      members: jasmine.any(String)

  it 'is invalid when the members is not an array of strings', ->
    this.project.members = [10]
    expect( -> validateItem(this.project)).toThrowError Match.Error
