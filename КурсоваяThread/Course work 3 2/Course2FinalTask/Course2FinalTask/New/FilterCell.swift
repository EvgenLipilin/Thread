//
//  FilterCell.swift
//  Course2FinalTask
//
//  Created by Евгений on 12.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    //    MARK:- Properties
    private let queue = OperationQueue()
    
    private let filterName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private let filteredImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK:- Methods
    func createCell(name: String, image: UIImage) {
        filterName.text = name
        
        let operation = FilterOperation(image: image, filter: name)
        operation.completionBlock = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.filteredImage.image = operation.outputImage
            }
        }
        queue.addOperation(operation)
    }
    
    private func createUI() {
        addSubview(filterName)
        addSubview(filteredImage)
        
        let constraints = [filterName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                           filterName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                           
                           filteredImage.bottomAnchor.constraint(equalTo: filterName.topAnchor, constant: -8),
                           filteredImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                           filteredImage.widthAnchor.constraint(equalToConstant: 50),
                           filteredImage.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
