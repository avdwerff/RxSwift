//
//  Dependencies.swift
//  WikipediaImageSearch
//
//  Created by carlos on 13/5/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
#endif

class Dependencies {
    
    static let sharedDependencies = Dependencies() // Singleton
    
    let URLSession = NSURLSession.sharedSession()
    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler
    #if !os(tvOS)
    let wireframe: Wireframe
    #endif
    private init() {
        #if !os(tvOS)
        wireframe = DefaultWireframe()
        #endif
        
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        #if !RX_NO_MODULE
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        #endif
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        
        mainScheduler = MainScheduler.sharedInstance
    }
    
}
