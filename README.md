## Installation with Cocoapods

Add these lines to your Podfile:
  ```
  use_frameworks!
  # required dependency for flussonic-watcher-sdk-ios
  pod 'DynamicMobileVLCKit', :http => 'https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/DynamicMobileVLCKit/release/3.3.0/DynamicMobileVLCKit.zip'
  
  pod 'flussonic-watcher-sdk-ios', :http => 'https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/watcher-sdk/release/1.5.6/FlussonicSDK.zip'

  ```
Install dependencies
  ```
  pod cache clean --all
  pod install
  ```

## Troubleshooting
The flussonic-watcher-sdk-ios frameworks were built with Xcode version 10.3 and are not compatible with other Xcode versions because of Apple restrictions concerning .swiftmodule files. We strongly recommend that you use only Xcode 10.3. When using Xcode of a different version, you may get errors like:

```
Module compiled with Swift 4.2.1 cannot be imported by the Swift 5.0.1 compiler: flussonic-watcher-sdk-ios/example/Pods/flussonic-watcher-sdk-ios/FlussonicSDK.framework/Modules/FlussonicSDK.swiftmodule/x86_64.swiftmodule
``` 

## Usage:

Before using flussonic-watcher-sdk-ios, you should add the [FlussonicVlcAdapter.swift](https://github.com/flussonic/flussonic-watcher-sdk-ios/tree/master/FlussonicVlcAdapter.swift) file to your project for connecting flussonic-watcher-sdk-ios with DynamicMobileVLCKit.

A sample project with CocoaPods and Flussonic Watcher SDK for iOS:
 - See the [Demo application](https://github.com/flussonic/flussonic-watcher-sdk-ios/tree/master/example)

## Documentation
  - See the [Documentation](https://flussonic.com/doc/watcher/sdk-ios/integration-of-flussonic-watcher-sdk-into-apps-for-ios)