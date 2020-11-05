#
# Be sure to run `pod lib lint TikTokBusinessSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TikTokBusinessSDK'
  s.version          = '0.1.0'
  s.summary          = 'TikTok Business SDK for iOS'

  s.description      = <<-DESC
The TikTok Business SDK is the easiest way to log events (e.g. app install, purchase) in your mobile application and send these events to TikTok for targeting, measurement, conversion optimization, etc.
                       DESC

  s.homepage         = 'https://github.com/bytedance'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Aditya Khandelwal' => 'aditya.khandelwal@bytedance.com',
                         'Christopher Yang' => 'christopher.yang@bytedance.com'
                       }
  s.source           = { :git => 'https://github.com/bytedance/TikTokBusinessSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'TikTokBusinessSDK/**/*'
  s.exclude_files = "TikTokBusinessSDK/*.plist"
  s.swift_version = '5.0'

end
