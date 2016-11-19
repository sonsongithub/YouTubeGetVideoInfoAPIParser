[![Version](http://img.shields.io/cocoapods/v/YouTubeStreamingURLParser.svg?style=flat)](http://cocoadocs.org/docsets/YouTubeStreamingURLParser)
[![License](https://img.shields.io/cocoapods/l/YouTubeStreamingURLParser.svg?style=flat)](http://cocoadocs.org/docsets/YouTubeStreamingURLParser)
[![Platform](https://img.shields.io/cocoapods/p/YouTubeStreamingURLParser.svg?style=flat)](http://cocoadocs.org/docsets/YouTubeStreamingURLParser)

# YouTubeStreamingURLParser
Swift Library to parse YouTube streaming data from get\_video\_info API.

## Text parser for YouTube streaming in Swift

* https://www.youtube.com/get\_video\_info?video_id=XXXXXXXXXXXXX
* This API returns a streaming information with CGI parameter style.

```
token=<value>&idpj=<value>&as_launched_in_country=<value>&iurlmq=<value>&
view_count=<value>&iurl=<value>&iv_invideo_url=<value>&thumbnail_url=<value>&
sffb=<value>&cc_font=<value>&keywords=<value>&fade_out_duration_milliseconds=<value>&
ad_module=<value>&csi_page_type=<value>&shortform=<value>&c=<value>&
allowed_ads=<value>&timestamp=<value>&plid=<value>&title=<value>&
allow_html5_ads=<value>&probe_url=<value>&afv=<value>&midroll_prefetch_size=<value>&
account_playback_token=<value>&adsense_video_doc_id=<value>&iurlsd=<value>&
of=<value>&caption_tracks=<value>&watermark=<value>&use_cipher_signature=<value>&
dbp=<value>&default_audio_track_index=<value>&midroll_freqcap=<value>&
excluded_ads=<value>&ad_flags=<value>&allow_ratings=<value>&no_get_video_log=<value>&
cver=<value>&cc_asr=<value>&iurlmaxres=<value>&caption_translation_languages=<value>&
iv_load_policy=<value>&fade_in_duration_milliseconds=<value>&video_verticals=<value>&
ptchn=<value>&oid=<value>&iurlhq=<value>&gut_tag=<value>&
apply_fade_on_midrolls=<value>&instream_long=<value>&adaptive_fmts=<value>&
dashmpd=<value>&cid=<value>&muted=<value>&subtitles_xlb=<value>&
core_dbp=<value>&cc3_module=<value>&cl=<value>&storyboard_spec=<value>&
ptk=<value>&iv_allow_in_place_switch=<value>&vm=<value>&video_id=<value>&
ad_device=<value>&url_encoded_fmt_stream_map=<value>&iv_module=<value>&
ad_logging_flag=<value>&author=<value>&pltype=<value>&fade_in_start_milliseconds=<value>&
mpvid=<value>&caption_audio_tracks=<value>&cc_module=<value>&
cc_fonts_url=<value>&ad_slots=<value>&has_cc=<value>&show_content_thumbnail=<value>&
ldpj=<value>&iv3_module=<value>&length_seconds=<value>&tmi=<value>&
hl=<value>&ypc_ad_indicator=<value>&ttsurl=<value>&enabled_engage_types=<value>&
is_listed=<value>&ucid=<value>&eventid=<value>&fade_out_start_milliseconds=<value>&
fmt_list=<value>&avg_rating=<value>&fexp=<value>&tag_for_child_directed=<value>&
loeid=<value>&afv_ad_tag=<value>&allow_embed=<value>&enablecsi=<value>&status=ok
```

## Streaming URL in "url\_encoded\_fmt\_stream\_map"

* "url\_encoded\_fmt\_stream\_map" includes CGI parameter style text which is comma seperated.

```
<entry>,<entry>,<entry>,<entry>,<entry>,<entry>,<entry>
```

```
fallback_host=tc.v17.cache7.googlevideo.com&
itag=22&
url=<URL>&
type=video%2Fmp4%3B+codecs%3D%22avc1.64001F%2C+mp4a.40.2%22&
quality=hd720
```

## How to use

```
let infoURL = NSURL(string:"https://www.youtube.com/get_video_info?video_id=\(youtubeContentID)") {
let URLRequest = NSMutableURLRequest(URL: infoURL)
let session = NSURLSession(configuration: sessionConfiguration)
let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data, response, error) -> Void in
    if let error = error {
        print(error)
    } else if let data = data, result = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
        // Pattern 1
        // Get streaming map directly
	    let maps = FormatStreamMapFromString(result)
	    if let map = maps.first {
	        print(map.url)
	    }
	    // Pattern 2
	    // Get streaming informaton
	    // You can access stream map from this object, too.
	    let streaming = YouTubeStreamingFromString(result)
	    print(streaming.title)
    }
})
task.resume()

```
