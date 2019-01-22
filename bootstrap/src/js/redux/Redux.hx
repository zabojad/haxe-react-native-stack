package js.redux;

/**
Extern for [Redux](https://github.com/reactjs/redux)
**/
@:jsRequire('redux')
extern class Redux {
    static public function combineReducers(reducers : Dynamic) : Dynamic;
    static public function createStore(reducer : Dynamic, ? initialState : Dynamic, ? enhancer : Dynamic) : Dynamic;
    static public function applyMiddleware(mdlw : haxe.extern.Rest<Dynamic>) : Dynamic;
    static public function compose(enhancers : haxe.extern.Rest<Dynamic>) : Dynamic;
}
