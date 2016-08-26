# Droparea - HTML5 file Drag and Drop component

![](https://upx.cz/286)

## Instalation

`npm install react-droparea`

## Usage

    React = require 'react'
    {div} = React.DOM
    Dragarea = React.createFactory(require '../index')

    App = React.createClass

      _onDrop: (file) ->
        console.log file

      _onRootDrop: ->
        console.log 'root'

      render: ->
        div null,
          Dragarea
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

You can fiddle with prepared demo. Clone the repo, `npm install` and `npm start`.
Then visit `localhost:3000`.

## Options - React props

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

## Credits

This library is inspired by [react-dropzone](https://github.com/paramaggarwal/react-dropzone) by Param Aggarwal.
