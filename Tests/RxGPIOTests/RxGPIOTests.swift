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

let ultrasonicTrigger:GPIO=gpios[.P27]!
let ultrasonicEcho:GPIO=gpios[.P22]!
//let ultrasonicOut:GPIO=gpios[.P17]!

class RxGPIOTests: XCTestCase {
	func invert(pin:GPIO){
		let b=Bool(pin.value)
		pin.value = Int(!b)
	}
	
	let setup:Bool={
		[led0,led1, ultrasonicTrigger].forEach {
			$0.direction = .OUT
		}
		[led0,led1, ultrasonicTrigger].forEach {
			assert($0.direction == .OUT)
		}

		[btn0, ultrasonicEcho].forEach {
			$0.direction = .IN
		}
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
			led0.boolValue=false
			led1.boolValue=true
			usleep(500000)
			led0.boolValue=true
			led1.boolValue=false
			usleep(500000)
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
	
	func testThreadScheduler() {
		var counter=0
		if true {
			let 🗑=DisposeBag()
			Observable<Int>.interval(0.1, scheduler:ThreadScheduler())
				.subscribe (onNext:{_ in
					counter+=1
				}).addDisposableTo(🗑)
			RunLoop.current.run(until:Date(timeIntervalSinceNow: 1.05))
		}
		XCTAssertEqual(counter, 10)
		
	}
	
	func testButton() {
		print("press and release the button, it should control the led0")
		let 🗑=DisposeBag()
		button(pin:btn0).subscribe(onNext:{
			pressed in
			led0.boolValue=pressed
		}).addDisposableTo(🗑)
		RunLoop.current.run(until:Date(timeIntervalSinceNow: 5.0))
	}
	func testServoblaster() {
		guard let pins=try? servoblasterPins() else {XCTFail();return}
		XCTAssert(!pins.isEmpty)
		print(pins)
	}
	func testUltrasonic() {
		print("position something at various distances in front of the ultrasonic sensor")
		let 🗑=DisposeBag()
		ultrasonic(trigger:ultrasonicTrigger,echo:ultrasonicEcho).subscribe(onNext:{
			distance in
			print("distance: \(distance)")
		}).addDisposableTo(🗑)
		RunLoop.current.run(until:Date(timeIntervalSinceNow: 10.0))
	}
	
    static var allTests : [(String, (RxGPIOTests) -> () throws -> Void)] {
        return [
			("testLedBlink", 			testLedBlink)
            , ("testMainScheduler", 	testMainScheduler)
			, ("testThreadScheduler", 	testThreadScheduler)
			, ("testServoblaster", 		testServoblaster)
			, ("testButton", 			testButton)
			, ("testUltrasonic", 		testUltrasonic)
			
       ]
    }
}
