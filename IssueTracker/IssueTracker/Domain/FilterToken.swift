//
//  FilterToken.swift
//  IssueTracker
//
//  Created by 김미래 on 10/3/24.
//

import Foundation

struct FilterToken<T> {
    let title: String
    let description: String
    let icon: String
    let conditon: (T) -> Bool

    init(title: String, description: String, icon: String, conditon: @escaping (T) -> Bool) {
        self.title = title
        self.description = description
        self.icon = icon
        self.conditon = conditon
    }
}
