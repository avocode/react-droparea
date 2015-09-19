React = require 'react'
{div} = React.DOM
Dragarea = React.createFactory(require '../')

App = React.createClass

  _onDrop: (file) ->
    console.log file

  _onRootDrop: ->
    console.log 'root'

  _testClick: ->
    @refs.dragarea.open()

  render: ->
    div
      className: 'wrapper'
      onClick: @_testClick,

      Dragarea
        ref: 'dragarea'
        onDrop: @_onRootDrop,

        div className: 'container',

          for item in [1..10]
            Dragarea
              className: 'droparea-item'
              shouldParentBeActiveWhenHovering: false
              key: item
              onDrop: @_onDrop,
                div null, 'Totally placeholder 1'
                div null, 'Totally placeholder 2'
                div null, 'Totally placeholder 3'

React.render(React.createElement(App), document.getElementById('app'))
