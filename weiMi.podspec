Pod::Spec.new do |s|
  s.name         = 'weiMi'
  s.version      = '<#Project Version#>'
  s.license      = '<#License#>'
  s.homepage     = '<#Homepage URL#>'
  s.authors      = '<#Author Name#>': '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  git: '<#Github Repo URL#>', :tag => s.version
  s.source_files = '<#Resources#>'
  s.frameworks   =  '<#Required Frameworks#>'
  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod 'YTKNetwork', '~> 1.3.0'
  s.dependencies =	pod 'Masonry'
  s.dependencies =	pod "OHAlertView"
  s.dependencies =	pod "OHActionSheet"
  s.dependencies =	pod "Toast", "~> 2.4"
  s.dependencies =	pod "MBProgressHUD", "~> 0.9"
  s.dependencies =	pod "OHAttributedLabel"
  s.dependencies =	pod 'OHAttributedStringAdditions', '~> 1.3.0'
  s.dependencies =	pod 'MJRefresh'
  s.dependencies =	pod 'SDWebImage', '~> 3.8.1'
  s.dependencies =	pod 'Routable', '~> 0.1.1'
  s.dependencies =	pod 'PEPhotoCropEditor', '~> 1.3.1'
  s.dependencies =	pod 'MWPhotoBrowser', '~> 2.1.2'
  s.dependencies =	pod 'IQKeyboardManager', '~> 3.3'

end