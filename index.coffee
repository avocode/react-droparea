Dragster = require 'dragster-avocode-fork'
React = require 'react'
ReactDOM = require 'react-dom'
{div, input} = React.DOM


Droparea = React.createClass
  displayName: 'Droparea'

  propTypes:
    disableClick: React.PropTypes.bool
    onDrag: React.PropTypes.func
    dropEffect: React.PropTypes.string
    onDrop: React.PropTypes.func
    className: React.PropTypes.string
    activeClassName: React.PropTypes.string
    draggingClassName: React.PropTypes.string
    multiple: React.PropTypes.bool
    supportedFormats: React.PropTypes.arrayOf(React.PropTypes.string)
    onDropStopPropagation: React.PropTypes.bool

  _domElement: null

  getDefaultProps: ->
    dropEffect: 'copy'
    disableClick: false
    className: 'droparea'
    activeClassName: 'active'
    draggingClassName: ''
    multiple: true
    supportedFormats: []
    onDropStopPropagation: true

  getInitialState: ->
    dragging: false
    dropActive: false

  componentDidMount: ->
    @_domElement = ReactDOM.findDOMNode(this)

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
    @refs.fileInput.click()

  _onDragOver: (e) ->
    e.preventDefault()
    e.stopPropagation()
    e.dataTransfer.dropEffect = @props.dropEffect if e.dataTransfer

  _onChildDragLeave: (e) ->
    if e.target isnt ReactDOM.findDOMNode(this)
      e.stopPropagation()
      @setState(dropActive: true)
      @_handleOnDrag(true)

  _onChildDragEnter: ->
    if e.target isnt ReactDOM.findDOMNode(this)
      @setState(dropActive: false)
      @_handleOnDrag(false)

  _onDragLeave: (e) ->
    e.stopPropagation()
    @_customEventFactory('dragarea:dragleave')
    @_handleOnDrag(false)

    @setState
      dropActive: false
      dragging: false

  _onDragEnter: (e) ->
    e.stopPropagation()

    if @props.supportedFormats.length
      files = @_getFilesFromEvent(e)
      files = @_filterFiles([].slice.call(files))
      return unless files.length

    # NOTE: always fire after dragleave
    setImmediate =>
      @_customEventFactory('dragarea:dragenter')
      @_handleOnDrag(true)

      @setState
        dropActive: true
        dragging: true

  _filterFiles: (files) ->
    regex = new RegExp("^.*\\.(#{@props.supportedFormats.join('|')})$")
    files.filter ({name}) -> regex.test(name)

  _onDrop: (e) ->
    e.preventDefault()
    e.stopPropagation() if @props.onDropStopPropagation

    @setState
      dropActive: false
      dragging: false

    @_handleOnDrag(false)

    files = @_getFilesFromEvent(e)

    if @props.onDrop
      files = [].slice.call(files)
      files = @_filterFiles(files) if @props.supportedFormats.length
      @props.onDrop(files)

    @_customEventFactory('dragarea:dropped')

  _onDroppped: ->
    @_dragster.reset()

    @setState
      dropActive: false
      dragging: false

    @_handleOnDrag(false)

  _onClick: (e) ->
    unless @props.disableClick
      e.stopPropagation()
      @refs.fileInput.click()

  _handleOnDrag: (state) ->
    if @props.onDrag?
      @props.onDrag(state)

  _getFilesFromEvent: (e) ->
    e = e.detail if e.detail

    if e.dataTransfer
      files = e.dataTransfer.files
    else if e.target
      files = e.target.files

    return files

  _customEventFactory: (eventName) ->
    @_domElement.dispatchEvent new CustomEvent eventName,
      bubbles: true
      cancelable: true

  render: ->
    className = @props.className
    className += " #{@props.activeClassName}" if @state.dropActive
    className += " #{@props.draggingClassName}" if @state.dragging

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
