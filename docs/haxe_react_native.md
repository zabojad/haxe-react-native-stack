---
---
# React native in the stack

*This part of the documentation assumes that you are already familiar with React Native. If not, please take some time to learn about it on the [official React Native documentation](https://facebook.github.io/react-native/docs/getting-started.html){:target="_blank"}.*

## Version of React native supported in the stack

The current version of the stack has been designed with React native >= `0.57.x`. That doesn't mean it wouldn't work with other versions of RN but it is just here to tell what version of RN we recommend for a use with the stack.

## Haxe and React native

To use RN with Haxe, we once again need externs. Those externs are provided by [haxe-react-native](https://github.com/haxe-react/haxe-react-native).

Its API follows closely the original RN API:

```haxe
package;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.native.api.*;
import react.native.component.*;

class MyApp {
    public static function main() {
        var projectName = 'AwesomeProject';
        AppRegistry.registerComponent(projectName, function() return Home);
    }
}

class Home extends ReactComponent {
    override function render() {
        return jsx('
            <View>
                <Text>Hello world!</Text>
            </View>
        ');
    }
}
```

Note that this stack uses some libs for RN that have a strong footprint on the code base like the RN navigation. Please check the related part of the [doc](rnnavigation).

