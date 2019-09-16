//
//  ViewControllerFactory.swift
//  BarcodeReader
//
//  Created by Gustavo Luís Soré on 15/09/19.
//  Copyright © 2019 Sore. All rights reserved.
//

import UIKit

class ViewControllerFactory {
    
    // MARK: Constants
    
    fileprivate static let kStoryboardName: String = "Main"
    fileprivate static let mainStoryBoard: UIStoryboard = UIStoryboard(name: kStoryboardName, bundle: .main)
    
    // MARK: Methods
    
    static func resultViewController(resultString: String) -> ResultViewController {
        let resultViewController: ResultViewController = mainStoryBoard.instantiateViewController(identifier:
            ResultViewController.kIdentifier)
        resultViewController.resultString = resultString
        return resultViewController
    }
}
