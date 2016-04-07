//
//  OpenShopUITests.swift
//  OpenShopUITests
//
//  Created by Petr Škorňok on 02.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

import XCTest

class OpenShopUITests: XCTestCase {
    
    let loginEmail = "a@q.cz";
    let loginPassword = "aa";

    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshots() {
        XCUIDevice.sharedDevice().orientation = .Portrait
        let app = XCUIApplication()
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        // Initial start with country screen
        sleep(1)
//        let continueButton = app.buttons["CONTINUE"]
//        if (XCUIApplication().buttons["CONTINUE"].exists) {
            XCUIApplication().buttons["CONTINUE"].tap()
//        }

        // Email/FB login screen
        sleep(1)
//        let emailButton = app.buttons["EMAIL"]
        
//        XCUIApplication().buttons["EMAIL"].tap()
        
        if (XCUIApplication().buttons["EMAIL"].exists) {
            snapshot("Login")
        
            XCUIApplication().buttons["EMAIL"].tap()
            let eMailTextField = app.textFields["E-mail"]
            eMailTextField.tap()
            eMailTextField.typeText(loginEmail)
            let passwordSecureTextField = app.secureTextFields["Password"]
            passwordSecureTextField.tap()
            passwordSecureTextField.typeText(loginPassword)
            app.buttons["LOGIN"].tap()
        }
        
        // Banners screen
        let firstBanner = app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0)
        expectationForPredicate(existsPredicate, evaluatedWithObject: firstBanner, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        // dismiss APNS alert
        firstBanner.forceTapElement()
        snapshot("Banners")
        firstBanner.tap()

        // Products screen
        let firstProduct = app.cells.elementBoundByIndex(0)
        expectationForPredicate(existsPredicate, evaluatedWithObject: firstProduct, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        snapshot("Products")
        firstProduct.tap()
        
        // Add product to the cart
        let addToCartButton = app.tables.buttons["ADDTOCART"]
        expectationForPredicate(existsPredicate, evaluatedWithObject: addToCartButton, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        snapshot("Product Detail")
        addToCartButton.tap()
        sleep(2) // sleep for a while to give some time to the request
        
        // Cart screen
        let cartTabBar = app.tabBars.buttons["Cart"]
        let cartTabBarHittable = NSPredicate(format: "hittable == 1")
        expectationForPredicate(cartTabBarHittable, evaluatedWithObject: cartTabBar, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        cartTabBar.forceTapElement()
        cartTabBar.forceTapElement()
        
        sleep(5)
        snapshot("Cart")
    }
}
