# Droparea - HTML5 file Drag and Drop component

![](https://upx.cz/286)

## Instalation

`npm install react-droparea`

## Usage

    React = require 'react'
    {div} = require 'reactionary'
    Dragarea = React.createFactory(require '../index')

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

This example is available in demo folder. Just clone this repo, `npm install` and `npm start`.
Then visit `localhost:8080/demo`.

## Options - React props

    disableClick: React.PropTypes.bool
    onDragActive: React.PropTypes.func
    dropEffect: React.PropTypes.string
    onDrop: React.PropTypes.func.isRequired
    className: React.PropTypes.string
    activeClassName: React.PropTypes.string
    multiple: React.PropTypes.bool
    supportedFormats: React.PropTypes.arrayOf(React.PropTypes.string)
    beActiveWhenHoveringDescendant: React.PropTypes.bool

## Credits

This library is inspired by [react-dropzone](https://github.com/paramaggarwal/react-dropzone) by Param Aggarwal.
