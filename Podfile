# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SoundTrack wireframe' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SoundTrack wireframe

pod 'Alamofire'
pod 'Kingfisher'
pod 'IQKeyboardManagerSwift'
pod 'NVActivityIndicatorView'
pod 'SideMenu'
pod 'lottie-ios'
pod 'GoogleSignIn'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'SwiftyJSON', '~> 4.0'
pod 'SVProgressHUD'
pod 'SwiftyStoreKit'
#pod 'SuperwallKit'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end
end

  target 'SoundTrack wireframeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SoundTrack wireframeUITests' do
    # Pods for testing
  end

end
