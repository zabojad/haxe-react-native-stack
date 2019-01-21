package myapp.action;

import myapp.action.ReduxAction;

typedef Dispatch = haxe.extern.EitherType<ReduxAction,Thunk> -> Void;

typedef Thunk = Dispatch -> (Void -> myapp.state.State) -> Void;
