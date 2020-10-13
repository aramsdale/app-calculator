//
//  ViewController.swift
//  app-calc
//
//  Created by Austin Ramsdale on 10/5/20.
//
//  DevSlopes Academy, Week 4 Project
//  Fundamentals used:
//     - Guards for cleaner logic tree
//     - Nested stack views for varying button sizes (vertical and horizontal)
//     - Resizes and orients for all current devices
//     - Responds to Light/Dark mode
//     - Display is interactive: Tap the display for conventional iOS keyboard + delete

import UIKit
@IBDesignable


class mainVC: UIViewController {
    @IBOutlet weak var equalBtn: ButtonWithShadow!
    @IBOutlet weak var addBtn: ButtonWithShadow!
    @IBOutlet weak var subtractBtn: ButtonWithShadow!
    @IBOutlet weak var multiplyBtn: ButtonWithShadow!
    @IBOutlet weak var divideBtn: ButtonWithShadow!
    @IBOutlet weak var plusnegativeBtn: ButtonWithShadow!
    @IBOutlet weak var clearBtn: ButtonWithShadow!
    @IBOutlet weak var decimalBtn: ButtonWithShadow!
    @IBOutlet weak var zeroBtn: ButtonWithShadow!
    @IBOutlet weak var oneBtn: ButtonWithShadow!
    @IBOutlet weak var twoBtn: ButtonWithShadow!
    @IBOutlet weak var threeBtn: ButtonWithShadow!
    @IBOutlet weak var fourBtn: ButtonWithShadow!
    @IBOutlet weak var fiveBtn: ButtonWithShadow!
    @IBOutlet weak var sixBtn: ButtonWithShadow!
    @IBOutlet weak var sevenBtn: ButtonWithShadow!
    @IBOutlet weak var eightBtn: ButtonWithShadow!
    @IBOutlet weak var nineBtn: ButtonWithShadow!
    @IBOutlet weak var txtDisplay: UITextField!
    @IBOutlet weak var lblAddFlag: UILabel!
    @IBOutlet weak var lblSubtractFlag: UILabel!
    @IBOutlet weak var lblDivideFlag: UILabel!
    @IBOutlet weak var lblMultiplyFlag: UILabel!
    @IBOutlet weak var lblMemoryFlag: UILabel!

