package myapp.state;

import myapp.action.ReduxAction;
import myapp.action.IntlAction;

typedef IntlState = {
    ? locale : myapp.dto.Locale
}

class IntlRdcr {

	static public function getDefaultState() : IntlState {
		return {};
	}

	static public function execute(state : IntlState, action : ReduxAction) : IntlState {
		if (state == null) {
			state = getDefaultState();
		}
		if (action.type.indexOf("@@redux") != -1) {
			return state;
		}
		switch (action.type) {
			case Intl:
				var ca : IntlAction = action.value;
				switch (ca) {
					case ReceiveLocale(l):
						return js.Object.assign({},state,{locale:l});
				}
			default:
		}
		return state;
	}
}