# brazier

## What Is It?

Let's dispense once and for all with the fiction that a brazier is a women's undergarment.  A brazier is heater like this:

![Image of a brazier](https://nellcro.files.wordpress.com/2013/02/brazier.jpg)

I'm glad that we cleared that up.  Now let's never pronounce "brazier" incorrectly again.

## No, What *Is* It?

brazier is a JavaScript utility library.  It is heavily inspired by Haskell, Underscore/Lodash, and the Scala collections library.  brazier is an opinionated library written in CoffeeScript, with a focus on upholding a particular balance between power, performance, and elegance, backed by clear implementation code.

## Modules

  * [array](https://github.com/NetLogo/brazier/wiki/Module-APIs#array)
  * [equals](https://github.com/NetLogo/brazier/wiki/Module-APIs#equals)
  * [function](https://github.com/NetLogo/brazier/wiki/Module-APIs#function)
  * [maybe](https://github.com/NetLogo/brazier/wiki/Module-APIs#maybe)
  * [number](https://github.com/NetLogo/brazier/wiki/Module-APIs#number)
  * [object](https://github.com/NetLogo/brazier/wiki/Module-APIs#object)
  * [type](https://github.com/NetLogo/brazier/wiki/Module-APIs#type)

Modules modules can be imported with standard ES6 `import`s (e.g. `import { isArray } from "/url/to/type.js"`).

## How to Test

Use the following terminal commands:

  * `npm install`
    * This downloads all of the necessary libraries
  * `grunt`
    * This builds the project
  * `grunt test`
    * This runs the test, but won't necessarily squawk if there's something badly wrong
  * `grunt && python3 -m http.server 9005`
    * This will build the latest version of the project and make the files accessible (via Python's bundled HTTP server) on port 9005.  You can then view the tests at `http://localhost:9005/test/test.html`.  Check the JavaScript console to ensure that there were no errors thrown.

## Terms of Use

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)

brazier is in the public domain.  To the extent possible under law, Uri Wilensky has waived all copyright and related or neighboring rights.
