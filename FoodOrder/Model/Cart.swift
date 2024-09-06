//
//  Cart.swift
//  FoodOrder
//
//  Created by Esma Koçak on 6.09.2024.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
