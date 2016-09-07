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
    @IBOutlet weak var advancedContainerView: UIScrollView!
    //basic outlets
    @IBOutlet weak var principalAmountInput: UITextField!
    @IBOutlet weak var annualInterestInput: UITextField!
    @IBOutlet weak var monthsInput: UITextField!
    @IBOutlet weak var totalLoanAmountLbl: UILabel!
    @IBOutlet weak var monthlyPaymentLbl: UILabel!
    //advanced outlets
    @IBOutlet weak var carPriceInput: UITextField!
    @IBOutlet weak var tradeInInput: UITextField!
    @IBOutlet weak var payoffAmountInput: UITextField!
    @IBOutlet weak var downPaymentInput: UITextField!
    @IBOutlet weak var taxRateInput: UITextField!
    @IBOutlet weak var annualInterestInputAdv: UITextField!
    @IBOutlet weak var monthsInputAdv: UITextField!
    @IBOutlet weak var totalLoanAmountLblAdv: UILabel!
    @IBOutlet weak var monthlyPaymentLblAdv: UILabel!
    
    //basic properties
    var principal: Double = 0.0
    var annualInterest: Double = 0.0
    var months: Double = 0.0
    
    //advanced properties
    var carPrice: Double = 0.0
    var tradeIn: Double = 0.0
    var payoffAmount: Double = 0.0
    var downPayment: Double = 0.0
    var taxRate: Double = 0.0
    var annualInterestAdv: Double = 0.0
    var monthsAdv: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize basic view
        principalAmountInput.delegate = self
        annualInterestInput.delegate = self
        monthsInput.delegate = self
        
        principalAmountInput.text = "0"
        annualInterestInput.text = "0"
        monthsInput.text = "0"
        
        principalAmountInput.keyboardType = UIKeyboardType.DecimalPad
        annualInterestInput.keyboardType = UIKeyboardType.DecimalPad
        monthsInput.keyboardType = UIKeyboardType.DecimalPad
        
        principalAmountInput.becomeFirstResponder()
        
        //initialize advanced view
        carPriceInput.delegate = self
        tradeInInput.delegate = self
        payoffAmountInput.delegate = self
        downPaymentInput.delegate = self
        taxRateInput.delegate = self
        annualInterestInputAdv.delegate = self
        monthsInputAdv.delegate = self
        
        carPriceInput.text = "0"
        tradeInInput.text = "0"
        payoffAmountInput.text = "0"
        downPaymentInput.text = "0"
        taxRateInput.text = "0"
        annualInterestInputAdv.text = "0"
        monthsInputAdv.text = "0"
        
        carPriceInput.keyboardType = UIKeyboardType.DecimalPad
        tradeInInput.keyboardType = UIKeyboardType.DecimalPad
        payoffAmountInput.keyboardType = UIKeyboardType.DecimalPad
        downPaymentInput.keyboardType = UIKeyboardType.DecimalPad
        taxRateInput.keyboardType = UIKeyboardType.DecimalPad
        annualInterestInputAdv.keyboardType = UIKeyboardType.DecimalPad
        monthsInputAdv.keyboardType = UIKeyboardType.DecimalPad
        
        advancedContainerView.contentSize = CGSizeMake(0, 520)
    }
    
    func calcPrincipal(carPrice: Double, tradeIn: Double, payoffAmount: Double, downPayment: Double, taxRate: Double) -> Double {
        if taxRate > 0 {
            return ((carPrice - tradeIn)*(1+(taxRate/100))) - downPayment + payoffAmount
        } else {
            return carPrice - tradeIn - downPayment + payoffAmount
        }
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
        
        return ["payment": payment, "totalLoan": totalLoan]
    }
    
    func calcAndUpdate(principal: Double, annualInterest: Double, months: Double, basic: Bool) {
        let calc = returnMonthlyPayment(principal, annualInterest: annualInterest, months: months)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        if basic {
            totalLoanAmountLbl.text = formatter.stringFromNumber(calc["totalLoan"]!)
            monthlyPaymentLbl.text = formatter.stringFromNumber(calc["payment"]!)
        } else {
            totalLoanAmountLblAdv.text = formatter.stringFromNumber(calc["totalLoan"]!)
            monthlyPaymentLblAdv.text = formatter.stringFromNumber(calc["payment"]!)
        }
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            basicContainerView.hidden = false
            advancedContainerView.hidden = true
            principalAmountInput.becomeFirstResponder()
        case 1:
            basicContainerView.hidden = true
            advancedContainerView.hidden = false
            carPriceInput.becomeFirstResponder()
        default:
            break
        }
    }
    
    //basic actions
    @IBAction func principalAmountChanged(sender: AnyObject) {
        if let principalInput = Double(principalAmountInput.text!) {
            principal = principalInput
            calcAndUpdate(principal, annualInterest: annualInterest, months: months, basic: true)
        }
    }
    
    @IBAction func annualInterestChanged(sender: AnyObject) {
        if let annualInterestInput = Double(annualInterestInput.text!) {
            annualInterest = annualInterestInput
            calcAndUpdate(principal, annualInterest: annualInterest, months: months, basic: true)
        }
    }
    
    @IBAction func monthsChanged(sender: AnyObject) {
        if let monthsInput = Double(monthsInput.text!) {
            months = monthsInput
            calcAndUpdate(principal, annualInterest: annualInterest, months: months, basic: true)
        }
    }
    
    //advanced actions
    @IBAction func carPriceChanged(sender: AnyObject) {
        if let carPriceInput = Double(carPriceInput.text!) {
            carPrice = carPriceInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount, downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }
    
    @IBAction func tradeInChanged(sender: AnyObject) {
        if let tradeInInput = Double(tradeInInput.text!) {
            tradeIn = tradeInInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount,  downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }
    
    @IBAction func payoffAmountChanged(sender: AnyObject) {
        if let payoffAmountInput = Double(payoffAmountInput.text!) {
            payoffAmount = payoffAmountInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount, downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }
    
    @IBAction func downPaymentChanged(sender: AnyObject) {
        if let downPaymentInput = Double(downPaymentInput.text!) {
            downPayment = downPaymentInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount, downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }
    
    @IBAction func taxRateChanged(sender: AnyObject) {
        if let taxRateInput = Double(taxRateInput.text!) {
            taxRate = taxRateInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount, downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }
    
    @IBAction func annualPercentageAdvChanged(sender: AnyObject) {
        if let annualInterestAdvInput = Double(annualInterestInputAdv.text!) {
            annualInterestAdv = annualInterestAdvInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount, downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }
    
    @IBAction func monthsAdvChanged(sender: AnyObject) {
        if let monthsAdvInput = Double(monthsInputAdv.text!) {
            monthsAdv = monthsAdvInput
            let principal = calcPrincipal(carPrice, tradeIn: tradeIn, payoffAmount: payoffAmount, downPayment: downPayment, taxRate: taxRate)
            calcAndUpdate(principal, annualInterest: annualInterestAdv, months: monthsAdv, basic: false)
        }
    }

}

