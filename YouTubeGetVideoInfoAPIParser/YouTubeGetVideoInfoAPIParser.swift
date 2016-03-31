//
//  YouTubeGetVideoInfoAPIParser.swift
//  YouTubeGetVideoInfoAPIParser
//
//  Created by sonson on 2016/03/31.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation


func str2dict(str: String) -> [String:String] {
    return str.componentsSeparatedByString("&").reduce([:] as [String:String], combine: {
        var d = $0
        let components = $1.componentsSeparatedByString("=")
        if components.count == 2 {
            d[components[0]] = components[1]
        }
        return d
    })
}

func YouTubeStreamingWithDictionary(dict: [String:String]) -> YouTubeStreamingInfo? {
    let newDict = dict.reduce([:] as [String:String], combine: {
        var d = $0
        if let key = $1.0.stringByRemovingPercentEncoding, value = $1.1.stringByRemovingPercentEncoding {
            d[key] = value
        }
        return d
    })
    guard let type = newDict["type"] else { return nil }
    guard let urlString = newDict["url"] else { return nil }
    guard let url = NSURL(string: urlString) else { return nil }
    guard let quality = newDict["quality"] else { return nil }
    let itag = newDict["itag"] ?? ""
    let s = newDict["s"] ?? ""
    let fallback_host = newDict["fallback_host"] ?? ""
    return YouTubeStreamingInfo(type: type, itag: itag, quality: quality, fallbackHost: fallback_host, s: s, url: url)
}

func extractMp4Streaming(streamings: [YouTubeStreamingInfo]) -> YouTubeStreamingInfo? {
    for streaming in streamings {
        if let _ = streaming.type.rangeOfString("video/mp4") {
            return streaming
        }
    }
    return nil
}

enum YouTubeStreamingQuality : Comparable {
    case Small
    case Medium
    case Large
    case Hd720
    case Other
    
    init(_ value: String) {
        switch value {
        case "small":
            self = .Small
        case "medium":
            self = .Medium
        case "large":
            self = .Large
        case "hd720":
            self = .Hd720
        default:
            self = .Other
        }
    }
    
    var level: Int {
        get {
            switch self {
            case .Small:
                return 1
            case .Medium:
                return 2
            case .Large:
                return 3
            case .Hd720:
                return 4
            default:
                return 5
            }
        }
    }
}

func ==(x: YouTubeStreamingQuality, y: YouTubeStreamingQuality) -> Bool { return x.level == y.level }
func <(x: YouTubeStreamingQuality, y: YouTubeStreamingQuality) -> Bool { return x.level < y.level }

struct YouTubeStreamingInfo {
    let type: String
    let itag: String
    let quality: YouTubeStreamingQuality
    let fallbackHost: String
    let url: NSURL
    let s: String
    
    init(type: String, itag: String, quality: String, fallbackHost: String, s: String, url: NSURL) {
        self.type = type
        self.itag = itag
        self.quality = YouTubeStreamingQuality(quality)
        self.fallbackHost = fallbackHost
        self.url = url
        self.s = s
    }
}

