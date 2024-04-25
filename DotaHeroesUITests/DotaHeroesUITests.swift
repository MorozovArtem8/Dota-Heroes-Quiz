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
        sleep(1)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Universal"].tap()
        sleep(1)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testStrengthButton() {
        sleep(1)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Strength"].tap()
        sleep(1)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testAgilityButton() {
        sleep(1)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Agility"].tap()
        sleep(1)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testIntellectButton() {
        sleep(1)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Intellect"].tap()
        sleep(1)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testResultAlert() {
        sleep(1)
        for _ in 1...10 {
            app.buttons["Intellect"].tap()
            sleep(1)
        }
        
        let alert = app.alerts["Alert"]
        XCTAssertTrue(alert.exists)
        
        let alertTitle = alert.label
        let alertButtonText = alert.buttons.firstMatch.label
        
        XCTAssertEqual(alertTitle, "Этот раунд окончен!")
        XCTAssertEqual(alertButtonText, "Сыграть еще раз")
        
    }
    
    func testAlertDismiss() {
        sleep(1)
        for _ in 1...10 {
            app.buttons["Intellect"].tap()
            sleep(1)
        }
        
        let alert = app.alerts["Alert"]
        XCTAssertTrue(alert.exists)
        alert.buttons.firstMatch.tap()
        sleep(1)
        
        let textField = app.staticTexts["CurrentQuestionTextField"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(textField.label, "1/10")
        
    }
    
    func testIndexLabelChange() {
        sleep(1)
        let firstTextField = app.staticTexts["CurrentQuestionTextField"]
        XCTAssertEqual(firstTextField.label, "1/10")
        app.buttons["Intellect"].tap()
        sleep(1)
        let secondTextField = app.staticTexts["CurrentQuestionTextField"]
        XCTAssertEqual(secondTextField.label, "2/10")
    }
}
