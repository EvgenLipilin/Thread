//
//  ShareViewController.swift
//  Course2FinalTask
//
//  Created by Евгений on 12.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ShareViewController: UIViewController {
    
    private let postClass = Posts()
    lazy var block = BlockViewController(view: (tabBarController?.view)!)
    private let inputPhoto: UIImage
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.text = "Add description"
        return label
    }()
    
    init(image: UIImage) {
        self.inputPhoto = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confLayout()
    }
    
    private func confLayout() {
        
        view.backgroundColor = .white
        view.addSubview(photoImageView)
        view.addSubview(textField)
        view.addSubview(descriptionLabel)
        photoImageView.image = inputPhoto
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(tapShareButton))
        
        let constraints = [
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 32),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func tapShareButton() {
        block.startAnimating()
        postClass.newPost(with: inputPhoto, description: textField.text ?? "", queue: .global()) { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.block.stopAnimating()
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
}
