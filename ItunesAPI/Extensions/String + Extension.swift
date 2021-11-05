//
//  String + Extension.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 05.11.2021.
//

import Foundation

extension String {
    
    enum ValidTypes { //для проверки имени/фамилии
        case name
        case email
        case password
    }
     
    enum Regex: String { //регулярные выражения
        case name = "[а-яА-Я]{1,}" //образец [указываем разрешенные символы] {указываем min, max длину}
        case email = "[a-zA-Z0-9._]+@[a-zA-Z]+\\.[a-zA-Z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}" //?=.* - обязательные символы
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@" //формат перидката
        var regex = ""
        
        switch validType { //проверяем корректность
        case .name: regex = Regex.name.rawValue
        case .email: regex = Regex.email.rawValue
        case .password: regex = Regex.password.rawValue
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self) //cоответствие string и выражение
    }
}
