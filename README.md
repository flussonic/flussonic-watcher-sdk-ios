## Installation with Cocoapods

+ Add these lines to your Podfile:
  ```ruby
  use_frameworks!
  # required dependency for flussonic-watcher-sdk-ios
  pod 'DynamicMobileVLCKit', :http => 'https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/DynamicMobileVLCKit/release/3.3.13/DynamicMobileVLCKit.zip'
  
  pod 'flussonic-watcher-sdk-ios', :http => 'https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/watcher-sdk/release/2.5.1/FlussonicSDK.zip'
  ```
  
+ At the very bottom of Podfile add this because of RxSwift bug - https://github.com/ReactiveX/RxSwift/issues/1972
  ```ruby
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        if target.name == "RxSwift"
          target.build_configurations.each do |config|
            if config.name == "Debug"
              config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = []
            end
          end
        end
      end
    end
  ```

Install dependencies
  ```
  pod cache clean --all
  pod install
  ```

## Troubleshooting
The flussonic-watcher-sdk-ios frameworks were built with Xcode version 12.4 and are not compatible with other Xcode versions because of Apple restrictions concerning .swiftmodule files. We strongly recommend that you use only Xcode 12.4. When using Xcode of a different version, you may get errors like:

```
Module compiled with Swift 4.2.1 cannot be imported by the Swift 5.0.1 compiler: flussonic-watcher-sdk-ios/example/Pods/flussonic-watcher-sdk-ios/FlussonicSDK.framework/Modules/FlussonicSDK.swiftmodule/x86_64.swiftmodule
``` 

With Xcode 12 apple introduce new error for frameworks built combined of simulator and iPhone architectures. 
We currently recommend to set `Workspace Settings -> Build System -> Legacy Build System`  for your workspace.
When using Xcode 12 with `New Build System` setting, you may get errors like:
```
Building for iOS Simulator, but the linked and embedded framework 'FlussonicSDK.framework' was built for iOS + iOS Simulator.
```

## Usage:

Before using flussonic-watcher-sdk-ios, you should add the [FlussonicVlcAdapter.swift](https://github.com/flussonic/flussonic-watcher-sdk-ios/tree/master/FlussonicVlcAdapter.swift) file to your project for connecting flussonic-watcher-sdk-ios with DynamicMobileVLCKit.

A sample project with CocoaPods and Flussonic Watcher SDK for iOS:
 - See the [Demo application](https://github.com/flussonic/flussonic-watcher-sdk-ios/tree/master/example)

## Documentation
  - See the [Documentation](https://flussonic.com/doc/watcher/sdk-ios/integration-of-flussonic-watcher-sdk-into-apps-for-ios)
