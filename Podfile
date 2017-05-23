# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'mitty' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mitty
  pod 'Alamofire', '4.0.0'
  pod 'AlamofireImage', '3.1'
  pod 'PureLayout', '3.0.2'
  pod 'SwiftyJSON', '3.1.1'
  pod 'Starscream', '2.0.3'
  
  target 'mittyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'mittyUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
