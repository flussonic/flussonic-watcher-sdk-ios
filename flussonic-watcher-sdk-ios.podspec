Pod::Spec.new do |s|
    s.name         = "flussonic-watcher-sdk-ios"
    s.version      = "0.3.3"
    s.summary      = "Flussonic Watcher iOS SDK"
    s.description  = <<-DESC
    Flussonic Watcher iOS SDK
    DESC
    s.homepage     = "https://flussonic.com/doc"
    s.license      = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2017-2019 Erlyvideo
                   Permission is granted by Erlyvideo to client according to commercial contract.
                  LICENSE
                }
    s.author       = { "Flussonic Team" => "info@flussonic.com" }
    s.source       = { :git => "https://github.com/flussonic/flussonic-watcher-sdk-ios.git", :tag => "#{s.version}" }
    s.platform     = :ios
    s.public_header_files = "*.framework/Headers/*.h"
    s.source_files = "*.framework/Headers/*.h"
    s.vendored_frameworks = "FlussonicSDK.framework"

    # needed for TrueTime.framework
    # s.preserve_path = 'CTrueTime'

    s.dependency 'RxSwift', '~> 4.2.0'
    s.dependency 'RxCocoa', '~> 4.2.0'
    s.dependency 'Moya/RxSwift', '11.0.2'
    s.dependency 'Alamofire', '~> 4.7.3'
    s.dependency 'Result', '~> 3.2.4'
    s.dependency 'TrueTime', '~> 5.0.0'
    s.dependency 'DynamicMobileVLCKit', '~> 3.3.0'

    s.swift_version = "4.0"
    s.ios.deployment_target  = '9.3'
end
