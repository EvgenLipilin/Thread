//
//  AddFilterViewController.swift
//  Course2FinalTask
//
//  Created by Евгений on 12.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class AddFilterViewController: UIViewController {
    
    private var inputBigImage: UIImage
    private var inputSmallImage: UIImage
    private lazy var alert = AlertViewController(view: self)
    private lazy var block = BlockViewController(view: (tabBarController?.view)!)
    private let queue = OperationQueue()
    private let cellIdentifier = "cell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.register(FilterCell.self, forCellWithReuseIdentifier: "cell")
        return collView
    }()
    
    private let arrayOfFilters = ["CIGaussianBlur", "CIMotionBlur", "CIColorInvert", "CISepiaTone", "CIPhotoEffectNoir"]
    
    init(bigImage: UIImage, smallImage: UIImage) {
        self.inputBigImage = bigImage
        self.inputSmallImage = smallImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    func createUI() {
        title = "Filters"
        view.backgroundColor = .white
        view.addSubview(photoImageView)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        photoImageView.image = inputBigImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(tapRightBarButton))
        
        let constarints = [photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                           photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
                           
                           collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                           collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           collectionView.heightAnchor.constraint(equalToConstant: 120)]
        
        NSLayoutConstraint.activate(constarints)
    }
    
    @objc private func tapRightBarButton() {
        guard let image = photoImageView.image else { alert.createAlert {_ in }
            return }
        navigationController?.pushViewController(ShareViewController(image: image), animated: true)
    }
}

//    MARK:- DAtaSource and Delegate
extension AddFilterViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FilterCell else { alert.createAlert {_ in}
            return UICollectionViewCell() }
        let nameFilter = arrayOfFilters[indexPath.item]
        cell.createCell(name: nameFilter, image: inputSmallImage)
        
        return cell
    }
    
    //    Создание операций по применению фильтров
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let filter = arrayOfFilters[indexPath.item]
        block.startAnimating()
        
        let operation = FilterOperation(image: inputBigImage, filter: filter)
        
        operation.completionBlock = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.photoImageView.image = operation.outputImage ?? UIImage()
                self.block.stopAnimating()
            }
        }
        queue.addOperation(operation)
    }
}
