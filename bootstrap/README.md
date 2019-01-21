# Haxe React Native project bootstrap

This project is based on the [haxe-react-native-stack version 1.0.0](/tree/1.0.0).

# Setup

Initial setup starts with installing the haxe dependencies:

```console
foo@bar:~$ npm run install-haxe
```

Then create the the rnn project in the bin folder

```console
foo@bar:~$ react-native init AwesomeProject && mv AwesomeProject bin
```

At last, replace the `bin/index.js` file by this:

```js
/** @format */

import {AppRegistry} from 'react-native';
import {HxApp} from './App';
import {name as appName} from './app.json';

AppRegistry.registerComponent(appName, () => HxApp);
```