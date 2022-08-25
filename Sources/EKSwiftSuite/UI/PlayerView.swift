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
    public var shouldLoop: Bool = true {
        didSet {
            configureLooping()
        }
    }
    
    private var playerLooper: AVPlayerLooper?
    
    public var isMuted: Bool {
        get {
            player?.isMuted == true
        } set {
            player?.isMuted = newValue
        }
    }
    
    public var player: AVQueuePlayer? {
        get {
            return playerLayer?.player as? AVQueuePlayer
        }
        set {
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.player = newValue
            configureLooping()
        }
    }
    
    public weak var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
    
    // Override UIView property
    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    init(asset: AVURLAsset) {
        super.init()
        self.player = AVQueuePlayer(url: asset.url)
    }
    
    private func configureLooping() {
        if shouldLoop, let player = player, let playerItem = player.currentItem {
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        } else {
            playerLooper = nil
        }
    }
}

#endif
