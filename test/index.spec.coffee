jsdom = require 'jsdom'
chai = require 'chai'
sinonChai = require 'sinon-chai'
sinon = require 'sinon'


describe 'Droparea component', ->
  baseProps = null

  simulant = null
  Mousetrap = null
  Droparea = null
  ReactDOM = null
  React = null
  enzyme = null

  chai.use(sinonChai)
  expect = chai.expect

  beforeEach ->
    global.document = jsdom.jsdom('<html><body></body></html>')
    global.window = document.defaultView
    global.Image = window.Image
    global.navigator = window.navigator
    global.CustomEvent = window.CustomEvent
    simulant = require 'simulant'
    ReactDOM = require 'react-dom'
    React = require 'react'
    enzyme = require 'enzyme'
    chaiEnzyme = require 'chai-enzyme'

    chai.use(chaiEnzyme())

    Droparea = require '../'

    baseProps =
      onDragEnter: sinon.spy()
      onDragLeave: sinon.spy()
      onDrop: sinon.spy()

  it 'should render component', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.find('.droparea')).to.have.length(1)

  it 'should have `disableClick` prop set to false by default', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().disableClick).to.be.equal(false)

  it 'should have `onDragEnter` prop', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().onDragEnter).to.be.a.function

  it 'should have `onDragLeave` prop', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().onDragLeave).to.be.a.function

  it 'should have `onDrop` prop', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().onDrop).to.be.a.function

  it 'should have `dropEffect` prop set to `copy` by default', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().dropEffect).to.be.equal('copy')

  it 'should have `className` prop set to `droparea` by default', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().className).to.be.equal('droparea')

  it 'should have `activeClassName` prop set to `active` by default', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().activeClassName).to.be.equal('active')

  it 'should have `multiple` prop set to `true` by default', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().multiple).to.be.equal(true)

  it 'should have `supportedFormats` prop set to empty array by default', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    expect(wrapper.props().supportedFormats).to.be.eql([])

  it 'should have `active` className when entering a droparea', (callback) ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    node = ReactDOM.findDOMNode(wrapper.instance())
    node.dispatchEvent(new CustomEvent('dragster:enter'))

    setImmediate =>
      expect(wrapper.find('.droparea.active')).to.have.length(1)
      callback()

  it 'should have custom className when entering a droparea', (callback) ->
    props = Object.assign {}, baseProps,
      activeClassName: 'testing'
    dropareaComponent = React.createElement(Droparea, props)
    wrapper = enzyme.mount(dropareaComponent)

    node = ReactDOM.findDOMNode(wrapper.instance())
    node.dispatchEvent(new CustomEvent('dragster:enter'))

    setImmediate =>
      expect(wrapper.find('.droparea.testing')).to.have.length(1)
      callback()

  it 'should call `onDragEnter` callback when entering a droparea', (callback) ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    node = ReactDOM.findDOMNode(wrapper.instance())
    node.dispatchEvent(new CustomEvent('dragster:enter'))

    setImmediate =>
      expect(wrapper.props().onDragEnter).to.have.been.called
      callback()

  it 'should call `onDragLeave` callback when leaving a droparea', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    node = ReactDOM.findDOMNode(wrapper.instance())
    node.dispatchEvent(new CustomEvent('dragster:leave'))

    expect(wrapper.props().onDragLeave).to.have.been.called

  it 'should call `onDrop` callback', ->
    dropareaComponent = React.createElement(Droparea, baseProps)
    wrapper = enzyme.mount(dropareaComponent)

    node = ReactDOM.findDOMNode(wrapper.instance())
    node.dispatchEvent(new CustomEvent('drop'))

    expect(wrapper.props().onDrop).to.have.been.called
