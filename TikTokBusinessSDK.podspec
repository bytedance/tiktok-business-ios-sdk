#
# Be sure to run `pod lib lint TikTokBusinessSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TikTokBusinessSDK'
  s.version          = '0.1.19-beta.1'
  s.summary          = 'TikTok Business SDK for iOS'

  s.description      = <<-DESC
The TikTok Business SDK is the easiest way to log events (e.g. app install, purchase) in your mobile application and send these events to TikTok for targeting, measurement, conversion optimization, etc.
                       DESC

  s.homepage         = 'https://ads.tiktok.com/marketing_api/docs?rid=rscv11ob9m9&id=1683138352999426'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'ByteDance'
  s.source           = { :git => 'https://github.com/bytedance/tiktok-business-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'TikTokBusinessSDK/**/*'
  s.exclude_files = [
      "TikTokBusinessSDK/*.plist",
      "TikTokBusinessSDK/Public/TikTokBusinessSDK/*.h"
  ]
  s.swift_version = '5.0'

end
