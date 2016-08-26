React = require 'react'
ReactDOM = require 'react-dom'
{div} = React.DOM
Dragarea = React.createFactory(require '../')

App = React.createClass
  getInitialState: ->
    isActive: false

  _onDrop: (file) ->
    document.title = 'testing'
    console.log file

  _onRootDrop: ->
    @setState({ isActive: false })
    document.title = 'testing'
    console.log 'root'

  _handleDragEnter: (e) ->
    @setState({ isActive: true })

  _handleDragLeave: (e) ->
    console.log 'dragleave'
    @setState({ isActive: false })

  _handleChildDragEnter: (e) ->
    @setState({ isActive: false })

  _handleChildDragLeave: (e) ->
    @setState({ isActive: true })

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
        className: @state.isActive and 'is-active droparea' or 'droparea'
        onDragEnter: @_handleDragEnter
        onDragLeave: @_handleDragLeave
        onDrop: @_onRootDrop,

        div className: 'container',

          for index in [1..80]

            Dragarea
              className: 'droparea-item' + ' index' + index
              key: index
              onDrop: @_onDrop,
                div null, 'Totally placeholder 1'
                div null, 'Totally placeholder 2'
                div null, 'Totally placeholder 3'


ReactDOM.render(React.createElement(App), document.getElementById('app'))
