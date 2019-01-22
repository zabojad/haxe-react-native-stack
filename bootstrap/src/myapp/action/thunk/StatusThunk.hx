package myapp.action.thunk;

import myapp.state.State;

import myapp.action.Thunk;
import myapp.action.StatusAction;

import react.native.api.NetInfo;

import js.Browser.console;

class StatusThunk {

    static public function init(cb : Void -> Void) : Thunk {
        return function initThunk(dispatch, getState) {
            dispatch(listenNetworkState(cb));
        }
    }

    static public function listenNetworkState(cb : Void -> Void) : Thunk {
        return function listenNetworkStateThunk(dispatch,getState) {

            var handleCI = function(ci) {
                var v : Bool = true;
                switch (ci.type) {
                    case None, Unknown: v = false;
                    case Wifi,
                         Cellular
#if android
                         ,Bluetooth,
                         Ethernet,
                         Wimax
#end
                         :
                    // ignore
                }

                var a : ReduxAction = new StatusReduxAction(ToggleNetwork(v));
                dispatch(a);
            }
            NetInfo.addEventListener(
                ConnectionChange,
                handleCI
            );
            NetInfo.getConnectionInfo().then(handleCI);

            if (cb != null) {
                haxe.Timer.delay(cb,0);
            }
        }
    }
}
