//
//  ViewController.swift
//  brute-force-task
//
//  Created by Zhuldyz Bukeshova on 20.04.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Flags
    
    private var isStart = false
    private var isButtonStopPressed = false
    private let queue = DispatchQueue.global(qos: .background)
    
    // MARK: Outlets
    
    private lazy var textFieldPassword: UITextField = {
        var textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Input your password"
        textFieldPassword.textAlignment = .center
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.backgroundColor = .lightGray
        textFieldPassword.layer.cornerRadius = 15
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        return textFieldPassword
    }()
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "****"
        label.textColor = .link
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorChangebutton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .link
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(buttonColorPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .link
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonStartPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonStopPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(activityIndicatorView)
        view.addSubview(textFieldPassword)
        view.addSubview(label)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(colorChangebutton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: textFieldPassword.centerYAnchor, constant: -100),
            
            textFieldPassword.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textFieldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 50),
            
            label.leadingAnchor.constraint(equalTo: textFieldPassword.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: textFieldPassword.trailingAnchor),
            label.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 5),
            label.heightAnchor.constraint(equalTo: textFieldPassword.heightAnchor),
            
            startButton.leadingAnchor.constraint(equalTo: textFieldPassword.leadingAnchor),
            startButton.trailingAnchor.constraint(equalTo: textFieldPassword.centerXAnchor, constant: -10),
            startButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            startButton.heightAnchor.constraint(equalTo: textFieldPassword.heightAnchor),
            
            stopButton.leadingAnchor.constraint(equalTo: textFieldPassword.centerXAnchor, constant: 10),
            stopButton.trailingAnchor.constraint(equalTo: textFieldPassword.trailingAnchor),
            stopButton.topAnchor.constraint(equalTo: startButton.topAnchor),
            stopButton.heightAnchor.constraint(equalTo: startButton.heightAnchor),
            
            colorChangebutton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            colorChangebutton.heightAnchor.constraint(equalToConstant: 60),
            colorChangebutton.widthAnchor.constraint(equalToConstant: 60),
            colorChangebutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    // MARK: Change background color
    
    private var isBlack: Bool = false {
            didSet {
                if isBlack {
                    self.view.backgroundColor = .black
                } else {
                    self.view.backgroundColor = .white
                }
            }
        }
    
    // MARK: Actions
    
    @objc private func buttonStartPressed() {
        isStart = true
        isButtonStopPressed = false
        textFieldPassword.isSecureTextEntry = true
        bruteForce(passwordToUnlock: textFieldPassword.text ?? "")
    }
    
    @objc private func buttonColorPressed() {
        isBlack.toggle()
    }
    
    @objc private func buttonStopPressed() {
        isButtonStopPressed = !isButtonStopPressed
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? 0
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]): Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var result = string
        
        if result.count <= 0 {
            result.append(characterAt(index: 0, array))
        }
        else {
            result.replace(at: result.count - 1,
                           with: characterAt(index: (indexOf(character: result.last ?? "-", array) + 1) % array.count, array))
            
            if indexOf(character: result.last ?? "-", array) == 0 {
                result = String(generateBruteForce(String(result.dropLast()), fromArray: array)) + String(result.last ?? "-")
            }
        }
        return result
    }

    
    // MARK: Multithreading function
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        queue.async {
            if self.isStart {
                while password != passwordToUnlock && !self.isButtonStopPressed {
                    self.isStart = false
                    password = self.generateBruteForce(password, fromArray: allowedCharacters)
                    DispatchQueue.main.async {
                        self.activityIndicatorView.startAnimating()
                        self.label.text = password
                    }
                }
            }
            
            DispatchQueue.main.async {
                if password == passwordToUnlock {
                    self.label.text = "Your password: \(passwordToUnlock)"
                } else {
                    self.label.text = "Your password: \(passwordToUnlock) is not cracked"
                    self.textFieldPassword.text = ""
                }
                self.textFieldPassword.isSecureTextEntry = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}
