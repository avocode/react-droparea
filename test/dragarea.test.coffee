expect = require 'expect.js'

describe 'Dragarea test', ->

  client = browser.url('/')

  it 'should work', ->

    # client.getTitle().then (title) ->
    #   expect(title).to.be('Dragarea')

    client.waitForExist('.loaded').then ->
      @moveToObject('.draggable').buttonDown().moveToObject('.droparea', 80, 80).buttonUp().then ->
        client.execute -> document.title
        .then (result) ->
          expect(result.value).to.be('testing')


      # @dragAndDrop('.draggable', '.droparea-item').then ->
      #   @pause(1000).then -> @execute -> document.title
      #   .then (result) ->
      #     console.log result.value

    # client.dragAndDrop('.draggable', '.droparea').then ->
    #   client.execute -> document.title
    #   .then (result) ->
    #     expect(result.value).to.be('testing')
