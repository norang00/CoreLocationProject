//
//  PhotoViewController.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/4/25.
//

import UIKit
import SnapKit
import PhotosUI

final class PhotoViewController: UIViewController {
    
    var photoClosure: ((UIImage) -> Void)?
    let photoCollectionView = PhotoCollectionView(frame: .zero, collectionViewLayout: PhotoCollectionView.createCollectionViewLayout())
    var photoList: [UIImage] = []

    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()

        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton

        configureView()
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(photoCollectionView)
        
        photoCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    @objc
    func plusButtonTapped() {
        print(#function)
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 30
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
}
// MARK: - Collection
extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configureData(photoList[indexPath.item])
        print(#function, indexPath, photoList[indexPath.item], cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let photo = photoList[indexPath.item]
        photoClosure?(photo)
        dismiss(animated: true)
    }
}

// MARK: - Photo
extension PhotoViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        for result in results {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let photo = image as? UIImage {
                        self.photoList.append(photo)
                        self.dispatchGroup.leave()
                    }
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.photoCollectionView.reloadData()
            self.dismiss(animated: true)
        }
    }
    
}
