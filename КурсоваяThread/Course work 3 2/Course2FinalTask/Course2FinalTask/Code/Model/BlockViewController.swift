//
//  BlockViewController.swift
//  Course2FinalTask
//
//  Created by Евгений on 12.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class BlockViewController: UIViewController {
    
    private let sendView: UIView
    
    init(view: UIView) {
        self.sendView = view
        super.init(nibName: nil, bundle: nil)
        self.setingsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let blockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private func setingsUI() {
        
        sendView.addSubview(blockView)
        sendView.addSubview(indicator)
        
        let constraints = [blockView.leadingAnchor.constraint(equalTo: sendView.leadingAnchor),
                           blockView.trailingAnchor.constraint(equalTo: sendView.trailingAnchor),
                           blockView.topAnchor.constraint(equalTo: sendView.topAnchor),
                           blockView.bottomAnchor.constraint(equalTo: sendView.bottomAnchor),
                           
                           indicator.leadingAnchor.constraint(equalTo: sendView.leadingAnchor, constant: view.frame.width / 2),
                           indicator.topAnchor.constraint(equalTo: sendView.topAnchor, constant: view.frame.height / 2)]
        NSLayoutConstraint.activate(constraints)
    }
    
    func startAnimating() {
        blockView.isHidden = false
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        blockView.isHidden = true
        indicator.stopAnimating()
    }
}
