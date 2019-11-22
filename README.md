## Prerequisites

Git LFS
  ```
  brew install git-lfs
  git lfs install
  ```

## Installation with Cocoapods

Add to your Podfile
  ```
  use_frameworks!
  pod 'DynamicMobileVLCKit', :tag => '3.3.0', :git => 'https://github.com/flussonic/DynamicMobileVLCKit.git'
  pod 'flussonic-watcher-sdk-ios', :tag => '1.5.3', :git => 'https://github.com/flussonic/flussonic-watcher-sdk-ios.git'

  ```
Install dependencies
  ```
  pod cache clean --all
  pod install
  ```
  
## TroubleShooting

flussonic-watcher-sdk-ios frameworks were built with Xcode 10.3 version and not compatible with others xcode version because of apple restrictions about swiftmodules. We are strongly recommend to use only this version of Xcode. When you will try to use Xcode with different version - you may get errors like - 
```
Module compiled with Swift 4.2.1 cannot be imported by the Swift 5.0.1 compiler: flussonic-watcher-sdk-ios/example/Pods/flussonic-watcher-sdk-ios/FlussonicSDK.framework/Modules/FlussonicSDK.swiftmodule/x86_64.swiftmodule
``` 