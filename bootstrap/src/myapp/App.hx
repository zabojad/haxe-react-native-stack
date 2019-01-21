package myapp;

import react.ReactComponent;

import js.redux.Redux;
import js.redux.ReduxThunk;

import js.Browser.console;

@:expose('HxApp')
@:ignoreEmptyRender
class App extends react.ReactComponent {

    public static function main() {
		new App();
	}

	public function new() {
		super();
		initApp();
    }

    private function initApp() {
        var store = initStore();
        myapp.view.MyApp.init(store);
        store.dispatch(
            myapp.action.thunk.AppThunk.init()
        );
    }

    private function initStore() : js.redux.ReduxStore {
        var rootReducer = 
            Redux.combineReducers(
                {
                    config: myapp.state.ConfigState.ConfigRdcr.execute,
                    status: myapp.state.StatusState.StatusRdcr.execute,
                    intl: myapp.state.IntlState.IntlRdcr.execute,
                }
            );
        var store = 
            Redux.createStore(
                rootReducer,
                Redux.compose(
                    Redux.applyMiddleware(
                        ReduxThunk
                    )
                )
            );
        return store;
    }
}
