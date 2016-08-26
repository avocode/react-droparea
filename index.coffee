Dragster = require 'dragster-avocode-fork'
React = require 'react'
ReactDOM = require 'react-dom'

{div, input} = React.DOM


Droparea = React.createClass
  displayName: 'Droparea'

  propTypes:
    disableClick: React.PropTypes.bool
    onDragEnter: React.PropTypes.func
    onDragEnterStopPropagation: React.PropTypes.bool
    onDragLeave: React.PropTypes.func
    onDragLeaveStopPropagation: React.PropTypes.bool
    onDrop: React.PropTypes.func
    onDropStopPropagation: React.PropTypes.bool
    dropEffect: React.PropTypes.string
    className: React.PropTypes.string
    activeClassName: React.PropTypes.string
    multiple: React.PropTypes.bool
    supportedFormats: React.PropTypes.arrayOf(React.PropTypes.string)

  _domElement: null

  getDefaultProps: ->
    dropEffect: 'copy'
    disableClick: false
    className: 'droparea'
    activeClassName: 'active'
    multiple: true
    supportedFormats: []
    onDragEnterStopPropagation: false
    onDragLeaveStopPropagation: false
    onDropStopPropagation: false

  getInitialState: ->
    dropareaActive: false

  componentDidMount: ->
    @_domElement = ReactDOM.findDOMNode(this)

    @_dragster = new Dragster(@_domElement)
    @_domElement.addEventListener 'drop', @_onDrop
    @_domElement.addEventListener 'dragover', @_onDragOver
    @_domElement.addEventListener 'dragarea:dropped', @_onDroppped
    @_domElement.addEventListener 'dragster:leave', @_onDragLeave
    @_domElement.addEventListener 'dragster:enter', @_onDragEnter

  componentWillUnmount: ->
    @_domElement.removeEventListener 'drop', @_onDrop
    @_domElement.removeEventListener 'dragover', @_onDragOver
    @_domElement.removeEventListener 'dragarea:dropped', @_onDroppped
    @_domElement.removeEventListener 'dragster:leave', @_onDragLeave
    @_domElement.removeEventListener 'dragster:enter', @_onDragEnter
    @_dragster.removeListeners()
    @_dragster = null

  open: ->
    @refs.fileInput.click()

  _dragEnterTimeout: null

  _onDragOver: (e) ->
    e.preventDefault()
    e.stopPropagation()

    if e.dataTransfer
      e.dataTransfer.dropEffect = @props.dropEffect

  _onDragLeave: (e) ->
    e.stopPropagation() if @props.onDragLeaveStopPropagation

    clearImmediate(@_dragEnterTimeout)
    @props.onDragLeave?(e)
    @setState({ dropareaActive: false })

  _onDragEnter: (e) ->
    if @props.supportedFormats.length
      files = @_getFilesFromEvent(e)
      files = @_filterFiles([].slice.call(files))
      if !files.length
        return

    e.stopPropagation() if @props.onDragEnterStopPropagation

    @_dragEnterTimeout = setImmediate =>
      @props.onDragEnter?(e)
      @setState({ dropareaActive: true })

  _filterFiles: (files) ->
    regex = new RegExp("^.*\\.(#{@props.supportedFormats.join('|')})$")
    files = files.filter ({name}) -> regex.test(name)
    return files

  _onDrop: (e) ->
    e.preventDefault()
    e.stopPropagation() if @props.onDropStopPropagation

    files = @_getFilesFromEvent(e)

    if @props.onDrop
      if files
        files = [].slice.call(files)
        files = @_filterFiles(files) if @props.supportedFormats.length
      @props.onDrop(e, files or [])

    @_fireCustomEvent('dragarea:dropped')

  _onDroppped: ->
    @_dragster.reset()
    @setState({ dropareaActive: false })

  _handleClick: (e) ->
    if !@props.disableClick
      e.stopPropagation()
      @refs.fileInput.click()

  _getFilesFromEvent: (e) ->
    if e.detail
      e = e.detail

    if e.dataTransfer
      files = e.dataTransfer.files
    else if e.target
      files = e.target.files

    return files

  _fireCustomEvent: (eventName) ->
    @_domElement.dispatchEvent new CustomEvent eventName,
      bubbles: true
      cancelable: true

  render: ->
    className = @props.className
    className += " #{@props.activeClassName}" if @state.dropareaActive

    div
      className: className
      onClick: @_handleClick,

      input
        style: display: 'none'
        type: 'file'
        ref: 'fileInput'
        onChange: @_onDrop
        multiple: @props.multiple

      @props.children


module.exports = Droparea
