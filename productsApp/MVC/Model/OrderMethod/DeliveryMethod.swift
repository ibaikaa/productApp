//
//  OrderMethod.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.

import Foundation

public struct DeliveryMethod {
    public let name: String
    public let iconName: String
    public var isCurrentMethod: Bool
}

public struct DeliveryMethodGroup {
    public var deliveryMethods: [DeliveryMethod]
}

extension DeliveryMethodGroup {
    //Функция, позволяющая получить массив из методов доставки
    public static func deliveryMethods() -> DeliveryMethodGroup {
        //Собираем массив методов доставки
        let methods: [DeliveryMethod] = [
            .init(name: "Courier", iconName: "bicycle", isCurrentMethod: true),
            .init(name: "Pickup", iconName: "box.truck.fill", isCurrentMethod: false),
            .init(name: "Shipping", iconName: "shippingbox.fill", isCurrentMethod: false),
            .init(name: "Taxi", iconName: "car.fill", isCurrentMethod: false),
            .init(name: "Air Delivery", iconName: "airplane", isCurrentMethod: false)
        ]
        
        return DeliveryMethodGroup(deliveryMethods: methods)
    }
}
