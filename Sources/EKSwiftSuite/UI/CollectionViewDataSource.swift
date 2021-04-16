//
//  CollectionViewDataSource.swift
//  
//
//  Created by Eilon Krauthammer on 16/04/2021.
//

import UIKit

class CollectionViewDataSource<Cell: UICollectionViewCell & Providable>: NSObject, UICollectionViewDataSource {
    
    typealias Item = Cell.Item
    
    public var onChange: (() -> Void)?
    
    public var items: [Item] = [] {
        didSet { onChange?() }
    }
    private let reuseIdentifier: String
    
    init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell
        cell.provide(items[indexPath.item])
        return cell
    }
}
