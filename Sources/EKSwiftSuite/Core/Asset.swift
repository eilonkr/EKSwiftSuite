//
//  Asset.swift
//  Watermarker
//
//  Created by Eilon Krauthammer on 23/02/2022.
//

import UIKit
import AVFoundation

enum MediaType {
    case photo
    case video
    case all
    
    var mediaTypes: [String] {
        switch self {
        case .photo:
            return ["public.image"]
        case .video:
            return ["public.movie"]
        case .all:
            return ["public.movie", "public.image"]
        }
    }
}

public enum Asset: Identifiable {
    case image(UIImage)
    case video(AVAsset)
    
    public var id: String {
        return analyticsDescription
    }
    
    public var isImage: Bool {
        switch self {
            case .image(_):
                return true
            case .video(_):
                return false
        }
    }
    
    public var isVideo: Bool? {
        switch self {
            case .image(_):
                return false
            case .video(_):
                return true
        }
    }
    
    public var aspectRatio: CGFloat {
        switch self {
            case .image(let image):
                return image.size.width / image.size.height
            case .video(let asset):
                if let track = asset.tracks(withMediaType: .video).first {
                    let size = track.naturalSize.applying(track.preferredTransform)
                    return abs(size.width) / abs(size.height)
                }
                return 1.0
        }
    }
    
    public var shareItem: Any {
        switch self {
        case .image(let image):
            return image
        case .video(let asset):
            let url = (asset as! AVURLAsset).url
            return url
        }
    }
    
    public var analyticsDescription: String {
        switch self {
        case .image:
            return "image"
        case .video:
            return "video"
        }
    }
}