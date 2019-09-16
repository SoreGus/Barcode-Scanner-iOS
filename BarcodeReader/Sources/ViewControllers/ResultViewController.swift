//
//  ResultViewController.swift
//  BarcodeReader
//
//  Created by Gustavo Luís Soré on 15/09/19.
//  Copyright © 2019 Sore. All rights reserved.
//

import UIKit

typealias ResultViewControllerCompletion = () -> Void

class ResultViewController: UIViewController {
    
    // MARK: Constants
    
    static let kIdentifier: String = "ResultViewController"
    
    // MARK: Properties
    
    var resultString: String = ""
    var completion: ResultViewControllerCompletion?
    
    // MARK: Outlets
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var reinitButton: UIButton!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1, y: 0.5)
        gradient.frame.size = reinitButton.frame.size
        gradient.colors = [UIColor.blueFirst.cgColor,UIColor.blueSecond.cgColor]
        reinitButton.backgroundColor = .clear
        reinitButton.layer.addSublayer(gradient)
        
        reinitButton.layer.cornerRadius = reinitButton.frame.height / 2
        reinitButton.layer.masksToBounds = true
        
        resultLabel.text = resultString
        
    }
    
    // MARK: Actions
    
    @IBAction func reinitAction(_ sender: Any) {
        completion?()
        dismiss(animated: true, completion: nil)
    }
}
