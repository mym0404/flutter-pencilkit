#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'pencil_kit'
  s.version          = '0.0.1'
  s.summary          = 'A iOS PencilKit Plugin for Flutter.'
  s.description      = <<-DESC
A Flutter plugin that provides a iOS PencilKit widget on iOS
                       DESC
  s.homepage         = 'https://github.com/mj-studio-library/flutter-pencilkit'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'MJ Studio' => 'mym0404@gmail.com' }
  s.source           = { :http => 'https://github.com/mj-studio-library/flutter-pencilkit' }
  s.source_files = 'Classes/**/*.{h,m,swift}'
  s.public_header_files = 'Classes/**.*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
