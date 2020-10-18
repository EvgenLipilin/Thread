//
//  NewViewController.swift
//  Course2FinalTask
//
//  Created by Евгений on 12.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class NewPostViewController: UIViewController {
    
    private lazy var alert = AlertViewController(view: self)
    @IBOutlet weak var collectionView: UICollectionView!
    private let arrayOfNewBigPhotos = DataProviders.shared.photoProvider.photos()
    private let arrayOfNewSmallPhotos = DataProviders.shared.photoProvider.thumbnailPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(NewPostCell.self, forCellWithReuseIdentifier: identifierNewPost)
        collectionView.dataSource = self
        collectionView.delegate = self
        title = "New"
    }
}


extension NewPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfNewBigPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierNewPost, for: indexPath) as? NewPostCell else { alert.createAlert {_ in }
            return UICollectionViewCell() }
        
        let image = arrayOfNewBigPhotos[indexPath.item]
        cell.createCell(image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(AddFilterViewController(bigImage: arrayOfNewBigPhotos[indexPath.item], smallImage: arrayOfNewSmallPhotos[indexPath.item]), animated: true)
    }
}

