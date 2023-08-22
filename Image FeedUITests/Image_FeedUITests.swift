import XCTest
import Image_Feed

class Image_FeedUITests: XCTestCase {
    private let fullName = ""
    private let userName = ""
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        // Given
        app.buttons["Войти"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        // When
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("Здесь должен быть логин ревьюера")
        app.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("Здесь должен быть пароль ревьюера")
        app.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        XCTAssertTrue(app.tables.cells.firstMatch.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        
        sleep(2)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy:1)
        
        cellToLike.buttons["like_button_off"].tap()
        cellToLike.buttons["like_button_off"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["Backward"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(fullName)"].exists)
        XCTAssertTrue(app.staticTexts["\(userName)"].exists)
        
        app.buttons["ipad.and.arrow.forward"].tap()
        
        app.alerts.scrollViews.otherElements.buttons["Да"].tap()
    }
}
