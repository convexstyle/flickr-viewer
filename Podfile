platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

def main_pods
  # Network
  pod 'Alamofire', '~> 3.2.0'
  pod 'SwiftyJSON', '~> 2.3.2'

  # Utility
  pod 'PromiseKit', '~> 3.0.2'
  pod 'UIColor_Hex_Swift', '~> 1.9'
  pod 'SDWebImage', '~> 3.7.5'

  # UI
  pod 'SVProgressHUD'
  pod 'TSMessages', '~> 0.9.12'

  # Assets
  pod 'FontAwesome.swift', '~> 0.7.0'
end

def testing_pods
  pod 'Mockingjay', '~> 1.1.1'
  pod 'Nimble', '~> 3.1.0'
  pod 'Quick', :head
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
