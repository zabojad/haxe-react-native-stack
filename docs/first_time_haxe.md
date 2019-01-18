---
---
# First time using Haxe? 

Here is what you need to know before going further.

## What is Haxe?

Haxe is several things at once. We'll try to summarize it here.

### A programming language

Haxe is a high level language, meaning it's a modern language targetting rather software projects like mobile applications, web applications, server applications and games. Its syntax is object oriented and could be compared to the ones of Java, Swift, ECMAScript...

It is a strictly typed language. This has a great importance and we will come back to this characteristic regularly later. In many ways, we could compare the use we make of Haxe in this stack with the use of Typescript, but with an even more powerful typing system and some other very nice features.

Here are documentation ressources you should get familiar with to understand the Haxe typing system:
- [Haxe Types](https://haxe.org/manual/types.html){:target="_blank"},
- [Haxe Typing system](https://haxe.org/manual/type-system.html){:target="_blank"},
- [Type inference with Haxe](https://haxe.org/manual/type-system-type-inference.html){:target="_blank"}.

### A cross-plaform compiler

This is not needed for now in our stack but could be useful in the future: Haxe code can be compiled to many other languages and platforms: Javascript, C++, Java, Python, PHP, C#... [More about it there](https://haxe.org/manual/introduction-what-is-haxe.html).

In our case, we will focus on using Haxe to compile to javascript, as it is the main language used by React native applications code.

### A cross-plaform standard library

Haxe also comes with a cross-platform standard library. It means that it already provides an API for many things like `Maths`, `Timer`, `String` or anything that you would commonly find in different platforms. It allows to write code that can be compiled to the different platforms supported by Haxe. It could be summarize as the common denominator of all Haxe platforms.

More about the standard library:
- [Documentation](https://haxe.org/manual/std.html){:target="_blank"},
- [API documentation](https://api.haxe.org/){:target="_blank"}.

### Haxelib

Note that Haxe exists for almost a decade and has its own ecosystem. You will find many libraries for Haxe out there. Haxe comes with Haxelib with is the equivalent of npm for Node.js for example.

As with any library and dependency, always check if a lib is maintained and used enough before adding any dependency to your project.

To know more about Haxelib, check out those ressources:
- [Haxelib](https://haxe.org/manual/haxelib.html){:target="_blank"},
- [Using Haxelib](https://lib.haxe.org/documentation/using-haxelib/){:target="_blank"},
- [Per project setup](https://lib.haxe.org/documentation/per-project-setup/){:target="_blank"},
- [Creating a haxelib package](https://lib.haxe.org/documentation/creating-a-haxelib-package/){:target="_blank"},
- [haxelib repository](https://lib.haxe.org/){:target="_blank"}.

### Flexibility

The risk of any cross platform tool is that it can sometimes make accessing the native capabilities a hassle. With Haxe, it is not the case. While you have a Standard library you can use to create cross platform code, you can also create plaform specific code and access easily each platform native capabilities.

In our case, we will focus on the native capabilities of the js target. More about the [Haxe js target there](https://haxe.org/manual/target-javascript.html).

### Extensibility

Haxe has a very powerful system that allows you to extend the language with custom features: the macros.

Haxe macros are part of your code that gives instructions to the compiler. It can allow you to perform many things like:
- optimizing your application performances by executing tasks at compilation rather than at runtime.
- extending the Haxe language with features you need to make your code clearer, more consize, etc...

The spectrum of use cases with macros is very wide. I would summarize it by "things you do at compile time" (vs things you do at runtime for example).

Some macro related ressources you should check out:
- [Haxe macros documentation](https://haxe.org/manual/macro.html){:target="_blank"},
- [Haxe macros cookbook](https://code.haxe.org/category/macros/){:target="_blank"},
- [Some nice haxelib that ease you the use of macros for very generic tasks](https://github.com/jasononeil/compiletime){:target="_blank"}.

## How do we use it in this stack?

A typical development setup today would be ES6 + React native or Typescript + React native.

In our stack, this part of the setup is Haxe + React native. It means that in our setup, Haxe brings us the following things that really matter to us:
- a very powerful typing system (superior to the Typescript one),
- an ability to target javascript,
- a fast compiler (way faster than babel),
- a macro system to give our code this extra love it deserves.

## Haxe ressources

- [Try haxe](https://try.haxe.org/){:target="_blank"},
- [Haxe community](https://community.haxe.org/){:target="_blank"},
- [Haxe GitHub](https://github.com/HaxeFoundation/haxe){:target="_blank"},
- [Haxe API](https://api.haxe.org/){:target="_blank"},
- [Haxe documentation](https://haxe.org/manual/introduction.html){:target="_blank"},
- [Haxe cookbooks](https://code.haxe.org/){:target="_blank"},
- [Haxelib - the haxe npm](https://lib.haxe.org/){:target="_blank"}.

## Practicing on the key aspects of Haxe for this stack

Checkout and play with the samples related to the Haxe language.
- 01-haxe-typing: in this first example, you will go through the notion of typing, type inference and untyping. This example covers also abstract types and how they can bring readability and safety to your code.
- 02-haxe-js-externs: in this example, we show a case of adding a extenal js (non-Haxe) dependency to your code.
- 03-haxe-macros: a simple example of use of macros.
