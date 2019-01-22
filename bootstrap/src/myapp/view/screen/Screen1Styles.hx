package myapp.view.screen;

import react.native.api.*;

class Screen1Styles {
    static public var value = 
        StyleSheet.create(
            {
                container: {
                    flex: 1,
                    justifyContent: 'center',
                    alignItems: 'center',
                    backgroundColor: '#F5FCFF',
                },
                welcome: {
                    fontSize: 20,
                    textAlign: 'center',
                    margin: 10,
                },
                instructions: {
                    textAlign: 'center',
                    color: '#333333',
                    marginBottom: 5,
                },
            }
        );
}
