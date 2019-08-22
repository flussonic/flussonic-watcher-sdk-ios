Pod::Spec.new do |s|
    s.name         = "flussonic-watcher-sdk-ios"
    s.version      = "1.5.3"
    s.summary      = "Flussonic Watcher iOS SDK"
    s.description  = <<-DESC
    Flussonic Watcher iOS SDK
    DESC
    s.homepage     = "https://flussonic.com/doc"
    s.license      = { :type => 'Copyright', :file => "LICENSE" }
    s.author       = { "Flussonic Team" => "info@flussonic.com" }
    s.source       = { :git => "https://github.com/flussonic/flussonic-watcher-sdk-ios.git", :tag => "#{s.version}" }
    s.platform     = :ios

    s.preserve_paths = 'LICENSE', 'README.md'
    s.public_header_files = "*.framework/Headers/*.h"
    s.source_files = "*.framework/Headers/*.h"
    s.vendored_frameworks = "FlussonicSDK.framework", "RxSwift.framework"

    s.dependency 'Async'
    s.dependency 'DynamicMobileVLCKit', '~> 3.3'
    s.dependency 'RxCocoa'
    # s.dependency 'RxSwift'
    s.dependency 'Moya/RxSwift', '~> 13.0.0'
    s.dependency 'TrueTime', '~> 5.0'
    s.dependency 'SwiftyXMLParser'

    s.swift_version = "5.0"
    s.ios.deployment_target  = '9.3'
end
