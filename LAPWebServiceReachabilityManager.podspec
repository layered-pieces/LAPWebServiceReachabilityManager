#
#  Be sure to run `pod spec lint pieces.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name               = "LAPWebServiceReachabilityManager"
  s.version            = "0.1.0"
  s.summary            = "A reachability observer for a web service."
  s.homepage           = "https://github.com/layered-pieces/LAPWebServiceReachabilityManager"
  s.license            = "MIT"
  s.author             = { "Oliver Letterer" => "oliver.letterer@gmail.com" }
  s.social_media_url   = "https://twitter.com/OliverLetterer"
  s.platform           = :ios, "9.0"
  s.source             = { :git => "https://github.com/layered-pieces/LAPWebServiceReachabilityManager.git", :tag => "#{s.version}" }
  s.requires_arc       = true

  s.source_files = 'LAPWebServiceReachabilityManager'
end
