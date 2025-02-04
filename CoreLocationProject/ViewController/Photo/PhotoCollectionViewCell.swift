//
//  PhotoCollectionViewCell.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/4/25.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    let photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - View Setting
    private func configureHierarchy() {
        contentView.addSubview(photoImageView)
    }
    
    private func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        photoImageView.image = UIImage(systemName: "film")
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
      }
    
    // MARK: - Data Setting
    func configureData(_ image: UIImage){
        photoImageView.image = image
    }
    
}
