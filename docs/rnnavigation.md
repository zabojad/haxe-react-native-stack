---
---
# Navigation

Navigation is a common hassle with React Native. We've decided to propose and document the use of a chosen navigation library right from the very first version of the stack.

*This part of the documentation assumes that you are already familiar with [React Native Navigation](https://github.com/haxe-react/react-native-navigation){:target="_blank"}.. If not, please take some time to learn about it on the [official React Native Navigation documentation](https://wix.github.io/react-native-navigation/#/){:target="_blank"}.*

## Version of React native navigation supported in the stack

The current version of the stack has been designed with React native navigation >= `2.4.x`. The use of prior versions of RNN is highly discouraged.

## Haxe and RNN

Again, we need externs for Haxe to use RNN. Fortnately, they already exist and are available [there](https://github.com/haxe-react/react-native-navigation).

## Registering and mounting your screens root component

With RNN, our app do not have a single react root component but as many as we have registered screens. This is because RNN is truly native navigation, not implemented at js level.

It has some consequences regarding the use of other libs in the stacks like `react-redux` and `react-intl`. Each of our screens will be wrapped in a `react-redux`'s `Provider` and `react-intl`'s `IntlProvider`:

```haxe 
package myapp.view;

import react.ReactComponent;
import react.ReactMacro.jsx;

import react.native.api.*;
import react.native.component.*;

import react.native.navigation.Navigation;

import redux.Store;
import redux.react.Provider;
import react.intl.comp.IntlProvider;
// ...

class MyApp {

    // ...

    static function registerScreens(store : Store) {
        Navigation.registerComponentWithRedux('myapp.Home', function(){ return myapp.view.screen.Home; }, AppProviders, { store: store });
        Navigation.registerComponentWithRedux('myapp.Screen1', function(){ return myapp.view.screen.Screen1; }, AppProviders, { store: store });
        // ...
    }
}

typedef AppProvidersProps = {
    store: {
        store : Store
    },
    children: Dynamic
}

class AppProviders extends ReactComponentOfProps<AppProvidersProps> {

    static var messages : Map<String,Dynamic> =
        [
            "fr" => CompileTime.parseJsonFile("app/lang/fr.json"),
            "en" => CompileTime.parseJsonFile("app/lang/en.json")
        ];
    
    inline function intledApp() {
        var l : myapp.dto.Locale = props.store.store.getState().intl.locale;
        return jsx('
            <IntlProvider 
                locale=${l.lang}
                messages=${messages.get(l.lang)}
                textComponent=${Text}
            >
                ${ props.children }
            </IntlProvider>
        ');
    }

    override function render() {
        return jsx('
            <Provider store=${props.store.store}>
                ${intledApp()}
            </Provider>
        ');
    }
}
```

## Designing your navigation stacks

RNN v2 offers the possibility to control any navigation stack from anywhere in your app. That very handy when working with thunks as you can have long running thunks that can have some navigation initiative.

A simple recommendation here is to define in a `myapp.view.navigation.ComponentId` class the `componentId` values of the navigation stacks that can be controlled from outside:

```haxe
package myapp.view.navigation;

@:enum
abstract ComponentId(String) to String {
    var RootStack = "root-stack";
    // ...
}
```
That will allow for example:
```haxe
package myapp.action.thunk;

import redux.Redux.Dispatch;
import redux.thunk.Thunk.Action;

import myapp.state.State;
import myapp.action.SessionAction;

import react.native.navigation.Navigation;
import myapp.view.navigation.ComponentId;

// ...

class SessionThunk {

    static public function logout() {
        return Action(function(dispatch:Dispatch, getState:Void->State) {
            dispatch(UserLoggedOut);
            Navigation.setStackRoot(
                ComponentId.RootStack,
                {
                    component: {
                        name: 'myapp.Login',
                        options: {
                            topBar: { visible: false, animate: false }
                        }
                    }
                }
            );
        }
    }

    // ...
}
```

In most mobile apps, you will often have one root stack and n alternate navigation stacks. Some of them might need a defined ID in your `ComponentId` class.