//
//  AuthViewController.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 02.11.2021.
//

import UIKit

class AuthViewController: UIViewController {

    //MARK: - setup elements
    private let scrollView: UIScrollView = { //создаем скроллвью
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false //отключаем авто констрейнты
        return scrollView
    }()
    
    private let backgroundView: UIView = { //настраиваем бэкграунд
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel: UILabel = { //настраиваем лейбл
        let label = UILabel()
        label.text = "Log In"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = { //поле почты
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите e-mail"
        return textField
    }()
    
    private let passwordTextField: UITextField = { //поле пароля
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    //настриваем кнопки логина или регистрации
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //настраиваем вью
    private func setupViews() {
        title = "Sign In"
        view.backgroundColor = .white
        
        //настраиваем стэк вью
        textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField],
                                         axis: .vertical,
                                         spacing: 10,
                                         distribution: .fillProportionally)
        
        buttonsStackView = UIStackView(arrangedSubviews: [signInButton,signUpButton],
                                       axis: .vertical,
                                       spacing: 10,
                                       distribution: .fillProportionally)
        
        //добавляем на вью элементы
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textFieldsStackView)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(buttonsStackView)
    }
    
    //назначаем делегатов для полей
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //настраиваем переходы к контроллерам
    @objc private func signUpButtonTapped() { //переход к контроллеру регистрации
        let signUpIViewController = SignUpViewController()
        self.present(signUpIViewController, animated: true)
    }
    
    @objc private func signInButtonTapped() {
        
        let mail = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = findUserDataBase(mail: mail)
        
        if user == nil {
            loginLabel.text = "Пользователь не найден!"
            loginLabel.textColor = .red
        } else if user?.password == password { //проверяем пароль и переходим на следующий конроллер
            let navVC = UINavigationController(rootViewController: AlbumsViewController())
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            
            guard let activeUser = user else { return }
            DataBase.shared.saveActiveUser(user: activeUser) //сохраняем зарегистрированного пользователя
        } else {
            alertOk(title: "Ошибка!", message: "Неверный пароль. Попробуйте ещё раз.")
        }
    }
    
    private func findUserDataBase(mail: String) -> User? { //находм пользователя в БД
        
        let dataBase = DataBase.shared.users
        print(dataBase)
        
        for user in dataBase { //проверяем наличие пользователя по почте
            if user.email == mail {
                return user
            }
        }
        return nil
    }
    
    //создаем переменные для стэк вью
    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegate()
        setConstraint()
        registerKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //убираем клавиатуру по нажатию return в TF
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

// MARK: - UIStackView
//настройка stack view для более понятного отображения кода в классе
extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension AuthViewController {
    private func registerKeyboardNotification() { //регистрируем обсервер для отслеживания клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWllShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWllHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() { //удаляем обсерверы после deinit viewController
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWllShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue //получаем высоту клавиатуры
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2) //поднимаем scrollView на половину высоты клавиатуры
    }
    
    @objc private func keyboardWllHide(notification: Notification) { //возвращаем в стандартное положение
        scrollView.contentOffset = CGPoint.zero
    }
}

// MARK: - AuthViewController Constraints
extension AuthViewController {
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            textFieldsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textFieldsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            textFieldsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            buttonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
    }
}
