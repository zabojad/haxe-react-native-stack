---
---
# Haxe and React

*This part of the documentation assumes that you are already familiar with React and the JSX syntax. If not, please take some time to learn about it on the [official React documentation](https://reactjs.org/).*

To use React with Haxe, we need two things:
- Haxe externs (type definitions) to manipulate the React Component API in a type safe way and to render our components.
- Ideally, some way to use the JSX syntax. JSX syntax is not javascript and requires a babel plugin to be converted to javascript.

All of this is implemented in the [haxe-react](https://github.com/massiveinteractive/haxe-react) library, which is central to the Haxe part of our stack.

Note that the version 1.0.0 of this stack uses `haxe-react` version `1.4.0`. Later version of the stack will use newer version of `haxe-react` which bring great improvments and go deeper into the integration which Haxe (like with the JSX syntax for example). You can already use some of those improvments by using the [haxe-react #next](https://github.com/kLabz/haxe-react) fork of this haxelib.

## React API without and with JSX

The basic API to create components with React is `React.createElement`:

```haxe
import api.react.React;
import api.react.ReactDOM;

import js.Browser.document;

class TryReact extends ReactComponent {

    static function main(){
        // here we user Reactjs, not React native (yet)
        ReactDOM.render(React.createElement(TryReact), document.getElementById('app'));
    }

    function render() {
        var cn = 'foo';
        return React.createElement('div', {className:cn}, [ React.createElement('div', {className:cn}, ["Awesome!"]) ]);
    }
}
```

If you've used React before or read some React examples on some documentation, you will notice that most of the time, they use JSX. It's because the JSX syntax is easily readable and brings a lot of clarity to your code over the pure javascript rendering API.

```haxe
import api.react.React;
import api.react.ReactDOM;
import api.react.ReactMacro.jsx;

import js.Browser.document;

class TryReact extends ReactComponent {

    static function main(){
        // here we user Reactjs, not React native (yet)
        ReactDOM.render(React.createElement(TryReact), document.getElementById('app'));
    }

    function render() {
        var cn = 'foo';
        return jsx('<div className={cn}>Awesome!</div>');
    }
}
```

## React Components

The entire React API is implemented in `haxe-react`.

It means that your components can extends `ReactComponent`, `PureComponent` or just be js functions.

In the case they inherit `ReactComponent`, you can type your component's props and state with [type parameters](https://haxe.org/manual/type-system-type-parameters.html):

```haxe
import react.ReactComponent;

typedef TryReactProps = {
    // ...
}
typedef TryReactState = {
    // ...
}

// example of a comp with props typed
class TryReact extends ReactComponentOfProps<TryReactProps> {
    // ...
}
// example of a comp with internal state typed
class TryReact extends ReactComponentOfState<TryReactState> {
    // ...
}
// example of a comp with both props and state typed
class TryReact extends ReactComponentOfPropsAndState<TryReactProps, TryReactState> {
    // ...
}
```

The same applies to `PureComponent`:
```haxe
import react.PureComponent;

typedef TryReactProps = {
    // ...
}
typedef TryReactState = {
    // ...
}

// props and state not typed
class TryReact extends PureComponent {
    // ...
}
// props typed and state not typed
class TryReact extends PureComponentOfProps<TryReactProps> {
    // ...
}
// props not typed and state typed
class TryReact extends PureComponentOfState<TryReactState> {
    // ...
}
// props and state typed
class TryReact extends PureComponentOfPropsAndState<TryReactProps, TryReactState> {
    // ...
}
```

As we are in an object oriented language, and that our component class actually extends another class, the ReactComponent lifecycle methods needs to be overriden if we want to make use of them.

```haxe
import react.ReactComponent;

typedef TryReactProps = {
    foo:String
}
typedef TryReactState = {
    bar:Int
}

// example of a comp with props typed
class TryReact extends ReactComponentOfPropsAndState<TryReactProps, TryReactState> {
    function new(p:TryReactProps){
        super(p);
        // add here anything you'd like at comp instance initialization
        this.state = { bar:p.length }
    }
    override function componentDidMount():Void{
        // do some one time stuff once the component is mounted
    }
    override function componentWillUnmount():Void{
        // do some cleaning just before the component is unmounted
    }
    override function shouldComponentUpdate(nextProps:TryReactProps,nextState:TryReactState):Bool{
        return props.foo.length!=nextProps.foo.length;
    }
    override function componentDidUpdate(prevProps:TryReactProps, prevState:TryReactState):Void{
        // here, you can trigger things based of comparisons of previous and current state/props
        if (prevProps.foo!=props.foo){
            alert('foo changed!');
        }
    }
    // overriding render is mandatory
    override function render(){
        return jsx('
            <div>
                Foo is now {state.bar} long: {props.foo}
            </div>
        ');
    }
}

```

Note that some lifecycle methods are static like `getDerivedState` which allow to merge data from new incoming props into the component state:
```haxe 
import react.ReactComponent;

typedef TryReactProps = {
    foo:String
}
typedef TryReactState = {
    bar:Int
}

// example of a comp with props typed
class TryReact extends ReactComponentOfPropsAndState<TryReactProps, TryReactState> {
    static function getDerivedState(nextProps:TryReactProps,currentState:TryReactState):TryReactState{
        if (props.foo.length!=nextProps.foo.length){
            return { bar:nextProps.foo.length }; // merge new foo length in state.bar
        }
        return null; // don't merge anything in state
    }
    function new(p:TryReactProps){
        super(p);
        // add here anything you'd like at comp instance initialization
        this.state = { bar:p.length }
    }
    override function shouldComponentUpdate(nextProps:TryReactProps,nextState:TryReactState):Bool{
        return nextState!=state; // we can now have a simpler reference check here
    }
    override function render(){
        return jsx('
            <div>
                Foo is now {state.bar} long: {props.foo}
            </div>
        ');
    }
}
```

## Static components

A React component doesn't have to be a class. It can be a simple function. In that case, we call it a static component.

A static component is not subject to any lifecycle method. It is less costly to render but it won't have any optimization mechanism to avoid re-rendering if its props change. It also cannot have any internal state.

```haxe
import api.react.React;
import api.react.ReactDOM;

import js.Browser.document;

class MyApp {

    static function main(){
        // here we user Reactjs, not React native (yet)
        ReactDOM.render(React.createElement(TryReact), document.getElementById('app'));
    }
}
class TryReact extends ReactComponent {
    override function render(){
        return jsx('
            <div>
                Let\'s render some static component for a change: <StaticComp.render foo="bar" />
            </div>
        ');
    }
}
typedef StaticCompProps = {
    foo : String
}
class StaticComp {
    static public function render(props:StaticCompProps){
        return jsx('<span>Life as a static comp is simpler! I have only props: {props.foo}</span>');
    }
}
```

Note that `haxe-react` proposes a macro that make the use of static component cleaner and avoid some Rewriting in case you change a static component into a ReactComponent:
```haxe
import api.react.React;
import api.react.ReactDOM;

import js.Browser.document;

class MyApp {

    static function main(){
        // here we user Reactjs, not React native (yet)
        ReactDOM.render(React.createElement(TryReact), document.getElementById('app'));
    }
}
class TryReact extends ReactComponent {
    override function render(){
        return jsx('
            <div>
                Let\'s render some static component for a change: <StaticComp foo="bar" />
            </div>
        ');
    }
}
typedef StaticCompProps = {
    foo : String
}
@:jsxStatic('render')
class StaticComp {
    static public function render(props:StaticCompProps){
        return jsx('<span>Life as a static comp is simpler! I have only props: {props.foo}</span>');
    }
}
```

## Practicing

Let's play now with the `04-haxe-react` sample to see how the work done in the first three samples could be done when React enters the game. 
