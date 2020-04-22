//
//  CommonCollectionView.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CommonCollectionView: UICollectionView {
    
    var direction: ScrollDirection = .horizontal
    var number: CGFloat = 2
    var padding: CGFloat = 0
    var itemWidth: CGFloat = 0 {
        didSet {
            var rect = frame
            rect.size.width = itemWidth
            frame = rect
            reloadData()
        }
    }
    
    var dataArray: [CellModel] = []
    
    init(_ direction: ScrollDirection = .horizontal, number: CGFloat = 2, padding: CGFloat = 0, frame: CGRect = ScreenBounds) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = direction
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.itemSize = CGSize()
        layout.sectionInset = UIEdgeInsets()
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(CommonCollectionViewCell.self, forCellWithReuseIdentifier: CommonCollectionViewCell.className)
        
        self.number = number
        self.padding = padding
        itemWidth = frame.width
        
        for _ in 0..<10 {
            dataArray.append(CellModel())
        }
        reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension CommonCollectionView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCollectionViewCell.className, for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (itemWidth - padding) / number - padding
        let h = (height - padding) / number - padding
        return CGSize(width: w, height: h)
    }
    
}
