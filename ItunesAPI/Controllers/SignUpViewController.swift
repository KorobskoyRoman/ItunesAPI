//
//  SignUpViewController.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 02.11.2021.
//

import UIKit

class SignUpViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Имя"
        return textField
    }()
    
    private let firstNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = "* Обязательное поле"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Фамилия"
        return textField
    }()
    
    private let secondNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = "* Обязательное поле"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageValidLabel: UILabel = {
        let label = UILabel()
        label.text = "* Обязательное поле"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Телефон"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let phoneValidLabel: UILabel = {
        let label = UILabel()
        label.text = "* Обязательное поле"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "E-mail"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let emailValidLabel: UILabel = {
        let label = UILabel()
        label.text = "* Обязательное поле"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Пароль"
        return textField
    }()
    
    private let passwordValidLabel: UILabel = {
        let label = UILabel()
        label.text = "* Обязательное поле"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var elementsStackView = UIStackView()
    private var datePicker = UIDatePicker()
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setupDelegate()
        setupDatePicker()
        registerKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupViews() {
        title = "Sign Up"
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        
        //добавляем элементы в стэк
        elementsStackView = UIStackView(arrangedSubviews: [firstNameTextField,
                                                            firstNameValidLabel,
                                                            secondNameTextField,
                                                            secondNameValidLabel,
                                                            datePicker,
                                                            ageValidLabel,
                                                            phoneNumberTextField,
                                                            phoneValidLabel,
                                                            emailTextField,
                                                            emailValidLabel,
                                                            passwordTextField,
                                                            passwordValidLabel],
                                        axis: .vertical,
                                        spacing: 10,
                                        distribution: .fillProportionally)
        
        backgroundView.addSubview(elementsStackView)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(signUpButton)
    }
    
    private func setupDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        datePicker.layer.borderWidth = 1
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 6
        datePicker.tintColor = .black
    }
    
    @objc private func signUpButtonTapped() {
        
        let firstNameText = firstNameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneNumberTextField.text ?? ""
        
        //проверяем корректность заполненных данных для регистрации
        if firstNameText.isValid(validType: nameValidType)
            && secondNameText.isValid(validType: nameValidType)
            && emailText.isValid(validType: emailValidType)
            && passwordText.isValid(validType: passwordValidType)
            && phoneText.count == 18
            && ageIsValid() == true {
            
            DataBase.shared.saveUser(firstName: firstNameText,
                                     secondName: secondNameText,
                                     phone: phoneText,
                                     email: emailText,
                                     password: passwordText,
                                     age: datePicker.date)
            loginLabel.text = "Регистрация завершена! Можете войти в систему."
        } else {
            loginLabel.text = "Регистрация"
            alertOk(title: "Ошибка!", message: "Необходимо заполнить все поля!")
        }
    }
    
    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) { //проверяем на корректность поля
        
        let text = (textField.text ?? "") + string //прибавляем к тексту оператор string
        let result: String
        
        if range.length == 1 { //если метод == 1 - символы удаляются
            let end = text.index(text.startIndex, offsetBy: text.count - 1) //конечное значение текста при удалении 1 позиции range.length
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        textField.text = result //применяем текст к полю текст
        
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            label.text = wrongMessage
            label.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        
    }
    
    private func setPhoneNumberMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String{
        
        let text = textField.text ?? ""
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex //для замены символов
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        
        if result.count == 18 { //кол-во всех символов включая пробелы и тд
            phoneValidLabel.text = "Телефон корректный"
            phoneValidLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            phoneValidLabel.text = "Телефон некорректен, необходимо заполнить все символы"
            phoneValidLabel.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        
        return result
    }
    
    private func ageIsValid() -> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date
        
        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        let ageYear = age.year
        
        guard let ageUser = ageYear else {return false}
        
        return (ageUser < 18 ? false : true) //если возраст < 18 = false, else = true
    }
}

//MARK: - TextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField: setTextField(textField: firstNameTextField,
                                              label: firstNameValidLabel,
                                              validType: nameValidType,
                                              validMessage: "Имя корректно",
                                              wrongMessage: "Разрешены только русские символы. Минимум 1.",
                                              string: string,
                                              range: range)
            
        case secondNameTextField: setTextField(textField: secondNameTextField,
                                              label: secondNameValidLabel,
                                              validType: nameValidType,
                                              validMessage: "Имя корректно",
                                              wrongMessage: "Разрешены только русские символы. Минимум 1.",
                                              string: string,
                                              range: range)
            
        case emailTextField: setTextField(textField: emailTextField,
                                              label: emailValidLabel,
                                              validType: emailValidType,
                                              validMessage: "Почта корректна",
                                              wrongMessage: "Почта некорректна",
                                              string: string,
                                              range: range)
            
        case passwordTextField: setTextField(textField: passwordTextField,
                                              label: passwordValidLabel,
                                              validType: passwordValidType,
                                              validMessage: "Доступный пароль",
                                              wrongMessage: "Пароль некорректен, необходимые символы 1 большая буква, 1 малая буква и цифра. Минимум 6 символов",
                                              string: string,
                                              range: range)
            
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumberMask(textField: phoneNumberTextField,
                                                                                  mask: "+X (XXX) XXX-XX-XX",
                                                                                  string: string,
                                                                                  range: range)
            
        default:
            break
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //скрываем клавиатуру
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Keyboard
extension SignUpViewController {
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

extension SignUpViewController {
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            elementsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            elementsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            elementsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            elementsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
