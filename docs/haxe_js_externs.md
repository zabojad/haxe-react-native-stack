---
---
# External libraries

While implementing applications with React native, you will often need to use some extra npm libraries that bring some native module, js lib or UI component you need in your app.

Doing so when you code your app with Haxe (vs ES6) is not a problem, but requires one extra step to keep the advantages of using Haxe in a type safe way: writing the Haxe ["externs"](https://haxe.org/manual/target-javascript-external-libraries.html){:target="_blank"} of the lib you want to add.

It's more or less the equivalent of writing a type definition with Typescript, except that with Haxe, you *__can__* do better (if you want to) by e.g. defining an API for this lib that will better fit to the Haxe language or to your app use case.

You have plenty examples of Haxe externs you can look at for inspirations, from very sophisticated ones like [haxe-react](https://github.com/massiveinteractive/haxe-react){:target="_blank"}, to straight and trivial ones like [haxe-react-native-navigation](https://github.com/haxe-react/react-native-navigation){:target="_blank"}.

Here we will just explain the basics of writing what we could just call a type definition, ie: some extra typing `.hx` file that does not change the original API of the lib we add.

## Example

To illustrate that, let's take the example of some random and simple lib for react we could find on GitHub: [react-tabs](https://github.com/reactjs/react-tabs){:target="_blank"}.

When starting to write an extern, you will generally:
- start some new repo for it if it's some quite big lib and that you are sure you will use it extensively. In that case, you will probably share your extern on github so that other will use it as well and perhaps also improve it.
- keep it in your app src folder in an isolated package (usually starting with `js.react.native.`), because you are just trying the lib and you are not sure to keep it, or just because it's just some little lib which extern file just takes 1 minute to write.

In this example, we will be in the latter case.

One thing also to check before writing your extern:
- does the lib already has a typescript `.ts` type definition file? If it's the case, just convert it to Haxe, you will save time!
- checkout the lib documentation or API doc if it has one, but double check with the lib source file because the doc can be outdated and/or incomplete.

In our case, the lib API looks like that:
```js
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import "react-tabs/style/react-tabs.css";

export default () => (
  <Tabs>
    <TabList>
      <Tab>Title 1</Tab>
      <Tab>Title 2</Tab>
    </TabList>

    <TabPanel>
      <h2>Any content 1</h2>
    </TabPanel>
    <TabPanel>
      <h2>Any content 2</h2>
    </TabPanel>
  </Tabs>
);
```
and
```js
import { resetIdCounter } from 'react-tabs';

resetIdCounter();
ReactDOMServer.renderToString(...);
```

We thus have at least 4 React components from that lib, plus some pure js API (`resetIdCounter()`).

Let's start with the React components:
- Let's create a folder under `src/js/react/tabs`.
- Create there a `Tabs.hx` file with the following content:
```haxe
package js.react.tabs; // matches our src folder structure

import react.ReactComponent;

typedef TabsProps = {
    ?selectedIndex:Int,
    ?selectedTabClassName:String,
    ?selectedTabPanelClassName:String,
    ?onSelect:Int->?Int->?js.html.Event->?Bool, // check https://api.haxe.org/js/html/Event.html
    ?className:String,
    ?defaultFocus:Bool,
    ?defaultIndex:Int,
    ?disabledTabClassName:String,
    ?domRef:js.html.Element->Void, // check https://api.haxe.org/js/html/Element.html
    ?forceRenderTabPanel:Bool,
}

 // here, we define an external React component which accepts props typed as TabsProps
@:jsRequire('react-tabs','Tabs')
extern class Tabs extends ReactComponentOfProps<TabsProps> {}

@:jsRequire('react-tabs','Tab')
extern class Tab extends ReactComponent {} // we do not type its props for now

@:jsRequire('react-tabs','TabList')
extern class TabList extends ReactComponent {} // we do not type its props for now

@:jsRequire('react-tabs','TabPanel')
extern class TabPanel extends ReactComponent {} // we do not type its props for now

@:jsRequire('react-tabs')
extern class ReactTabs {
    static public function resetIdCounter() : Void;
}
```
- At this point, we should have a working extern that is more that sufficient to run the equivalent of the lib README sample above with Haxe:
```haxe
import js.react.tabs.Tabs;

import api.react.React;
import api.react.ReactDOM;
import api.react.ReactMacro.jsx;

class MyApp extends ReactComponent {
    static public function main(){
        ReactDOM.render(React.createElement(MyApp), document.getElementById('app'));
    }
    override function render(){
        return jsx('
            <Tabs>
                <TabList>
                    <Tab>Title 1</Tab>
                    <Tab>Title 2</Tab>
                </TabList>
                <TabPanel>
                    <h2>Any content 1</h2>
                </TabPanel>
                <TabPanel>
                    <h2>Any content 2</h2>
                </TabPanel>
            </Tabs>
        ');
    }
}
```

Check out the [samples]({{site.github.repository_url/samples}}){:target="_blank"} to see more externs in both ReactJs and React Native contexts.

## Ressources

Writing good externs requires some practice. The more you will use Haxe with external libs, the better you'll setup your externs.

Here are the ressources you should checkout to improve your extern skills:
- [The Haxe documentation on writing externs for javascript](https://haxe.org/manual/target-javascript-external-libraries.html){:target="_blank"}
- [The existing Haxe externs for React libs](https://github.com/haxe-react){:target="_blank"}
- Some very good externs by [kLabz](https://github.com/kLabz){:target="_blank"} or [elsassph](https://github.com/elsassph){:target="_blank"}: [haxe-react-router v3](https://github.com/elsassph/haxe-react-router){:target="_blank"}, [haxe-react-router v4](https://github.com/kLabz/haxe-react-router){:target="_blank"}, [haxe-material-ui](https://github.com/kLabz/haxe-material-ui){:target="_blank"}, [haxe-redux-connect](https://github.com/kLabz/haxe-redux-connect){:target="_blank"}...
