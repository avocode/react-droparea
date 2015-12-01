React = require 'react'
{div} = React.DOM
Dragarea = React.createFactory(require '../')

App = React.createClass

  getInitialState: ->
    isActive: false

  _onDrop: (file) ->
    document.title = 'testing'
    console.log file

  _onRootDrop: ->
    document.title = 'testing'
    console.log 'root'

  _handleActive: (state) ->
    console.log 'ted', Date.now
    @setState(isActive: state)

  componentDidMount: ->
    document.body.classList.add('loaded')

  render: ->

    div
      className: 'wrapper',

      div
        className: 'draggable'
        draggable: true

      Dragarea
        ref: 'dragarea'
        draggingClassName: 'dragging'
        onDrag: @_handleOnDrag
        onDrop: @_onRootDrop,

        div className: 'container',

          for index in [1..800]

            Dragarea
              className: 'droparea-item'
              activeClassName: @state.isActive and 'active' or ''
              onDragActive: @_handleActive
              shouldParentBeActiveWhenHovering: false
              key: index
              onDrop: @_onDrop,
                div null, 'Totally placeholder 1'
                div null, 'Totally placeholder 2'
                div null, 'Totally placeholder 3'

React.render(React.createElement(App), document.getElementById('app'))
