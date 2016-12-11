import RxSwift
import SwiftyGPIO
import Foundation

public func button(pin:GPIO,maxLatency:TimeInterval=0.1,scheduler:SchedulerType=ThreadScheduler()) -> Observable<Bool>
{
	return Observable<Int>
		.interval(maxLatency, scheduler:scheduler)
		.map {_ in Bool(pin.value) }
		.distinctUntilChanged()
}

