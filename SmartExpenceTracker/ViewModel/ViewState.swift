//
//  TopTabBar.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/16/24.
//

import Foundation
import SwiftUI

@Observable
class ViewState {
//    var stack = NavigationPath()//
    var stack: [String] = []
    var topTabBarExist = true
}
