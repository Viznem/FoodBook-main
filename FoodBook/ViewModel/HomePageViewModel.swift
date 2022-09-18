//
//  AppViewModel.swift
//  FoodBook
//
//  Created by Khang Nguyen on 18/09/2022.
//

import SwiftUI

class HomePageViewModel: ObservableObject{
    @Published var currentFilter: String = "All"
}

