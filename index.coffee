Dragster = require 'dragster-avocode-fork'
React = require 'react'
{div, input} = React.DOM

_enter = 0
_leave = 0

Droparea = React.createClass

  displayName: 'Droparea'

  propTypes:
    disableClick: React.PropTypes.bool
    onDragActive: React.PropTypes.func
    dropEffect: React.PropTypes.string
    onDrop: React.PropTypes.func.isRequired
    className: React.PropTypes.string
    activeClassName: React.PropTypes.string
    multiple: React.PropTypes.bool
    supportedFormats: React.PropTypes.arrayOf(React.PropTypes.string)
    shouldParentBeActiveWhenHovering: React.PropTypes.bool

  _domElement: null

  getDefaultProps: ->
    dropEffect: 'copy'
    disableClick: false
    className: 'droparea'
    activeClassName: 'active'
    multiple: true
    supportedFormats: []
    shouldParentBeActiveWhenHovering: true

  getInitialState: ->
    dragActive: false
    shouldComponentBeActive: !@props.shouldParentBeActiveWhenHovering

  componentDidMount: ->
    @_domElement = @getDOMNode()

    @_dragster = new Dragster(@_domElement)
    @_domElement.addEventListener 'drop', @_onDrop
    @_domElement.addEventListener 'dragover', @_onDragOver
    @_domElement.addEventListener 'dragarea:dropped', @_onDroppped
    @_domElement.addEventListener 'dragarea:dragenter', @_onChildDragEnter
    @_domElement.addEventListener 'dragarea:dragleave', @_onChildDragLeave
    @_domElement.addEventListener 'dragster:leave', @_onDragLeave
    @_domElement.addEventListener 'dragster:enter', @_onDragEnter

  componentWillUnmount: ->
    @_domElement.removeEventListener 'drop', @_onDrop
    @_domElement.removeEventListener 'dragover', @_onDragOver
    @_domElement.removeEventListener 'dragarea:dropped', @_onDroppped
    @_domElement.removeEventListener 'dragarea:dragenter', @_onChildDragEnter
    @_domElement.removeEventListener 'dragarea:dragleave', @_onChildDragLeave
    @_domElement.removeEventListener 'dragster:leave', @_onDragLeave
    @_domElement.removeEventListener 'dragster:enter', @_onDragEnter
    @_dragster.removeListeners()
    @_dragster = null

  open: ->
    @refs.fileInput.getDOMNode().click()

  _onDragOver: (e) ->
    e.preventDefault()
    e.stopPropagation()

    e.dataTransfer.dropEffect = @props.dropEffect if e.dataTransfer

  _onChildDragLeave: ->
    unless @state.shouldComponentBeActive
      @_setActiveState(true)

  _onChildDragEnter: ->
    unless @state.shouldComponentBeActive
      @_setActiveState(false)

  _onDragLeave: (e) ->
    e.stopPropagation()

    _leave += 1

    unless @props.shouldParentBeActiveWhenHovering
      if _enter == _leave + 1
        @_customEventFactory('dragarea:dragleave')

    @_setActiveState(false)

  _onDragEnter: (e) ->
    e.stopPropagation()

    _enter += 1

    unless @props.shouldParentBeActiveWhenHovering
      @_customEventFactory('dragarea:dragenter')

    if @props.supportedFormats.length
      files = @_getFilesFromEvent(e)
      files = @_filterFiles([].slice.call(files))

      return unless files.length

    @_setActiveState(true)

  _filterFiles: (files) ->
    regex = new RegExp("^.*\\.(#{@props.supportedFormats.join('|')})$")
    files.filter ({name}) -> regex.test(name)

  _onDrop: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @_setActiveState(false)

    files = @_getFilesFromEvent(e)

    if @props.onDrop
      files = [].slice.call(files)
      files = @_filterFiles(files) if @props.supportedFormats.length
      @props.onDrop(files)

    @_customEventFactory('dragarea:dropped')

  _onDroppped: ->
    _enter = 0
    _leave = 0
    @_dragster.reset()
    @_setActiveState(false)

  _onClick: (e) ->
    e.stopPropagation()
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

  _customEventFactory: (eventName) ->
    @_domElement.dispatchEvent new CustomEvent eventName,
      bubbles: true
      cancelable: true

  render: ->
    className = @props.className
    className += " #{@props.activeClassName}" if @state.dragActive

    div
      className: className
      onClick: @_onClick,

      input
        style: display: 'none'
        type: 'file'
        ref: 'fileInput'
        onChange: @_onDrop
        multiple: @props.multiple

      @props.children


module.exports = Droparea
