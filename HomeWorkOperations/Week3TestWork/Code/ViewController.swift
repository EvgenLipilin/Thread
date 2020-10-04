//
//  ViewController.swift
//  Week3TestWork
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var bruteForcedTimeLabel: UILabel!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var generatePasswordButton: UIButton!
    
    private let passwordGenerate = PasswordGenerator()
    private let characterArray = Consts.characterArray
    private let maxTextLength = Consts.maxTextFieldTextLength
    private var password = ""
    
    
    //Очередь dispatch
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos:.userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global(qos: .userInitiated))
    
    //Очередь operation
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        disableStartButton()
        
        //Hide keyboard on screen tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tap)
        inputTextField.delegate = self
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func generatePasswordButtonPressed(_ sender: UIButton) {
        clearText()
        inputTextField.text = passwordGenerate.randomString(length: 4)
        enableStartButton()
    }
    
    @IBAction func startBruteFoceButtonPressed(_ sender: Any) {
        guard let text = inputTextField.text else {
            return
        }
        indicator.isHidden = false
        indicator.startAnimating()
        password = text
        clearText()
        disableStartButton()
        statusLabel.text = "Status: in process"
        generatePasswordButton.isEnabled = true
        generatePasswordButton.alpha = 0.5
        start()
    }
    
    private func start() {
        let startTime = Date()
        bruteForce(startString: "0000", endString: "ZZZZ", startTime: startTime)
    }
    
    // Возвращает подобранный пароль
    private func bruteForce(startString: String, endString: String, startTime: Date) {
        let inputPassword = password
        var startIndexArray = [Int]()
        var endIndexArray = [Int]()
        let maxIndexArray = characterArray.count
        
        // Создает массивы индексов из входных строк
        for char in startString {
            for (index, value) in characterArray.enumerated() where value == "\(char)" {
                startIndexArray.append(index)
            }
        }
        for char in endString {
            for (index, value) in characterArray.enumerated() where value == "\(char)" {
                endIndexArray.append(index)
            }
        }
        //Создание массива массивов индекса для Operation последовательно
        
        var indexArray = [[Int]]()
        for index in 0...maxIndexArray-1 {
            let myArray = startIndexArray.map({$0 + index})
            indexArray.append(myArray)
        }
        
        // Цикл создания операций по подбору
        
        for (index,_) in indexArray.enumerated() {
            
            guard !indexArray[index].elementsEqual(endIndexArray) else {break}
            let operation = PasswordBrute(startIndexArray: indexArray[index], endIndexArray: indexArray[index+1], password: inputPassword)
            
            operation.completionBlock = {
                if operation.findPasswordOperation != nil {
                    self.queue.cancelAllOperations()
                    
                    DispatchQueue.main.async {
                        self.stop(password: operation.findPasswordOperation ?? "Error", startTime: startTime )
                    }
                }
            }
            
            queue.addOperation(operation)
        }
    }
    
    //Обновляем UI
    private func stop(password: String, startTime: Date) {
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        enableStartButton()
        generatePasswordButton.isEnabled = true
        generatePasswordButton.alpha = 1
        passwordLabel.text = "Password is: \(password)"
        statusLabel.text = "Status: Complete"
        bruteForcedTimeLabel.text = "\(String(format: "Time: %.2f", Date().timeIntervalSince(startTime))) seconds"
        
    }
    
    private func clearText() {
        statusLabel.text = "Status:"
        bruteForcedTimeLabel.text = "Time:"
        passwordLabel.text = "Password is:"
    }
    
    private func disableStartButton() {
        startButton.isEnabled = false
        startButton.alpha = 0.5
    }
    
    private func enableStartButton() {
        startButton.isEnabled = true
        startButton.alpha = 1
    }
}

// Добавляем делегат для управления вводом текста в UITextField
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let charCount = inputTextField.text?.count else {
            return
        }
        if charCount != maxTextLength {
            Alert.showBasic(title: "Incorrect password", message: "Password must be 4 characters long", vc: self)
        }
        if charCount > 3 {
            enableStartButton()
        } else {
            disableStartButton()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearText()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        
        let acceptableCharacters = Consts.joinedString
        let characterSet = CharacterSet(charactersIn: acceptableCharacters).inverted
        let newString = NSString(string: text).replacingCharacters(in: range, with: string)
        let filtered = newString.rangeOfCharacter(from: characterSet) == nil
        return newString.count <= maxTextLength && filtered
    }
    
}
