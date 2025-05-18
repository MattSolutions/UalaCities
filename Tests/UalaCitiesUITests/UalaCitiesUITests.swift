//
//  UalaCitiesUITests.swift
//  UalaCitiesUITests
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import XCTest

final class UalaCitiesUITests: XCTestCase {
    
    func testAppLaunchesSuccessfully() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
        
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Main Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
