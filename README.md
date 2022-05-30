## Installation with Cocoapods

- Add these lines to your Podfile:

  ```ruby
  use_frameworks!
  # required dependency for flussonic-watcher-sdk-ios
  pod 'DynamicMobileVLCKit', :http => 'https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/DynamicMobileVLCKit/release/3.3.13/DynamicMobileVLCKit.zip'

  pod 'flussonic-watcher-sdk-ios', :http => 'https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/watcher-sdk/release/2.9.0/FlussonicSDK.zip'
  ```

- At the very bottom of Podfile add this because of RxSwift bug - https://github.com/ReactiveX/RxSwift/issues/1972
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

The flussonic-watcher-sdk-ios frameworks were built with Xcode version 13.1 and are not compatible with other Xcode versions because of Apple restrictions concerning .swiftmodule files. We strongly recommend that you use only Xcode 13.1. When using Xcode of a different version, you may get errors like:

```
Module compiled with Swift 4.2.1 cannot be imported by the Swift 5.0.1 compiler: flussonic-watcher-sdk-ios/example/Pods/flussonic-watcher-sdk-ios/FlussonicSDK.framework/Modules/FlussonicSDK.swiftmodule/x86_64.swiftmodule
```

With Xcode 12 apple introduce new error for frameworks built combined of simulator and iPhone architectures.
When using Xcode 12 with `New Build System` setting, you may get errors like:

```
Building for iOS Simulator, but the linked and embedded framework 'FlussonicSDK.framework' was built for iOS + iOS Simulator.
```

For removing simulator architectures you could add this script to build phase

```
echo "Target architectures: $ARCHS"

if [ -z "$DEBUG" ]; then
    ARCHS_TO_REMOVE="i386 x86_64"
else
    ARCHS_TO_REMOVE="i386"
fi

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"
echo $(lipo -info "$FRAMEWORK_EXECUTABLE_PATH")

FRAMEWORK_TMP_PATH="$FRAMEWORK_EXECUTABLE_PATH-tmp"

# remove simulator's archs if location is not simulator's directory
case "${TARGET_BUILD_DIR}" in
*"iphonesimulator")
echo "No need to remove archs"
;;
*)
for REMOVING_ARCH in $ARCHS_TO_REMOVE
do
if $(lipo "$FRAMEWORK_EXECUTABLE_PATH" -verify_arch $REMOVING_ARCH) ; then
lipo -output "$FRAMEWORK_TMP_PATH" -remove $REMOVING_ARCH "$FRAMEWORK_EXECUTABLE_PATH"
echo "$REMOVING_ARCH architecture removed from $FRAMEWORK_EXECUTABLE_NAME"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_TMP_PATH" "$FRAMEWORK_EXECUTABLE_PATH"
fi
done
;;
esac

echo "Completed for executable $FRAMEWORK_EXECUTABLE_PATH"
echo $(lipo -info "$FRAMEWORK_EXECUTABLE_PATH")

done

```

## Usage:

Before using flussonic-watcher-sdk-ios, you should add the [FlussonicVlcAdapter.swift](https://github.com/flussonic/flussonic-watcher-sdk-ios/tree/master/FlussonicVlcAdapter.swift) file to your project for connecting flussonic-watcher-sdk-ios with DynamicMobileVLCKit.

A sample project with CocoaPods and Flussonic Watcher SDK for iOS:

- See the [Demo application](https://github.com/flussonic/flussonic-watcher-sdk-ios/tree/master/example)

## Documentation

- See the [Documentation](https://flussonic.com/doc/watcher/sdk-ios/integration-of-flussonic-watcher-sdk-into-apps-for-ios)
