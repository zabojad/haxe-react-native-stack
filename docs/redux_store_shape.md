---
---
# Designing your store state shape

The design of your state can have a great impact on several aspects of your project:
- runtime perfomance: a "too big" state leaf (in term of data size) can lead to runtime performance issues. This is especially true if your state is persisted in some local storage. You should always avoid having too much things in a state leaf.
- testability: your state and its mutation should be easily testable. A good state design is to have one dedicated state leaf (at least) per testable feature.
- maintenability / customization: Again, if your state leafs are organized per feature, it will be easier to add / remove / conditionnaly compile features in your app.

Let's take the example of an app where we want to add some optional pictures gallery.

This feature will add:
- a `myapp.screen.Gallery` react component,
- a `myapp.action.GalleryAction` action enum,
- a `myapp.action.thunk.GalleryThunk` thunk,
- a `myapp.state.GalleryState` with both the state and its readucer.

This feature is not central to our app and we want it to be "like a brick" we can add or remove at compilation.

Let's start with the state:
```haxe
package myapp.state;

// ...

typedef GalleryState = {
    pictures:Array<String>
}

// and its corresponding reducer
class GalleryRdcr implements IReducer<GalleryAction, GalleryState> {
    public function new() {}

    public var initState:GalleryState = {
        pictures: [],
    }

    public function reduce(state:GalleryState, action:GalleryAction):GalleryState {
        var partial:Partial<GalleryState> = switch(action) {
            case ReceivePictures(ps):
                {pictures:state.pictures.concat(ps)};

            case ClearGallery:
                initState;
            
            // ...
        }
        return Object.assign({}, state, partial);
    }
}
```

Add it to your store creation logic:
```haxe
// src/myapp/App.hx
// ...

#if withGallery
import myapp.state.GalleryState;
#end

    // ...

    private function initStore() : Store {

        // here we give the shape our store state
        var rootReducer = Redux.combineReducers({
            config: mapReducer(ConfigAction, new ConfigRdcr()),
            status: mapReducer(StatusAction, new StatusRdcr()),
            intl: mapReducer(IntlAction, new IntlRdcr()),
            session: mapReducer(SessionAction, new SessionRdcr()),
#if withGallery
            gallery: mapReducer(GalleryAction, new GalleryRdcr()),
#end
        });

        // ...
        
        return createStore(rootReducer, null, middleware);
    }

    // ...
```

Notice the [conditional compilation](https://haxe.org/manual/lf-condition-compilation.html){:target="_blank"} instructions. If our .hxml file contains the `-D withGallery` option, the Gallery feature will be included in our app. Otherwise, it won't.

Now, define the `GalleryAction` enum:

```haxe
// src/myapp/action/GalleryAction.hx
package myapp.action;

enum GalleryAction {
    ReceivePictures(pics:Array<String>);
    ClearGallery;
}
```

The "controller" part of the feature as a `GalleryThunk`:
```haxe
// src/myapp/action/thunk/GalleryThunk.hx
package myapp.action.thunk;

import redux.Redux.Dispatch;
import redux.thunk.Thunk.Action;
// ...
import myapp.state.State;
//...

class GalleryThunk {

    static public function fetchUserPictures(user:myapp.dto.User) {
        return Action(function(dispatch:Dispatch, getState:Void->State) {
            myapp.srv.MySrvApi.fetchUserPics(
                user,
                function(pics:Array<String>) {
                    dispatch(ReceivePictures(pics));
                }
            );
        });
    }

    //...
}
```

And finally, our `Gallery` component:

```haxe
// myapp.view.screen;

import react.Partial;
// ...

import redux.react.ReactRedux;
// ...
import myapp.action.thunk.GalleryThunk; 
import myapp.state.GalleryState; 
// ...

typedef GalleryPropsPublicProps = {
    user:myapp.dto.User
}
typedef GalleryRdxProps = {
    gallery:myapp.state.GalleryState,
    fetchPics:Void->Void
}
typedef GalleryProps = {
    > GalleryPropsPublicProps,
    > GalleryRdxProps,
}

class Gallery extends ReactComponentOfProps<GalleryProps> {

    static public var Connected = ReactRedux.connect(mapStateToProps,mapDispatchToProps)(Gallery);

    static function mapStateToProps(state:State,ownProps:GalleryPropsPublicProps):Partial<GalleryRdxProps> {
        return {
            gallery: st.gallery
        }
    }
    static function mapDispatchToProps(dispatch:Dispatch,ownProps:GalleryPropsPublicProps):Partial<GalleryRdxProps> {
        return {
            fetchPics: function(){
                dispatch(GalleryThunk.fetchUserPictures(ownProps.user));
            }
        }
    }

    static function _keyExtractor(v:{item:String,index:Int}):String{
        return v.item;
    }

    override function componentWillMount(){
        props.fetchPics();
    }

    function renderPicture(v:{item:String,index:Int}){
        return jsx('
            <View>
                <Image
                    style={{width: 50, height: 50}}
                    source={{uri: v.item}}
                />
            </View>
        ');
    }
    
    override function render(){
        return jsx('
            <View>
                <Text>User gallery:</Text>
                <FlatList
                    data={[props.gallery.pictures]}
                    renderItem={renderPicture}
                    keyExtractor={_keyExtractor}
                />
            </View>
        ');
    }
}
```

We're done. We've add a feature that is testable independantly from the rest of the app and can be added/removed with a simple compilation file:

```hxml
// app.dev.android.hxml

-D android 
# remove it if you don't want the gallery feature
-D withGallery
-js bin/App.android.js
app.dev.common.hxml
```