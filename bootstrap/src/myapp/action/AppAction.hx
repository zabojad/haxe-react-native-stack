package myapp.action;

enum AppAction {
	SomeAction;
    SomeOtherActionWithParams(foo:String,bar:Int);
}

abstract AppReduxAction(ReduxAction) from ReduxAction to ReduxAction {
	public function new(v : AppAction) {
		this = { type: App,  value: v };
	}
}
