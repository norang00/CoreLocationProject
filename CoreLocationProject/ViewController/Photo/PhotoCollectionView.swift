//
//  PhotoCollectionView.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/4/25.
//

import UIKit

final class PhotoCollectionView: UICollectionView {
    static func createCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 2
        let size = (UIScreen.main.bounds.width-(spacing*2))/3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: size, height: size)
        return layout
    }
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        showsVerticalScrollIndicator = false
        register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
}
