package myapp.action.thunk;

import myapp.state.State;

import myapp.action.Thunk;
import myapp.action.AppAction;

import js.Browser.console;

class AppThunk {

    static public function init() : Thunk {
        return function initThunk(dispatch, getState) {
            // here, we pilot the initialization of the app
            dispatch(
                ConfigThunk.init(
                    dispatch.bind(IntlThunk.init(
                            dispatch.bind(StatusThunk.init(
                                dispatch.bind(doSomethingAtStartup())
                            ))
                        )
                    )
                )
            );
        }
    }

    static public function doSomethingAtStartup() : Thunk {
        return function doSomethingAtStartupThunk(dispatch, getState) {
            // ...
            console.log('We are ready!');
        }
    }
}
