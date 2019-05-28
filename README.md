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
  pod 'flussonic-watcher-sdk-ios', :tag => '0.3.4', :git => 'https://github.com/flussonic/flussonic-watcher-sdk-ios.git'

  ```
Install dependencies
  ```
  pod cache clean --all
  pod install
  ```
