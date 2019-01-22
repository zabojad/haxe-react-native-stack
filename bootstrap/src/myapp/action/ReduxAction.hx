package myapp.action;

@:enum
@:forward(indexOf)
abstract ReduxActionType(String) from String to String {
    var App = "App";
    var Config = "Config";
    var Status = "Status";
    var Intl = "Intl";
    // ...
}

typedef ReduxAction = {
    type : ReduxActionType,
    value : Dynamic
}
