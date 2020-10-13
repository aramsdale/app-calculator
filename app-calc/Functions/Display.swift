//
//  Display.swift
//  app-calc
//
//  Created by Austin Ramsdale on 10/9/20.
//

import Foundation
import UIKit

class displayFunctions {
    // Initialize Access to mainVC, routed through mainVCCall
    let mainVCCall = mainVC()
    
    // Initialize Default Display Colors - Change all here:
    let textColorOff = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6)
    let textColorOn = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let displayBG = UIColor(red: 167, green: 209, blue: 149, alpha: 1)
    func clearAll() {
        mainVCCall.txtDisplay?.text = "0"
        mainVCCall.pendingValue = 0
        mainVCCall.tempStore = 0
        mainVCCall.lblAddFlag?.textColor = textColorOff
        mainVCCall.lblSubtractFlag?.textColor = textColorOff
        mainVCCall.lblDivideFlag?.textColor = textColorOff
        mainVCCall.lblMultiplyFlag?.textColor = textColorOff
        //mainVCCall.flagStore = String(mainVCCall.flagStore[..<mainVCCall.flagStore.index(mainVCCall.flagStore.endIndex, offsetBy: -1)]) + "0"
        mainVCCall.flags.calculation = 0
        mainVCCall.flags.positive = 0
        mainVCCall.flags.pending = 0
        return
    }
}
