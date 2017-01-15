//
//  extensions.swift
//  leds
//
//  Created by Roberto Previdi on 22/11/16.
//
//

import Foundation
import SwiftyGPIO

public extension Bool {
	init(_ i:Int){
		if i==0 {
			self=false
		} else {
			self=true
		}
	}
}

public extension Int {
	init(_ b:Bool){
		if b {
			self=1
		} else {
			self=0
		}
	}
}

public extension GPIO {

	public var boolValue: Bool {
		set(val) {
			value=Int(val)
		}
		get {
			return Bool(value)
		}
	}
}
