//
//  TicketKind.swift
//  ClangNotifications
//
//  Created by Jeffrey Snijder on 30/09/2021.
//  Copyright © 2021 Worth Internet Systems. All rights reserved.
//

import Foundation

public enum TicketKind {
    // A standard Ticket message.
    ///
    /// - Note: The font used for this message will be the value of the
    /// `messageLabelFont` property in the `MessagesCollectionViewFlowLayout` object.
    ///
    /// Using `MessageKind.attributedText(NSAttributedString)` doesn't require you
    /// to set this property and results in higher performance.
    case text(String)
    
    /// A message with attributed text.
    case attributedText(NSAttributedString)
    
    /// A photo message.
    case photo(MediaItem)

    /// A video message.
    case video(MediaItem)

    /// A location message.
   // case location(LocationItem)

    /// An emoji message.
    case emoji(String)

    /// A custom message.
    /// - Note: Using this case requires that you override the following methods and handle this case:
    ///   - `collectionView(_:cellForItemAt indexPath: IndexPath) -> UICollectionViewCell`
    ///   - `cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator`
    case custom(Any?)

    // MARK: - Not supported yet

//    case audio(Data)
//
//    case system(String)
//
//    case placeholder
}
