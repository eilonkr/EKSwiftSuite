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
    
    public var isPlaying = true {
        didSet {
            if isPlaying {
                player?.play()
            } else {
                player?.pause()
            }
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
    
    public init() {
        super.init(frame: .zero)
    }
    
    public init(asset: AVURLAsset) {
        super.init(frame: .zero)
        self.player = AVQueuePlayer(url: asset.url)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
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
