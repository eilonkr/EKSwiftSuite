//
//  PlayerView.swift
//  
//
//  Created by Eilon Krauthammer on 22/04/2021.
//
#if !os(macOS)

import UIKit
import AVFoundation

open class PlayerView: UIView {
    public var player: AVPlayer? {
        get {
            return playerLayer?.player
        }
        set {
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.player = newValue
        }
    }
    
    public weak var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
    
    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
#endif
