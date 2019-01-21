package js.redux;

extern class ReduxStore {
    public function getState<T>() : T;
    public function dispatch(v:Dynamic):Void;
}
