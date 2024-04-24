//
//  DotaHeroesUITests.swift
//  DotaHeroesUITests
//
//  Created by Artem Morozov on 24.04.2024.
//

import XCTest

final class DotaHeroesUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testUniversalButton() {
        sleep(2)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Universal"].tap()
        sleep(2)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }

   
}