    //Set LCD Display Colors for On/Off
    let textColorOff = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6)
    let textColorOn = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    //Flags used throughout the App
    struct calcFlags {
        var state: Int = 0 //0 = No pending actions, 1 = Value and operator entered, 2 = Calculation completed, displaying final value, No pending further action.
        var pendingValue: Double = 0.00 //temp storage
        var memoryStore: Double = 0.00 //Memory storage for user
        let generator = UIImpactFeedbackGenerator(style: .heavy)
    }
    public var flags = calcFlags()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps, dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //Start by clearing display
        clearAll()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //Button Logic
    @IBAction func buttonPress(_ sender: ButtonWithShadow) {
        flags.generator.impactOccurred()
        //Check for the button's title, and save to buttonTitle to be used in switch
        if let buttonTitle = sender.titleLabel?.text {
            switch(buttonTitle) {
            case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
                //If display is 0, and state is 0, erase zero and replace with first number
                //Alternate logic: if state == 2, then equals was used, final calculation was displayed, and calc is ready for start of next calculation. Erase result with new button press.
                if (txtDisplay.text == "0" &&  flags.state == 0) || flags.state == 2 {
                    txtDisplay.text = buttonTitle
                    //If state was 2, after first press, we need to reset state to 0
                    flags.state = 0
                } else if flags.state != 0{
                    //If state is 1, user has hit an operation, and we will replace current display with first number and set flag to 0
                    txtDisplay.text = buttonTitle
                    flags.state = 0
                } else {
                    //Flag is 0, so we can append next button press
                    txtDisplay.text = String(txtDisplay.text!) + buttonTitle
                }
                
            case ".":
                //If display is 0 and no current process, start with decimal
                if txtDisplay.text == "0" &&  flags.state == 0 {
                    txtDisplay.text = buttonTitle
                } else if flags.state != 0 {
                    //Calculation or final result in state - start with decimal and set flag state back to 0 to accept next character.
                    txtDisplay.text = buttonTitle
                    flags.state = 0
                } else {
                    //Check if there's already a decimal, if not, append
                    if txtDisplay.text!.count(of: ".") == 0 {
                        txtDisplay.text = String(txtDisplay.text!) + buttonTitle
                    }
                }
            case "C":
                clearAll()
                
            case "=":
                //If user hits equals and no calculation is selected, then return
                guard lblMultiplyFlag.textColor != textColorOff || lblDivideFlag.textColor != textColorOff || lblSubtractFlag.textColor != textColorOff || lblAddFlag.textColor != textColorOff else { return }
                //User hit a number, then operation, then equals? Will return the number entered and clear the operator display
                guard flags.state != 1 else {
                    changeDisplay(lbl: "off")
                    showPending()
                    return
                }
                //Multiply flag is selected
                guard lblMultiplyFlag.textColor != textColorOn else {
                    //Change operator display to off state
                    changeDisplay(lbl: "off")
                    //Perform the calculation, send to display, reset the pendingValue, and set the state as "Showing final calculation"
                    flags.pendingValue = flags.pendingValue * (Double(txtDisplay.text!) ?? 0)
                    showPending()
                    flags.pendingValue = 0
                    flags.state = 2
                    return
                }
                
                guard lblDivideFlag.textColor != textColorOn else {
                    changeDisplay(lbl: "off")
                    flags.pendingValue = Double(flags.pendingValue) / (Double(txtDisplay.text!) ?? 0)
                    showPending()
                    flags.pendingValue = 0
                    flags.state = 2
                    return
                }
                
                guard lblSubtractFlag.textColor != textColorOn else {
                    changeDisplay(lbl: "off")
                    flags.pendingValue = flags.pendingValue - (Double(txtDisplay.text!) ?? 0)
                    showPending()
                    flags.pendingValue = 0
                    flags.state = 2
                    return
                }
                
                guard lblAddFlag.textColor != textColorOn else {
                    changeDisplay(lbl: "off")
                    flags.pendingValue += (Double(txtDisplay.text!) ?? 0)
                    showPending()
                    flags.pendingValue = 0
                    flags.state = 2
                    return
                }
                
            case "+":
                flags.pendingValue += Double(txtDisplay.text!) ?? 00
                //Look for consecutive/chained operations
                if flags.state == 1 || lblAddFlag.textColor == textColorOn {
                    showPending()
                }
                //Set state to "Number + Operator entered"
                flags.state = 1
                //Update operator display for the addition sign
                changeDisplay(lbl: "+")
                
            case "-":
                if flags.state == 1 || lblSubtractFlag.textColor == textColorOn {
                    flags.pendingValue = flags.pendingValue - (Double(txtDisplay.text!) ?? 0)
                } else {
                    flags.pendingValue = Double(txtDisplay.text!) ?? 00
                }
                showPending()
                flags.state = 1
                changeDisplay(lbl: "-")
                
            case "÷":
                if flags.state == 1 || lblDivideFlag.textColor == textColorOn {
                    flags.pendingValue = Double(flags.pendingValue / (Double(txtDisplay.text!) ?? 0))
                } else {
                    flags.pendingValue = Double(txtDisplay.text!) ?? 00
                }
                showPending()
                flags.state = 1
                changeDisplay(lbl: "/")
                
            case "x":
                if flags.state == 1 || lblMultiplyFlag.textColor == textColorOn {
                    flags.pendingValue = Double(flags.pendingValue * (Double(txtDisplay.text!) ?? 0))
                } else {
                    flags.pendingValue = Double(txtDisplay.text!) ?? 00
                }
                showPending()
                flags.state = 1
                changeDisplay(lbl: "x")
                
            case "m+":
                //Place number in memoryStore, or add to existing memory storage
                flags.memoryStore += Double(txtDisplay.text!) ?? 00
                flags.pendingValue = flags.memoryStore
                showPending()
                //Activate memory LCD flag
                lblMemoryFlag.textColor = textColorOn
            case "m-":
                flags.memoryStore -= Double(txtDisplay.text!) ?? 00
                flags.pendingValue = flags.memoryStore
                showPending()
                lblMemoryFlag.textColor = textColorOn
            case "mr":
                //Recall memoryStore to display for use
                txtDisplay.text = String(flags.memoryStore)
            case "mc":
                //Clear the memoryStorage
                flags.memoryStore = 0
                lblMemoryFlag.textColor = textColorOff
            case "+/-":
                //Toggle a negative number
                flags.pendingValue = -1 * (Double(txtDisplay.text!) ?? 0)
                showPending()

            default:
                return
            }
            
        }
    }

    func clearAll() {
        //Clear display, reset flags and operations
        txtDisplay.text = "0"
        flags.pendingValue = 0
        changeDisplay(lbl: "off")
        flags.state = 0
        return
    }
    func showPending() {
        //If the value is an Integer, then don't show the decimal and precision on display
        if flags.pendingValue.rounded(.up) == flags.pendingValue.rounded(.down) {
            txtDisplay.text = String(Int(flags.pendingValue))
        } else {
            //Number needs precision, show Double
            txtDisplay.text = String(flags.pendingValue)
        }
    }
    func changeDisplay(lbl: String) {
        //Take passed string for switch to toggle the 4 operators on display
        switch(lbl) {
        case "+":
            lblAddFlag.textColor = textColorOn
            lblSubtractFlag.textColor = textColorOff
            lblDivideFlag.textColor = textColorOff
            lblMultiplyFlag.textColor = textColorOff
        case "-":
            lblAddFlag.textColor = textColorOff
            lblSubtractFlag.textColor = textColorOn
            lblDivideFlag.textColor = textColorOff
            lblMultiplyFlag.textColor = textColorOff
        case "/":
            lblAddFlag.textColor = textColorOff
            lblSubtractFlag.textColor = textColorOff
            lblDivideFlag.textColor = textColorOn
            lblMultiplyFlag.textColor = textColorOff
        case "x":
            lblAddFlag.textColor = textColorOff
            lblSubtractFlag.textColor = textColorOff
            lblDivideFlag.textColor = textColorOff
            lblMultiplyFlag.textColor = textColorOn
        default:
            lblAddFlag.textColor = textColorOff
            lblSubtractFlag.textColor = textColorOff
            lblDivideFlag.textColor = textColorOff
            lblMultiplyFlag.textColor = textColorOff
        }
    }
}

class ButtonWithShadow: UIButton {
    //Add some depth to the buttons
    override func prepareForInterfaceBuilder() {
        func draw(_ rect: CGRect) {
            updateLayerProperties()
        }
    }
    
    override func draw(_ rect: CGRect) {
            updateLayerProperties()
    }

    func updateLayerProperties() {
        self.layer.shadowColor = UIColor.secondaryLabel.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
}

extension String {
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
}
