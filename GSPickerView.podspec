#
# Be sure to run `pod lib lint GSPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GSPickerView'
  s.version          = '0.1.1'
  s.summary          = 'GSPickerView is Horizontal Picker Library written in Swift'
  s.swift_version = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
GSPickerView is an easy to use and customize alternative to UIPickerView written in Swift. It was developed to provide a highly customizable experience, so you can implement your custom designed PickerView.
                       DESC

  s.homepage         = 'https://github.com/gurtej1992/GSPickerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gurtej Singh' => 'gurtej1992@gmail.com' }
  s.source           = { :git => 'https://github.com/gurtej1992/GSPickerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/**/*.swift'
  
  # s.resource_bundles = {
  #   'GSPickerView' => ['GSPickerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
