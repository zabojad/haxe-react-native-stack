package myapp.state;

import myapp.action.ReduxAction;
import myapp.action.ConfigAction;

typedef ConfigState = {
    ? launch : myapp.dto.Parameters,
}

class ConfigRdcr {

	static public function getDefaultState() : ConfigState {
		return {};
	}

	static public function execute(state : ConfigState, action : ReduxAction) : ConfigState {
		if (state == null) {
			state = getDefaultState();
		}
		if (action.type.indexOf("@@redux") != -1) {
			return state;
		}
		switch (action.type) {
			case Config:
				var ca : ConfigAction = action.value;
				switch (ca) {
					case ReceiveLaunchParams(p):
						return js.Object.assign({},state,{launch:p});
				}
			default:
		}
		return state;
	}
}