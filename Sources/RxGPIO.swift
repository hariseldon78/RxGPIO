import RxSwift
import SwiftyGPIO
import Foundation
import Regex

public func button(pin:GPIO,maxLatency:TimeInterval=0.1,scheduler:SchedulerType=ThreadScheduler()) -> Observable<Bool>
{
	return Observable<Int>
		.interval(maxLatency, scheduler:scheduler)
		.map {_ in Bool(pin.value) }
		.distinctUntilChanged()
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
