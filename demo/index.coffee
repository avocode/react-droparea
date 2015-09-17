React = require 'react'
{div} = React.DOM
Dragarea = React.createFactory(require '../')

App = React.createClass

  _onDrop: (file) ->
    console.log file

  _onRootDrop: ->
    console.log 'root'

  render: ->
    div null,
      Dragarea
        beActiveWhenHoveringDescendant: false
        onDrop: @_onRootDrop,

        for item in [1..10]
          Dragarea
            className: 'droparea-item'
            key: item
            onDrop: @_onDrop,
              div 'Totally placeholder 1'
              div 'Totally placeholder 2'
              div 'Totally placeholder 3'

React.render(React.createElement(App), document.getElementById('app'))
