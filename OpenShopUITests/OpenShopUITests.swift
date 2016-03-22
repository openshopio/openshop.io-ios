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
        let countryButton = app.buttons["Country"]
        sleep(1)
        if (countryButton.exists) {
            countryButton.tap()
            app.toolbars.buttons["Done"].tap()
            app.buttons["CONTINUE"].tap()
        }

        // Email/FB login screen
        let emailButton = app.buttons["EMAIL"]
        sleep(1)
        if (emailButton.exists) {
            snapshot("Login")
            
            emailButton.tap()
            let eMailTextField = app.textFields["E-mail"]
            eMailTextField.tap()
            eMailTextField.typeText(loginEmail)
            let passwordSecureTextField = app.secureTextFields["Password"]
            passwordSecureTextField.tap()
            passwordSecureTextField.typeText(loginPassword)
            app.buttons["P\u{0158}IHL\u{00c1}SIT SE"].tap()
        }
        
        // Banners screen
        let firstBanner = app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0)
        expectationForPredicate(existsPredicate, evaluatedWithObject: firstBanner, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        snapshot("Banners")
        firstBanner.tap()

        // Products screen
        let firstProduct = app.cells.elementBoundByIndex(0)
        expectationForPredicate(existsPredicate, evaluatedWithObject: firstProduct, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        snapshot("Products")
        firstProduct.tap()
        
        // Add product to the cart
        let addToCartButton = app.tables.buttons["P\u{0158}IDAT DO KO\u{0160}\u{00cd}KU"]
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
        cartTabBar.tap()
        cartTabBar.tap()
        
        sleep(10)
        snapshot("Cart")
    }
}
