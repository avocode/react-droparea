
describe 'test', ->

  it 'should', ->
    browser.url('/').getTitle().then (title) ->
      expect(title).to.be('Dragarea')
