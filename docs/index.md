---
---
# haxe-react-native-stack

**_An open source tech stack for mobile applications development with Haxe, Redux and React native._**

This documentation is related to the **version 1.0.x** of the stack.

## General information

The aim of this repository is to group and version the documentations, samples, training materials of a tech stack for mobile apps development.

This tech stack is subject to constant evolutions, in terms of library dependencies, versionning, documentations, samples, etc...

If you choose to use this tech stack for one of your project, it would thus be useful to **point out which exact version of the stack it is using**. This would help you in many ways, like clearly designating the corresponding documentations and training materials your team members should use.

At last, the long term goal of this project is to improve and share the best practices, tools and ressources. It means that if you have any suggestion, problem or even will to participate, do not hesitate to fill issues or PR changes (better start a discussion before spending time on a PR).

## Architecture

This tech stack uses some key technologies that characterizes it:
- [Haxe](www.haxe.org){:target="_blank"} is the main language it proposes for wrinting most of your application code
- [React native](https://facebook.github.io/react-native/){:target="_blank"} brings the component and rendering engine
- [Redux](https://redux.js.org/){:target="_blank"} is the state management system proposed by the stack

## Digging into the stack

### Haxe

The Haxe part of your application usually implement your app business logic. It is a key part of your app and nothing better than Haxe could give it the love it deserves.

Ensure you've understood the main topics related to this part of your app:

- [First time using Haxe? Here is what you need to know before going further](first_time_haxe).
- [Haxe and React](haxe_react)
- [How do I use an external lib with Haxe?](haxe_js_externs)
- [Recommended way to handle forms](haxe_forms)
 
### Redux

Redux, as the state management system of your app, is central to the organization and performances of your business logic. If you haven't implemented it extensively yet, we strongly recommend you to go through the following chapters:

- [Haxe and Redux](haxe_redux)
- [Designing the store shape](redux_store_shape)
- [Redux connected components and view components](redux_react)

### React native

React brings a powerful component system. You need to master it prior to use this stack for implementing your first project.

React native apply React to mobile apps. It also has key characteristics in its architecture that are must know things before jumping into some project implementation.

- [Haxe and React native](haxe_react_native)
- [Navigation System](rnnavigation)

### I'm ready to use it

So at this point, you think you are confident enough with the concepts used in the stack. You have checked out the [samples](tree/master/samples), run them and even edited them.

Now it's time to start your first project with your preferred development stack:

- [Setup the stack from the bootstrap](setup_from_bootstrap)
- [Command line interface (build, test, dist...)](command_line_interface)

## Contributing

Contributions are welcome and expected. [Please check how you could add your ideas to the stack](contributions).