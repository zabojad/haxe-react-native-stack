---
---
# Redux in the stack

*This part of the documentation assumes that you are already familiar with Redux. If not, please take some time to learn about it on the [official Redux documentation](https://redux.js.org/introduction/getting-started){:target="_blank"}.*

## Haxe and Redux

While you can define your own Redux externs, we rather recommend to use the [haxe-redux](https://github.com/elsassph/haxe-redux) haxe library.

You will get out of the box:
- Action typing (as Haxe enums), 
- The usual Redux API type definitions,
- Support for the Redux thunks,
- Support for the React Redux connect() HOC factory,
and more...

### Store initialization

The store initialization must happen once in the `myapp.App` class.

Initializing the store also means giving its state its shape. The design of the state shape is very important as it has consequences on both performance and maintenability/evolvability. [This topic is detailed there](redux_store_shape).

```haxe
package myapp;

import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import redux.thunk.Thunk;
import redux.thunk.ThunkMiddleware;
// ...
import myapp.action.*;
import myapp.action.thunk.AppThunk;
import myapp.state.ConfigState;
import myapp.state.StatusState;
import myapp.state.IntlState;
import myapp.state.SessionState;
//...

class App extends react.ReactComponent {

    // ...

    var store : Store;

    private function initApp() {
        // create the store
        store = initStore();
        // pass it to our root view
        myapp.view.MyApp.init(store);
        // start non-UI init tasks
        store.dispatch(AppThunk.init());
    }

    private function initStore() : Store {

        // here we give the shape our store state
        var rootReducer = Redux.combineReducers({
            config: mapReducer(ConfigAction, new ConfigRdcr()),
            status: mapReducer(StatusAction, new StatusRdcr()),
            intl: mapReducer(IntlAction, new IntlRdcr()),
            session: mapReducer(SessionAction, new SessionRdcr()),
        });

        // By default in our stack, we only need the redux-thunk middleware
        var middleware = Redux.applyMiddleware(
            mapMiddleware(Thunk, new ThunkMiddleware())
        );
        
        return createStore(rootReducer, null, middleware);
    }
}
```

### Actions

Actions should be defined in the `myapp.action` package with one file for each action enum.

```haxe
// src/myapp/action/SessionAction.hx
package myapp.action;

enum SessionAction {
    UserLoggedIn(usr:myapp.dto.User);
    UserLoggedOut;
    // ...
}
```

### State and Reducers

Modifying a state leaf usually means adapting its reducer to those modifications. State and reducers are closely linked, that's why in our stack, we put them in the same `.hx` file within the `myapp.state` package:

```haxe
// src/myapp/state/SessionState.hx
package myapp.state;

import js.Object; // lib js-object
import react.Partial;
import redux.IReducer;
import redux.StoreMethods;
import myapp.action.SessionAction;
// ...

// our state leaf shape
typedef SessionState = {
    ?user:myapp.dto.User
}

// and its corresponding reducer
class SessionRdcr implements IReducer<SessionAction, SessionState> {
    public function new() {}

    public var initState:SessionState = {
        user: null,
    }

    public function reduce(state:SessionState, action:SessionAction):SessionState {
        var partial:Partial<SessionState> = switch(action) {
            case UserLoggedIn(u):
                {user:u};

            case UserLoggedOut:
                initState;
            
            // ...
        }
        return Object.assign({}, state, partial);
    }
}
```

### Thunks

Thunks could be considered our application controllers. They lay in the `myapp.action.thunk` package:

```haxe
// src/myapp/action/thunk/SessionThunk.hx
package myapp.action.thunk;

import redux.Redux.Dispatch;
import redux.thunk.Thunk.Action;
// ...
import myapp.state.State;
//...

class SessionThunk {

    static public function login(login:String, password:String) {
        return Action(function(dispatch:Dispatch, getState:Void->State) {
            myapp.srv.MySrvApi.authUser(
                MyAppAuth(login, password),
                function(u:myapp.dto.User) {
                    dispatch(UserLoggedIn(u));
                    dispatch(fetchUserData());
                }
            );
        });
    }

    //...
}
```

## Haxe, Redux and React

Now that we have a redux store with state definitions and corresponding reducers, with some thunks to make this more powerful, we need to plug our view to the state.

This is done thanks to the `ReactRedux.connect()` HOC factory, that will inject into our component props what we map from the state:

```haxe
// myapp.view.screen;

import react.Partial;
// ...

import redux.react.ReactRedux;
// ...
import myapp.action.thunk.SessionThunk; 
import myapp.state.SessionState; 
// ...

typedef MyLoginScreenPropsPublicProps = {

}
typedef MyLoginScreenRdxProps = {
    session:myapp.state.SessionState,
    login:String->String->Void
}
typedef MyLoginScreenProps = {
    > MyLoginScreenPropsPublicProps,
    > MyLoginScreenRdxProps,
}

class MyLoginScreen extends ReactComponentOfProps<MyLoginScreenProps>
{
    static public var Connected = ReactRedux.connect(mapStateToProps,mapDispatchToProps)(MyLoginScreen);

    static function mapStateToProps(state:State,ownProps:MyLoginScreenPropsPublicProps):Partial<MyLoginScreenRdxProps> {
        return {
            session: st.session
        }
    }
    static function mapDispatchToProps(dispatch:Dispatch,ownProps:MyLoginScreenPropsPublicProps):Partial<MyLoginScreenRdxProps> {
        return {
            login: function(l:String,p:String){
                dispatch(SessionThunk.login(l,p));
            }
        }
    }
    // ...
}
```
