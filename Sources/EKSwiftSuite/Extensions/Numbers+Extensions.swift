//
//  Numbers+Extensions.swift
//  
//
//  Created by Eilon Krauthammer on 19/04/2021.
//

import Foundation

public extension Comparable {
    func clamped(_ f: Self, _ t: Self)  ->  Self {
        var r = self
        if r < f { r = f }
        if r > t { r = t }
        return r
    }
}
