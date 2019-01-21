package myapp.view.screen;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.Partial;

import react.native.component.*;

import react.native.navigation.*;

import js.redux.ReactRedux;
import react.intl.ReactIntl;
import react.intl.IntlShape;
import react.intl.comp.FormattedMessage;
import react.native.navigation.NavProps;

import js.Browser.console;

typedef HomeProps = {
	> NavProps,
	? intl : IntlShape,
}

@:build(lib.lodash.Lodash.build())
class Home extends ReactComponentOfProps<HomeProps> {

    static function mapStateToProps(st : myapp.state.State, ownProps : HomeProps) : Partial<HomeProps> {
        return {
		}
    }

    static function mapDispatchToProps(dispatch : myapp.action.Thunk.Dispatch, ownProps : HomeProps) : Partial<HomeProps> {
        return {
		}
    }

    static var Intl = ReactIntl.injectIntl(Home);
    static var Reduxed = ReactRedux.connect(mapStateToProps,mapDispatchToProps)(Intl);

	@:throttle(1000, {leading:true,trailing:false})
	function continueCb() : Void {
		Navigation.push(
            props.componentId,
			{
                component: {
                    name: 'myapp.Screen1',
                    options: {
                        topBar: {
                            title: { text: props.intl.formatMessage({ id: "scansession_title" }) }
                        }
                    }
                }
            }
		);
	}

	function viewProps() : HomeViewProps {
		return {
            continueCb: continueCb
		}
	}

	override function render() {
		return jsx('
        	<HomeView {...viewProps()} />
        ');
	}
}

typedef HomeViewProps = {
    continueCb : Void -> Void,
}

@:jsxStatic('render')
class HomeView {
    static var styles = HomeStyles.value;
    static public function render(props:HomeViewProps){
        return jsx('
            <View style=${styles.root}>
                <FormattedMessage id="welcome" />
                <TouchableOpacity onPress={props.continueCb}>
                    <FormattedMessage id="home_continue_btn" />
                </TouchableOpacity>
            </View>
        ');
    }
}