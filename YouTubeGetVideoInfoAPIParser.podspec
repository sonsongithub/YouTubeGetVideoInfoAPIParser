Pod::Spec.new do |s|
  s.name             = "YouTubeGetVideoInfoAPIParser"
  s.version          = "1.0.0"
  s.summary          = "Swift Library to parse YouTube streaming data from get_video_info API."
  s.description      = <<-DESC
                         Provides functions and structs to hadling YouTube streaming information.
                       DESC
  s.homepage         = "https://github.com/sonsongithub/YouTubeGetVideoInfoAPIParser"
  s.license          = 'MIT'
  s.author           = { "sonson" => "yoshida.yuichi@gmail.com" }
  s.source           = {
    :git => "https://github.com/sonsongithub/YouTubeGetVideoInfoAPIParser.git",
    :tag => "v#{s.version}"
  }

  s.social_media_url = 'https://twitter.com/sonson_twit'
  s.ios.deployment_target = "8.4"
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.2"
  s.requires_arc = true
  s.source_files = 'YouTubeGetVideoInfoAPIParser/*.swift'
end
