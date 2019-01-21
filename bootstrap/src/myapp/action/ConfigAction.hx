package myapp.action;

enum ConfigAction {
    ReceiveLaunchParams(v : myapp.dto.Parameters);
}

abstract ConfigReduxAction(ReduxAction) from ReduxAction to ReduxAction {
	public function new(v : ConfigAction) {
		this = { type: Config,  value: v };
	}
}
