//
//  XCUIElement+ForceTap.swift
//  OpenShop
//
//  Created by Petr Škorňok on 03.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

import XCTest

/*Sends a tap event to a hittable/unhittable element.*/
extension XCUIElement {
    func forceTapElement() {
        if self.hittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinateWithNormalizedOffset(CGVectorMake(0.0, 0.0))
            coordinate.tap()
        }
    }
}