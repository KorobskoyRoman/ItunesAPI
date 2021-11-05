//
//  ExtensionViewController.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 03.11.2021.
//

import UIKit

extension UIViewController {

    func createCustomButton(selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.fill"),for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }

}