struct YouTubeStreaming {
    /// csi_page_type
    let csiPageType: String
    /// url_encoded_fmt_stream_map
    let urlEncodedFmtStreamMap: String
    /// enabled_engage_types
    let enabledEngageTypes: String
    /// tag_for_child_directed
    let tagForChildDirected: Bool
    /// enablecsi
    let enablecsi: Int
    /// caption_tracks
    let captionTracks: String
    /// ptk
    let ptk: String
    /// account_playback_token
    let accountPlaybackToken: String
    /// ad_device
    let adDevice: Int
    /// c
    let c: String
    /// video_verticals
    let videoVerticals: String
    /// iurlmq
    let iurlmq: String
    /// cc_asr
    let ccAsr: Int
    /// ptchn
    let ptchn: String
    /// iv_invideo_url
    let ivInvideoUrl: String
    /// status
    let status: String
    /// as_launched_in_country
    let asLaunchedInCountry: Int
    /// allow_html5_ads
    let allowHtml5Ads: Int
    /// cc3_module
    let cc3Module: Int
    /// ad_module
    let adModule: String
    /// timestamp
    let timestamp: Float
    /// adsense_video_doc_id
    let adsenseVideoDocId: String
    /// oid
    let oid: String
    /// ypc_ad_indicator
    let ypcAdIndicator: Float
    /// keywords
    let keywords: String
    /// avg_rating
    let avgRating: Float
    /// mpvid
    let mpvid: String
    /// default_audio_track_index
    let defaultAudioTrackIndex: Int
    /// pltype
    let pltype: String
    /// length_seconds
    let lengthSeconds: Int
    /// watermark
    let watermark: String
    /// ucid
    let ucid: String
    /// afv_ad_tag
    let afvAdTag: String
    /// of
    let of: String
    /// cver
    let cver: Float
    /// ad_flags
    let adFlags: Int
    /// allow_ratings
    let allowRatings: Int
    /// allow_embed
    let allowEmbed: Int
    /// show_content_thumbnail
    let showContentThumbnail: Bool
    /// gut_tag
    let gutTag: String
    /// fexp
    let fexp: String
    /// midroll_prefetch_size
    let midrollPrefetchSize: Int
    /// shortform
    let shortform: Bool
    /// dbp
    let dbp: String
    /// probe_url
    let probeUrl: String
    /// sffb
    let sffb: Bool
    /// cc_font
    let ccFont: String
    /// allowed_ads
    let allowedAds: String
    /// tmi
    let tmi: Int
    /// storyboard_spec
    let storyboardSpec: String
    /// fade_in_duration_milliseconds
    let fadeInDurationMilliseconds: Int
    /// idpj
    let idpj: Int
    /// is_listed
    let isListed: Int
    /// fmt_list
    let fmtList: String
    /// iv_module
    let ivModule: String
    /// iurlmaxres
    let iurlmaxres: String
    /// adaptive_fmts
    let adaptiveFmts: String
    /// author
    let author: String
    /// apply_fade_on_midrolls
    let applyFadeOnMidrolls: Bool
    /// has_cc
    let hasCc: Bool
    /// fade_in_start_milliseconds
    let fadeInStartMilliseconds: Int
    /// cc_fonts_url
    let ccFontsUrl: String
    /// no_get_video_log
    let noGetVideoLog: Int
    /// ad_slots
    let adSlots: Int
    /// iv_load_policy
    let ivLoadPolicy: Int
    /// iv_allow_in_place_switch
    let ivAllowInPlaceSwitch: Int
    /// vm
    let vm: String
    /// cc_module
    let ccModule: String
    /// excluded_ads
    let excludedAds: String
    /// iurlhq
    let iurlhq: String
    /// plid
    let plid: String
    /// muted
    let muted: Int
    /// loeid
    let loeid: String
    /// title
    let title: String
    /// dashmpd
    let dashmpd: String
    /// fade_out_start_milliseconds
    let fadeOutStartMilliseconds: Int
    /// iurl
    let iurl: String
    /// instream_long
    let instreamLong: Bool
    /// cid
    let cid: Int
    /// iurlsd
    let iurlsd: String
    /// use_cipher_signature
    let useCipherSignature: Bool
    /// ttsurl
    let ttsurl: String
    /// caption_translation_languages
    let captionTranslationLanguages: String
    /// core_dbp
    let coreDbp: String
    /// video_id
    let videoId: String
    /// token
    let token: String
    /// eventid
    let eventid: String
    /// caption_audio_tracks
    let captionAudioTracks: String
    /// cl
    let cl: Float
    /// iv3_module
    let iv3Module: Int
    /// ldpj
    let ldpj: Int
    /// afv
    let afv: Bool
    /// fade_out_duration_milliseconds
    let fadeOutDurationMilliseconds: Int
    /// hl
    let hl: String
    /// subtitles_xlb
    let subtitlesXlb: String
    /// view_count
    let viewCount: Int
    /// ad_logging_flag
    let adLoggingFlag: Int
    /// thumbnail_url
    let thumbnailUrl: String
    /// midroll_freqcap
    let midrollFreqcap: Float
    
    ///
    let map: [YouTubeStreamingInfo]
    
