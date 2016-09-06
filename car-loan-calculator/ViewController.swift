//
//  ViewController.swift
//  car-loan-calculator
//
//  Created by Adam Goth on 9/3/16.
//  Copyright © 2016 Adam Goth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var basicContainerView: UIView!
    @IBOutlet weak var advancedContainerView: UIView!
    @IBOutlet weak var principalAmountInput: UITextField!
    @IBOutlet weak var annualInterestInput: UITextField!
    @IBOutlet weak var monthsInput: UITextField!
    @IBOutlet weak var totalLoanAmountLbl: UILabel!
    @IBOutlet weak var monthlyPaymentLbl: UILabel!
    
    var principal: Double = 0.0
    var annualInterest: Double = 0.0
    var months: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        principalAmountInput.delegate = self
        annualInterestInput.delegate = self
        monthsInput.delegate = self
        
        principalAmountInput.text = "0"
        annualInterestInput.text = "0"
        monthsInput.text = "0"
        
        principalAmountInput.keyboardType = UIKeyboardType.NumberPad
        annualInterestInput.keyboardType = UIKeyboardType.NumberPad
        monthsInput.keyboardType = UIKeyboardType.NumberPad
        
        principalAmountInput.becomeFirstResponder()
    }
    
    func returnMonthlyPayment(principal: Double, annualInterest: Double, months: Double) -> Dictionary<String, Double> {
        var payment: Double = 0.0
        var totalLoan: Double = 0.0
        let monthlyInterest: Double = annualInterest/1200
        if annualInterest < 0 {
            print("Interest can not be negative")
        } else if annualInterest == 0 {
            if months == 0 {
                payment = principal
                totalLoan = principal
            } else {
                payment = principal/months
                totalLoan = payment*months
            }
        } else {
            if months == 0 {
                payment = principal
                totalLoan = principal
            } else {
                payment =  principal * (monthlyInterest * pow((1 + monthlyInterest), months)) / (pow((1 + monthlyInterest), months) - 1)
                totalLoan = payment*months
            }
            
        }
        
        print(payment)
        print(totalLoan)
        return ["payment": payment, "totalLoan": totalLoan]
    }
    
    func calcAndUpdate(principal: Double, annualInterest: Double, months: Double) {
        let calc = returnMonthlyPayment(principal, annualInterest: annualInterest, months: months)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        totalLoanAmountLbl.text = formatter.stringFromNumber(calc["totalLoan"]!)
        monthlyPaymentLbl.text = formatter.stringFromNumber(calc["payment"]!)
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            basicContainerView.hidden = false
            advancedContainerView.hidden = true
        case 1:
            basicContainerView.hidden = true
            advancedContainerView.hidden = false
        default:
            break
        }
    }
    
    @IBAction func principalAmountChanged(sender: AnyObject) {
        if let principalInput = Double(principalAmountInput.text!) {
            principal = principalInput
            calcAndUpdate(principal, annualInterest: annualInterest, months: months)
        }
    }
    
    @IBAction func annualInterestChanged(sender: AnyObject) {
        if let annualInterestInput = Double(annualInterestInput.text!) {
            annualInterest = annualInterestInput
            calcAndUpdate(principal, annualInterest: annualInterest, months: months)
        }
    }
    
    @IBAction func monthsChanged(sender: AnyObject) {
        if let monthsInput = Double(monthsInput.text!) {
            months = monthsInput
            calcAndUpdate(principal, annualInterest: annualInterest, months: months)
        }
    }

}

