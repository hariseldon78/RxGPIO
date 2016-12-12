import XCTest
import RxGPIO
import Foundation
import RxSwift
import SwiftyGPIO
import Glibc

let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi2)
let led0:GPIO=gpios[.P2]!
let led1:GPIO=gpios[.P3]!
let btn0:GPIO=gpios[.P4]!

class RxGPIOTests: XCTestCase {
	func invert(pin:GPIO){
		let b=Bool(pin.value)
		pin.value = Int(!b)
	}
	
	let setup:Bool={
		[led0,led1].forEach {
			$0.direction = .OUT
		}
		[btn0].forEach {
			$0.direction = .IN
		}
		print("gpios ok")
		return true
	}()
	
//	func app() {
//		Observable<Int>.interval(0.5, scheduler:ThreadScheduler())
//			.subscribe (onNext:{_ in
//				//			print("this is in a background thread")
//				invert(pin:led0)
//			}).addDisposableTo(🗑)
//		
//		Observable<Int>.interval(0.1, scheduler:MainScheduler.instance)
//			.subscribe (onNext:{_ in
//				//			print("this is in the main thread")
//				invert(pin:led1)
//			}).addDisposableTo(🗑)
//		
//		button(pin:btn0)
//			.subscribe (onNext:{
//			print($0)
//		}).addDisposableTo(🗑)
//		
//	}
	func testLedBlink() {
		print("this should blink the led0 2 times")
		for _ in 0..<2 {
			led0.value=Int(false)
			sleep(1)
			led0.value=Int(true)
			sleep(1)
		}
	}
	
	func testMainScheduler() {
		var counter=0
		if true {
			let 🗑=DisposeBag()
			Observable<Int>.interval(0.1, scheduler:MainScheduler.instance)
				.subscribe (onNext:{_ in
					counter+=1
				}).addDisposableTo(🗑)
			RunLoop.current.run(until:Date(timeIntervalSinceNow: 1.05))
		}
		XCTAssertEqual(counter, 10)

	}

    static var allTests : [(String, (RxGPIOTests) -> () throws -> Void)] {
        return [
            ("testLedBlink", 		testLedBlink),
            ("testMainScheduler", 	testMainScheduler)
        ]
    }
}
