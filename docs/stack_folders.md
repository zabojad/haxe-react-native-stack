---
---
# Stack folders and packages organization

Once your stack is locally setup, here are the folders you will find in it:

- `.haxelib`: contains the local haxe libraries used by the project. In case you would like to update or add one, `haxelib install <...>` executed at the project root level should work. You may update the `install.hxml` file with your changes so that other developpers can easily replicate a dev environment for the project on some other computer.

- `app`: contains the app assets (lang files, config files, images, sounds, etc...).

- `bin`: the RNN project folder

- `src`: the Haxe sources of your app. Most of your work should happen there.

- the root folder contains the `.hxml` files. Those files are the "build" files of your haxe code.

Now if we take a closer look at the content of the `src/` folder, we will see the sources of the app sorted in packages:

- we see a `js` and a `react` root packages. Those packages hold externs for libs & modules used by the project. If one of those externs becomes too important, you might consider publishing it on GitHub (or equivalent) and/or haxelib as an independent haxe library.

- the `myapp` package holds the application code. Within it, we have:
  - `myapp.action`: contains the Redux actions definition files + the thunks in `myapp.action.thunk`.
  - `myapp.dto` contains the Data Transfer Objects definition files. These are the object manipulated by the app and that are likely to be serialized/sent/received by/to the app from/to some other service/API/...
  - `myapp.state` contains the Redux state shape. Can be deep and complexe but always try to keep it simple and organized like bricks (one feature = one state leef)
  - `myapp.view` is where you'll put your app view (typically your React components)
  - App.hx is your main/boot file/class.