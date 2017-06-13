platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

def main_pods
  # Network
  pod 'Alamofire', '~> 4.4.0'
  pod 'SwiftyJSON', '~> 3.1.4'

  # Utility
  pod 'PromiseKit', '~> 4.2.2'
  pod 'UIColor_Hex_Swift', '~> 3.0.2'
  pod 'SDWebImage', '~> 3.7.5'

  # UI
  pod 'SVProgressHUD'
  pod 'TSMessages', '~> 0.9.12'

  # Assets
  pod 'FontAwesome.swift', '~> 1.2.0'

  # Network
  pod 'ReachabilitySwift', '~> 3'
end

def testing_pods
  pod 'Mockingjay', '~> 2.0.0'
  pod 'Nimble', '~> 7.0.1'
  pod 'Quick', '~> 1.1.0'
end


target "FlickrViewer" do
  main_pods
end

target "FlickrViewerTests" do
  testing_pods
end

target "FlickrViewerUITests" do
  testing_pods
end
