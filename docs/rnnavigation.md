---
---
# Navigation

*This part of the documentation assumes that you are already familiar with [React Native Navigation](https://github.com/haxe-react/react-native-navigation){:target="_blank"}.. If not, please take some time to learn about it on the [official React Native Navigation documentation](https://wix.github.io/react-native-navigation/#/){:target="_blank"}.*

## Version of React native navigation supported in the stack

The current version of the stack has been designed with React native navigation >= `2.4.x`. The use of prior versions of RNN is highly discouraged.

## Haxe and RNN

Again, we need externs for Haxe to use RNN. Fortnately, they already exist and are available [there](https://github.com/haxe-react/react-native-navigation).

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