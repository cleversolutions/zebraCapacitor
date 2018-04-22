
  Pod::Spec.new do |s|
    s.name = 'ZebraCapacitor'
    s.version = '0.0.2'
    s.summary = 'Ionic Capacitor plugin for Zebra Printers'
    s.license = 'MIT'
    s.homepage = 'https://github.com/cleversolutions/zebraCapacitor/'
    s.author = 'Evan Moore'
    s.source = { :git => 'https://github.com/cleversolutions/zebraCapacitor/', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '10.0'
    s.dependency 'Capacitor'
  end