# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DemoCode' do
  # Comment the next line if you don't want to use dynamic frameworks
#  use_frameworks!
use_modular_headers!
  # Pods for DemoCode

  target 'DemoCodeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DemoCodeUITests' do
    # Pods for testing
  end
  pod 'ObjectMapper'
   pod 'IQKeyboardManagerSwift'
   pod 'JWTDecode'
   pod 'KeychainAccess'
   pod 'IQKeyboardManagerSwift'
   post_install do |installer|
       installer.generated_projects.each do |project|
           project.targets.each do |target|
               target.build_configurations.each do |config|
                   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
                   xcconfig_path = config.base_configuration_reference.real_path
                   xcconfig = File.read(xcconfig_path)
                   xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
                   File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
               end
           end
       end
   end
end
