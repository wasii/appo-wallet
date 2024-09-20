//
//  Coordinator.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import SwiftUI
import Combine
import PDFKit

protocol Transferable {}

protocol Mockable {
    static var mock: Self { get }
}

extension Array: Transferable where Element: Transferable { }

struct EmptyTransferable: Transferable {}

extension String: Transferable {}
extension Int: Transferable {}
extension Bool: Transferable {}
extension Decimal: Transferable {}
extension PDFDocument: Transferable {}

struct CoordinatorState<T> {
    let state: T
    let transferable: Transferable?

    static func with(_ state: T, _ transferable: Transferable? = nil) -> Self {
        .init(state: state, transferable: transferable)
    }

    var optional: CoordinatorState<T?> {
        .init(state: state, transferable: transferable)
    }
}
