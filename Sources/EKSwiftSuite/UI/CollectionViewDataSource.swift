//
//  CollectionViewDataSource.swift
//  
//
//  Created by Eilon Krauthammer on 16/04/2021.
//

import UIKit

open class CollectionViewDataSource<Cell: UICollectionViewCell & Providable>: NSObject, UICollectionViewDataSource {
    
    public typealias Item = Cell.Item
    
    public var cellConfigurator: ((Cell) -> Void)?
    public var onChange: (() -> Void)?
    
    public var items: [Item] = [] {
        didSet { onChange?() }
    }
    
    private let reuseIdentifier: String
    
    public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell
        cell.provide(items[indexPath.item])
        cellConfigurator?(cell)
        return cell
    }
}
