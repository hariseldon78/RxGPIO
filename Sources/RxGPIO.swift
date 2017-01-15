import RxSwift
import SwiftyGPIO
import Foundation
import Regex

public func button(pin:GPIO,maxLatency:TimeInterval=0.1,scheduler:SchedulerType=ThreadScheduler()) -> Observable<Bool>
{
	assert(pin.direction == .IN)
	return Observable<Int>
		.interval(maxLatency, scheduler:scheduler)
		.map {_ in pin.boolValue }
		.distinctUntilChanged()
}

public typealias Centimeters=Double
public func ultrasonic(trigger:GPIO,echo:GPIO,interval:TimeInterval=1.0, scheduler:SchedulerType=ThreadScheduler())->Observable<Centimeters>
{
	assert(trigger.direction == .OUT)
	assert(echo.direction == .IN)
	return Observable<Int>
		.interval(interval,scheduler:scheduler)
		.map {_ in
			// source=http://www.raspberrypi-spy.co.uk/archive/python/ultrasonic_1.py
			trigger.boolValue=false
			// Allow module to settle
			usleep(500000)
			// Send 10us pulse to trigger
			trigger.boolValue=true
			usleep(10)
			trigger.boolValue=false
			
			var start=Date()

			while echo.boolValue==false {
				start=Date()
			}

			var stop=Date()
			while echo.boolValue==true {
				stop=Date()
			}

			// Calculate pulse length
			var elapsed=stop.timeIntervalSince(start)
			print("elapsed:\(elapsed)")
			// Distance pulse travelled in that time is time
			// multiplied by the speed of sound (cm/s)
			// That was the distance there and back so halve the value
			return elapsed * 34300.0 / 2.0
	}
}

enum RxGPIOErrors: Error {
	case servoBlasterNotFound
	case servoBlasterNoPinsConfigured
}

public func servoblasterPins() throws -> [Int]
{
	guard let cfg=FileHandle(forReadingAtPath: "/dev/servoblaster-cfg") else {throw RxGPIOErrors.servoBlasterNotFound }
	defer {cfg.closeFile()}
	let data=cfg.readDataToEndOfFile()
	//		p1pins=7,11,12,13,15,16,18,22
	if let content=String(data: data, encoding: .utf8),
		let p1pins="p1pins=((?:\\d+,?)*)".r?
			.findFirst(in:content)?
			.group(at:1)?
			.split(using:",".r)
			.map ({Int($0)!})
	{
		return p1pins
	} else {
		throw RxGPIOErrors.servoBlasterNoPinsConfigured
	}
}
