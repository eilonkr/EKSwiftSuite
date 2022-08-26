//
//  MediaView.swift
//  Watermarker
//
//  Created by Eilon Krauthammer on 10/03/2022.
//

import UIKit
import AVFoundation

class MediaView: UIView {
    enum Style {
        case none
        case border
    }
    
    public var asset: Asset? {
        didSet {
            configureMedia()
        }
    }
    
    public var style: Style
    
    var currentVideoTime: CMTime? {
        (currentView as? PlayerView)?.player?.currentTime()
    }
    
    private var currentView: UIView?
    
    var isVideoMuted: Bool {
        get {
            (currentView as? PlayerView)?.isMuted == true
        } set {
            (currentView as? PlayerView)?.isMuted = newValue
        }
    }
    
    init(asset: Asset, style: Style = .none) {
        self.asset = asset
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.style = .none
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureMedia()
        applyStyle()
    }
    
    private func configureMedia() {
        subviews.first?.removeFromSuperview()
        
        switch asset {
        case .image(let image):
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.fix(in: self)
            imageView.roundCorners(to: .custom(10.0))
            currentView = imageView
            
        case .video(let asset):
            let playerView = PlayerView()
            playerView.player = AVQueuePlayer(playerItem: AVPlayerItem(asset: asset))
            playerView.player?.play()
            playerView.fix(in: self)
            playerView.clipsToBounds = true
            playerView.roundCorners(to: .custom(10.0))
            currentView = playerView
            
        case .none:
            break
        }
    }
    
    private func applyStyle() {
        roundCorners(to: .custom(10.0))
        
        switch style {
        case .none:
            break
            
        case .border:
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 10.0
            layer.applyShadow(color: .black, radius: 14.0, opacity: 0.12, offsetY: 2)
        }
    }
    
    public func seekTo(time: CMTime) {
        guard let playerView = currentView as? PlayerView else { return }
        playerView.player?.seek(to: time)
    }
}
