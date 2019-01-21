package myapp.action.thunk;

import myapp.state.State;

import myapp.action.Thunk;
import myapp.action.ConfigAction;

import js.Browser.console;

class ConfigThunk {

	static public function init(cb : Void -> Void) : Thunk {
		return function initThunk(dispatch, getState) {
            var config : myapp.dto.Parameters = CompileTime.parseJsonFile("app/config/parameters.json");
			var a : ReduxAction = new ConfigReduxAction(ReceiveLaunchParams(config));
			dispatch(a);
            cb();
		}
	}
}
