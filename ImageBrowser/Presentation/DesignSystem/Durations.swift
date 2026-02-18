//
//  Durations.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 18/02/2026.
//

import Foundation

extension RunLoop.SchedulerTimeType.Stride {

#if !TESTING
    static let textInputDebounce: Self = .milliseconds(500)
#else
    static let textInputDebounce: Self = 0
#endif

}
