Pod::Spec.new do |s|
    s.name         = "flussonic-watcher-sdk-ios"
    s.version      = "2.10.3"
    s.summary      = "Flussonic Watcher iOS SDK"
    s.description  = <<-DESC
    Flussonic Watcher iOS SDK
    DESC
    s.homepage     = "https://flussonic.com/doc"
    s.license      = { :type => "Copyright", :file => "LICENSE" }
    s.author       = { "Flussonic Team" => "info@flussonic.com" }
    s.source       = {
      :http => "https://flussonic-watcher-mobile-sdk.s3.eu-central-1.amazonaws.com/ios/watcher-sdk/release/#{s.version}/FlussonicSDK.zip"
    }
    s.platform     = :ios

    s.preserve_paths = "LICENSE", "README.md"
    s.public_header_files = "*.framework/Headers/*.h"
    s.source_files = "*.framework/Headers/*.h"
    s.vendored_frameworks = "FlussonicSDK.framework"

    s.dependency "Async"
    s.dependency "DynamicMobileVLCKit", "~> 3.3"
    s.dependency "RxCocoa", "~> 6.0"
    s.dependency "RxSwift", "~> 6.0"
    s.dependency "Moya/RxSwift", "~> 15.0"
    s.dependency "TrueTime", "~> 5.0"
    s.dependency "SwiftyXMLParser"
    s.dependency 'Punycode', "~> 2.1"
    s.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
    s.swift_versions = [ "5.1", "5.2", "5.3", "5.4", "5.5" ]

    s.ios.deployment_target  = "10.1"
end
