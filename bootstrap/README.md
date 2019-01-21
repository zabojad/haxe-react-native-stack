# Haxe React Native project bootstrap

This project is based on the [haxe-react-native-stack version 1.0.0](/tree/1.0.0).

## Setup

Initial setup starts with installing the haxe dependencies:

```console
foo@bar:~$ npm run install-haxe
```

Then create the the rnn project in the bin folder

```console
foo@bar:~$ react-native init AwesomeProject && mv AwesomeProject bin && rm bin/App.js
```

You should now be good to go... Start by a haxe compilation of your app code:
```console
foo@bar:~$ haxe app.dev.android.hxml
```

Now run it on an Android device/simulator
```console
foo@bar:~$ cd bin && react-native run-android
```

The app should compile and show up in debug mode on your device.
