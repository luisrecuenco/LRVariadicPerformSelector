LRVariadicPerformSelector
======================

[![Pod Version](http://img.shields.io/cocoapods/v/LRVariadicPerformSelector.svg?style=flat)](http://cocoadocs.org/docsets/LRVariadicPerformSelector/)
[![Pod Platform](http://img.shields.io/cocoapods/p/LRVariadicPerformSelector.svg?style=flat)](http://cocoadocs.org/docsets/LRVariadicPerformSelector/)
[![Pod License](http://img.shields.io/cocoapods/l/LRVariadicPerformSelector.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

Because sometimes, we need to perform selectors with more than two arguments...

Also, this simple category allows the option to inject the queue (`dispatch_queue_t` or `NSOperationQueue`) that we want the selector to be exectued on.

### Installation

1. **Using CocoaPods**

   Add LRVariadicPerformSelector to your Podfile:

   ```
   pod 'LRVariadicPerformSelector'
   ```

   Run the following command:

   ```
   pod install
   ```

2. **Manually**

   Clone the project or add it as a submodule. Drag `NSObject+LRVariadicPerformSelector.h/m` folder to your project.

### Usage

```
[self lr_performSelector:@selector(because:sometimes:we:need:more:than:two:arguments:) 
          operationQueue:operationQueue
             withObjects:@"because", @"sometimes", @"we", @"need", @"more", @"than", @2, @"arguments"];
```

### Requirements

LRVariadicPerformSelector requires either iOS 6.0 or Mac OS X 10.8 and ARC.

You can still use LRVariadicPerformSelector in your non-arc project. Just set -fobjc-arc compiler flag in every source file.

### Contact

LRVariadicPerformSelector was created by Luis Recuenco: [@luisrecuenco](https://twitter.com/luisrecuenco).

### Contributing

If you want to contribute to the project just follow this steps:

1. Fork the repository.
2. Clone your fork to your local machine.
3. Create your feature branch.
4. Commit your changes, push to your fork and submit a pull request.

## License

LRVariadicPerformSelector is available under the MIT license. See the [LICENSE file](https://github.com/luisrecuenco/LRVariadicPerformSelector/blob/master/LICENSE) for more info.
