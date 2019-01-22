package myapp.action;

enum StatusAction {
    ToggleNetwork(v:Bool);
}

abstract StatusReduxAction(ReduxAction) from ReduxAction to ReduxAction {
    public function new(v : StatusAction) {
        this = { type: Status,  value: v };
    }
}