    init(dict2: [String:String]) {
        
        let dict = dict2.reduce([:] as [String:String], combine: {
            var d = $0
            if let key = $1.0.stringByRemovingPercentEncoding, value = $1.1.stringByRemovingPercentEncoding {
                d[key] = value
            }
            return d
        })
        
        csiPageType = dict["csi_page_type"] ?? ""
        urlEncodedFmtStreamMap = dict["url_encoded_fmt_stream_map"] ?? ""
        enabledEngageTypes = dict["enabled_engage_types"] ?? ""
        tagForChildDirected = (dict["tag_for_child_directed"] ?? "false").lowercaseString == "true"
        enablecsi = Int(dict["enablecsi"] ?? "0") ?? 0
        captionTracks = dict["caption_tracks"] ?? ""
        ptk = dict["ptk"] ?? ""
        accountPlaybackToken = dict["account_playback_token"] ?? ""
        adDevice = Int(dict["ad_device"] ?? "0") ?? 0
        c = dict["c"] ?? ""
        videoVerticals = dict["video_verticals"] ?? ""
        iurlmq = dict["iurlmq"] ?? ""
        ccAsr = Int(dict["cc_asr"] ?? "0") ?? 0
        ptchn = dict["ptchn"] ?? ""
        ivInvideoUrl = dict["iv_invideo_url"] ?? ""
        status = dict["status"] ?? ""
        asLaunchedInCountry = Int(dict["as_launched_in_country"] ?? "0") ?? 0
        allowHtml5Ads = Int(dict["allow_html5_ads"] ?? "0") ?? 0
        cc3Module = Int(dict["cc3_module"] ?? "0") ?? 0
        adModule = dict["ad_module"] ?? ""
        timestamp = Float(dict["timestamp"] ?? "0") ?? 0
        adsenseVideoDocId = dict["adsense_video_doc_id"] ?? ""
        oid = dict["oid"] ?? ""
        ypcAdIndicator = Float(dict["ypc_ad_indicator"] ?? "0") ?? 0
        keywords = dict["keywords"] ?? ""
        avgRating = Float(dict["avg_rating"] ?? "0") ?? 0
        mpvid = dict["mpvid"] ?? ""
        defaultAudioTrackIndex = Int(dict["default_audio_track_index"] ?? "0") ?? 0
        pltype = dict["pltype"] ?? ""
        lengthSeconds = Int(dict["length_seconds"] ?? "0") ?? 0
        watermark = dict["watermark"] ?? ""
        ucid = dict["ucid"] ?? ""
        afvAdTag = dict["afv_ad_tag"] ?? ""
        of = dict["of"] ?? ""
        cver = Float(dict["cver"] ?? "0") ?? 0
        adFlags = Int(dict["ad_flags"] ?? "0") ?? 0
        allowRatings = Int(dict["allow_ratings"] ?? "0") ?? 0
        allowEmbed = Int(dict["allow_embed"] ?? "0") ?? 0
        showContentThumbnail = (dict["show_content_thumbnail"] ?? "false").lowercaseString == "true"
        gutTag = dict["gut_tag"] ?? ""
        fexp = dict["fexp"] ?? ""
        midrollPrefetchSize = Int(dict["midroll_prefetch_size"] ?? "0") ?? 0
        shortform = (dict["shortform"] ?? "false").lowercaseString == "true"
        dbp = dict["dbp"] ?? ""
        probeUrl = dict["probe_url"] ?? ""
        sffb = (dict["sffb"] ?? "false").lowercaseString == "true"
        ccFont = dict["cc_font"] ?? ""
        allowedAds = dict["allowed_ads"] ?? ""
        tmi = Int(dict["tmi"] ?? "0") ?? 0
        storyboardSpec = dict["storyboard_spec"] ?? ""
        fadeInDurationMilliseconds = Int(dict["fade_in_duration_milliseconds"] ?? "0") ?? 0
        idpj = Int(dict["idpj"] ?? "0") ?? 0
        isListed = Int(dict["is_listed"] ?? "0") ?? 0
        fmtList = dict["fmt_list"] ?? ""
        ivModule = dict["iv_module"] ?? ""
        iurlmaxres = dict["iurlmaxres"] ?? ""
        adaptiveFmts = dict["adaptive_fmts"] ?? ""
        author = dict["author"] ?? ""
        applyFadeOnMidrolls = (dict["apply_fade_on_midrolls"] ?? "false").lowercaseString == "true"
        hasCc = (dict["has_cc"] ?? "false").lowercaseString == "true"
        fadeInStartMilliseconds = Int(dict["fade_in_start_milliseconds"] ?? "0") ?? 0
        ccFontsUrl = dict["cc_fonts_url"] ?? ""
        noGetVideoLog = Int(dict["no_get_video_log"] ?? "0") ?? 0
        adSlots = Int(dict["ad_slots"] ?? "0") ?? 0
        ivLoadPolicy = Int(dict["iv_load_policy"] ?? "0") ?? 0
        ivAllowInPlaceSwitch = Int(dict["iv_allow_in_place_switch"] ?? "0") ?? 0
        vm = dict["vm"] ?? ""
        ccModule = dict["cc_module"] ?? ""
        excludedAds = dict["excluded_ads"] ?? ""
        iurlhq = dict["iurlhq"] ?? ""
        plid = dict["plid"] ?? ""
        muted = Int(dict["muted"] ?? "0") ?? 0
        loeid = dict["loeid"] ?? ""
        title = dict["title"] ?? ""
        dashmpd = dict["dashmpd"] ?? ""
        fadeOutStartMilliseconds = Int(dict["fade_out_start_milliseconds"] ?? "0") ?? 0
        iurl = dict["iurl"] ?? ""
        instreamLong = (dict["instream_long"] ?? "false").lowercaseString == "true"
        cid = Int(dict["cid"] ?? "0") ?? 0
        iurlsd = dict["iurlsd"] ?? ""
        useCipherSignature = (dict["use_cipher_signature"] ?? "false").lowercaseString == "true"
        ttsurl = dict["ttsurl"] ?? ""
        captionTranslationLanguages = dict["caption_translation_languages"] ?? ""
        coreDbp = dict["core_dbp"] ?? ""
        videoId = dict["video_id"] ?? ""
        token = dict["token"] ?? ""
        eventid = dict["eventid"] ?? ""
        captionAudioTracks = dict["caption_audio_tracks"] ?? ""
        cl = Float(dict["cl"] ?? "0") ?? 0
        iv3Module = Int(dict["iv3_module"] ?? "0") ?? 0
        ldpj = Int(dict["ldpj"] ?? "0") ?? 0
        afv = (dict["afv"] ?? "false").lowercaseString == "true"
        fadeOutDurationMilliseconds = Int(dict["fade_out_duration_milliseconds"] ?? "0") ?? 0
        hl = dict["hl"] ?? ""
        subtitlesXlb = dict["subtitles_xlb"] ?? ""
        viewCount = Int(dict["view_count"] ?? "0") ?? 0
        adLoggingFlag = Int(dict["ad_logging_flag"] ?? "0") ?? 0
        thumbnailUrl = dict["thumbnail_url"] ?? ""
        midrollFreqcap = Float(dict["midroll_freqcap"] ?? "0") ?? 0
        
        if let value = dict["url_encoded_fmt_stream_map"] {
            map = value
                .componentsSeparatedByString(",")
                .flatMap({ str2dict($0) })
                .flatMap({ YouTubeStreamingWithDictionary($0) })
                .sort({$0.0.quality < $0.1.quality})
        }
        else {
            map = []
        }
    }
}

func YouTubeStreamingInfoFromString(string:String) -> [YouTubeStreamingInfo] {
    let dict = str2dict(string)
    if let value = dict["url_encoded_fmt_stream_map"], decoded = value.stringByRemovingPercentEncoding {
        return decoded
            .componentsSeparatedByString(",")
            .flatMap({ str2dict($0) })
            .flatMap({ YouTubeStreamingWithDictionary($0) })
            .sort({$0.0.quality < $0.1.quality})
    }
    return []
}

func YouTubeStreamingFromString(string:String) -> YouTubeStreaming {
    return YouTubeStreaming(dict2: str2dict(string))
}