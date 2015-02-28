Pod::Spec.new do |s|
  s.name     = 'LRVariadicPerformSelector'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'Simple NSObject category to perform selectors with variadic arguments.'
  s.homepage = 'https://github.com/luisrecuenco/LRVariadicPerformSelector'
  s.author   = { "Luis Recuenco" => "luis.recuenco@gmail.com" }
  s.source   = { :git => 'https://github.com/luisrecuenco/LRVariadicPerformSelector.git', :tag => '0.1' }
  s.platform     = :ios, '6.0'
  s.source_files = 'NSObject+LRVariadicPerformSelector.{h,m}'
  s.requires_arc = true
end
