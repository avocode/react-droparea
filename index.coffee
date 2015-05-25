Dragster = require 'dragster-avocode-fork'
React = require 'react'
{div, input} = require 'reactionary'

Droparea = React.createClass

  propTypes:
    disableClick: React.PropTypes.bool
    onDragActive: React.PropTypes.func
    dropEffect: React.PropTypes.string
    onDrop: React.PropTypes.func.isRequired
    className: React.PropTypes.string
    activeClassName: React.PropTypes.string
    multiple: React.PropTypes.bool
    supportedFormats: React.PropTypes.arrayOf(React.PropTypes.string)
    beActiveWhenHoveringDescendant: React.PropTypes.bool

  _domElement: null

  getDefaultProps: ->
    dropEffect: 'copy'
    disableClick: false
    className: 'droparea'
    activeClassName: 'active'
    multiple: true
    supportedFormats: []
    beActiveWhenHoveringDescendant: true

  getInitialState: ->
    dragActive: false

  componentDidMount: ->
    @_domElement = @getDOMNode()

    @_dragster = new Dragster(@_domElement)
    @_domElement.addEventListener 'drop', @_onDrop
    @_domElement.addEventListener 'dragover', @_onDragOver
    @_domElement.addEventListener 'dropped', @_onDroppped

    if @props.beActiveWhenHoveringDescendant
      @_domElement.addEventListener 'dragster:leave', @_onDragLeave
      @_domElement.addEventListener 'dragster:enter', @_onDragEnter
    else
      @_domElement.addEventListener 'dragleave', @_onDragLeave
      @_domElement.addEventListener 'dragenter', @_onDragEnter

  componentWillUnmount: ->
    @_domElement.removeEventListener 'drop', @_onDrop
    @_domElement.removeEventListener 'dragover', @_onDragOver
    @_domElement.removeEventListener 'dropped', @_onDroppped

    if @props.beActiveWhenHoveringDescendant
      @_domElement.removeEventListener 'dragster:leave', @_onDragLeave
      @_domElement.removeEventListener 'dragster:enter', @_onDragEnter
      @_dragster.removeListeners()
      @_dragster = null
    else
      @_domElement.removeEventListener 'dragleave', @_onDragLeave
      @_domElement.removeEventListener 'dragenter', @_onDragEnter

  _onDragOver: (e) ->
    e.preventDefault()
    e.stopPropagation()

    e.dataTransfer.dropEffect = @props.dropEffect if e.dataTransfer

  _onDragLeave: (e) ->
    e.stopPropagation()

    unless @props.beActiveWhenHoveringDescendant
      return if @_domElement isnt e.target

    @_setActiveState(false)

  _onDragEnter: (e) ->
    e.stopPropagation()

    unless @props.beActiveWhenHoveringDescendant
      return if @_domElement isnt e.target

    if @props.supportedFormats.length
      files = @_getFilesFromEvent(e)
      files = @_filterFiles([].slice.call(files))

      return unless files.length

    @_setActiveState(true)

  _filterFiles: (files) ->
    regex = new RegExp("^.*\\.(#{@props.supportedFormats.join('|')})$")
    files.filter ({name}) ->
      regex.test(name)

  _onDrop: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @_setActiveState(false)

    files = @_getFilesFromEvent(e)

    if @props.onDrop
      files = [].slice.call(files)
      files = @_filterFiles(files) if @props.supportedFormats.length
      @props.onDrop(files)

    @dispatchDroppedEvent()

  _onDroppped: ->
    @_dragster.reset()
    @_setActiveState(false)

  _onClick: ->
    @refs.fileInput.getDOMNode().click() unless @props.disableClick

  _setActiveState: (state) ->
    @setState
      dragActive: state

    @props.onDragActive(state) if @props.onDragActive?

  _getFilesFromEvent: (e) ->
    e = e.detail if e.detail

    if e.dataTransfer
      files = e.dataTransfer.files
    else if e.target
      files = e.target.files

  dispatchDroppedEvent: ->
    @_domElement.dispatchEvent new CustomEvent 'dropped',
      bubbles: true
      cancelable: true

  render: ->
    className = @props.className
    className += " #{@props.activeClassName}" if @state.dragActive

    div
      className: className
      onClick: @_onClick,

      input
        style: {display: 'none'}
        type: 'file'
        ref: 'fileInput'
        onChange: @_onDrop
        multiple: @props.multiple

      @props.children


module.exports = Droparea
