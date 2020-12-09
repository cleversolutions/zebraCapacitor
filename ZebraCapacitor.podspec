require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'ZebraCapacitor'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target  = '11.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
  s.subspec 'libZSDK_API' do |libzsdk_api|
    libzsdk_api.preserve_paths = 'include/openssl/*.h'
    libzsdk_api.vendored_libraries = 'libZSDK_API.a'
    libzsdk_api.libraries = 'ZSDK_API'
    libzsdk_api.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/include/**", 
      'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/../../../node_modules/zebra-capacitor/ios/Plugin" }
end
end
