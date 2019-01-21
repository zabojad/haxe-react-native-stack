package myapp.state;

import myapp.action.ReduxAction;
import myapp.action.StatusAction;

typedef StatusState = {
    network : Bool
}

class StatusRdcr {

	static public function getDefaultState() : StatusState {
		return {
			network: false
		};
	}

	static public function execute(state : StatusState, action : ReduxAction) : StatusState {
		if (state == null) {
			state = getDefaultState();
		}
		if (action.type.indexOf("@@redux") != -1) {
			return state;
		}
		switch (action.type) {
			case Status:
				var ca : StatusAction = action.value;
				switch (ca) {
					case ToggleNetwork(v):
						return js.Object.assign({},state,{network:v});
				}
			default:
		}
		return state;
	}
}
