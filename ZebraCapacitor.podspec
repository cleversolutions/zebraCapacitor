
  Pod::Spec.new do |s|
    s.name = 'ZebraCapacitor'
    s.version = '0.0.13'
    s.summary = 'Ionic Capacitor plugin for Zebra Printers'
    s.license = 'MIT'
    s.homepage = 'https://github.com/cleversolutions/zebraCapacitor/'
    s.author = 'Evan Moore'
    s.source = { :git => 'https://github.com/cleversolutions/zebraCapacitor.git', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '10.0'
    s.dependency 'Capacitor'
    s.subspec 'libZSDK_API' do |libzsdk_api|
        libzsdk_api.preserve_paths = 'Plugin/include/openssl/*.h'
        libzsdk_api.vendored_libraries = 'Plugin/libZSDK_API.a'
        libzsdk_api.libraries = 'ZSDK_API'
        libzsdk_api.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/include/**" }
    end
  end
