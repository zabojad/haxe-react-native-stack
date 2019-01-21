package myapp.action;

enum IntlAction {
    ReceiveLocale(l:myapp.dto.Locale);
}

abstract IntlReduxAction(ReduxAction) from ReduxAction to ReduxAction {
	public function new(v : IntlAction) {
		this = { type: Intl,  value: v };
	}
}
