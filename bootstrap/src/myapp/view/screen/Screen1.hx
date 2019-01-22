package myapp.view.screen;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.Partial;

import react.native.api.*;
import react.native.component.*;

import js.redux.ReactRedux;
import react.intl.ReactIntl;
import react.intl.IntlShape;
import react.intl.comp.FormattedMessage;
import react.native.navigation.NavProps;

import js.Browser.console;

typedef Screen1Props = {
    > NavProps,
    ? intl : IntlShape,
}

@:build(lib.lodash.Lodash.build())
class Screen1 extends ReactComponentOfProps<Screen1Props> {

    static function mapStateToProps(st : myapp.state.State, ownProps : Screen1Props) : Partial<Screen1Props> {
        return {
        }
    }

    static function mapDispatchToProps(dispatch : myapp.action.Thunk.Dispatch, ownProps : Screen1Props) : Partial<Screen1Props> {
        return {
        }
    }

    static var Intl = ReactIntl.injectIntl(Screen1);
    static var Reduxed = ReactRedux.connect(mapStateToProps,mapDispatchToProps)(Intl);

    function viewProps() : Screen1ViewProps {
        return {
            intl:props.intl
        }
    }

    override function render() {
        return jsx('
            <Screen1View {...viewProps()} />
        ');
    }
}

typedef Screen1ViewProps = {
    intl:IntlShape
}

@:jsxStatic('render')
class Screen1View {
    static var styles = Screen1Styles.value;
    static function instructions(props:Screen1ViewProps){
        return
            Platform.select({
                ios: props.intl.formatMessage({id:'screen1_text3'}),
                android: props.intl.formatMessage({id:'screen1_text4'}),
            });
    }
    static public function render(props:Screen1ViewProps){
        return jsx('
            <View style=${styles.container}>
                <Text style=${styles.welcome}><FormattedMessage id="screen1_text1" /></Text>
                <Text style=${styles.instructions}><FormattedMessage id="screen1_text2" /></Text>
                <Text style=${styles.instructions}>{instructions(props)}</Text>
            </View>
        ');
    }
}
