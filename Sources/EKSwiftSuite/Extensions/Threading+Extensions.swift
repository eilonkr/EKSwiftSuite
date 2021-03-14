//
//  Threading+Extensions.swift
//  
//
//  Created by Eilon Krauthammer on 05/02/2021.
//

import Foundation

public extension DispatchQueue {
    func asyncWithTimeout(_ timeout: TimeInterval, execute block: @escaping () -> Void) {
        let workItem = DispatchWorkItem(block: block)
        async(execute: block)
        asyncAfter(deadline: .now() + timeout) { [weak workItem] in
            workItem?.cancel()
        }
    }
    
    static func delay(_ interval: TimeInterval, _ execute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: execute)
    }
}
