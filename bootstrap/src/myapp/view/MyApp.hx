package myapp.view;

import react.ReactComponent;
import react.ReactMacro.jsx;

import react.native.api.*;
import react.native.component.*;

import react.native.navigation.Navigation;
import react.native.navigation.NavigationOptions;
import react.native.navigation.Layout;

import js.redux.react.Provider;
import react.intl.ReactIntl;
import react.intl.IntlShape;
import react.intl.comp.IntlProvider;

import myapp.view.navigation.ComponentId;

import js.Browser.console;

class MyApp {

    static public function init(store : js.redux.ReduxStore) {

        // Add here any other language we need to support
        ReactIntl.addLocaleData(js.Lib.require('react-intl/locale-data/en'));
        ReactIntl.addLocaleData(js.Lib.require('react-intl/locale-data/fr'));
        ReactIntl.addLocaleData(js.Lib.require('intl/locale-data/jsonp/en'));
        ReactIntl.addLocaleData(js.Lib.require('intl/locale-data/jsonp/fr'));

        registerScreens(store);

        var lh : Layout =
            {
                component: {
                    name: 'myapp.Home',
                    options: {
                        topBar: { visible: false }
                    },
                    passProps: {
                        startup: true
                    }
                }
            };
        Navigation.events().registerAppLaunchedListener(
            function(){
                Navigation.setRoot(
                    {
                        root: {
                            stack: {
                                id: ComponentId.RootStack,
                                children: [ lh ],
                            }
                        }
                    }
                );
            }
        );
    }

    static function registerScreens(store) {
        Navigation.registerComponentWithRedux('myapp.Home', function(){ return myapp.view.screen.Home; }, AppProviders, { store: store });
        Navigation.registerComponentWithRedux('myapp.Screen1', function(){ return myapp.view.screen.Screen1; }, AppProviders, { store: store });
    }
}

typedef AppProvidersProps = {
    store: {
        store : js.redux.ReduxStore
    },
    children: Dynamic
}

class AppProviders extends ReactComponentOfProps<AppProvidersProps> {

    static var messages : Map<String,Dynamic> =
        [
            "fr" => CompileTime.parseJsonFile("app/lang/fr.json"),
            "en" => CompileTime.parseJsonFile("app/lang/en.json")
        ];
    
    inline function intledApp() {
        var l : myapp.dto.Locale = props.store.store.getState().intl.locale;
        return jsx('
            <IntlProvider 
                locale=${l.lang}
                messages=${messages.get(l.lang)}
                textComponent=${Text}
            >
                ${ props.children }
            </IntlProvider>
        ');
    }

    override function render() {
        return jsx('
            <Provider store=${props.store.store}>
                ${intledApp()}
            </Provider>
        ');
    }
}
