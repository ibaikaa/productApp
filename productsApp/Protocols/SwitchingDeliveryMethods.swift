//
//  SwitchingDeliveryMethods.swift
//  productsApp
//
//  Created by ibaikaa on 26/1/23.
//

import UIKit

protocol SwitchingDeliveryMethods {
    func tryingUnchooseAllMethods(method: DeliveryMethod) -> Bool
    func switchDeliveryMethods(newMethod: DeliveryMethod)
}
