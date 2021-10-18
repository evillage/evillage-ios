//
//  MediaItem.swift
//  ClangNotifications
//
//  Created by Jeffrey Snijder on 30/09/2021.
//  Copyright © 2021 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

/// A protocol used to represent the data for a media message.
public protocol MediaItem {

    /// The url where the media is located.
    var url: URL? { get }

    /// The image.
    var image: UIImage? { get }

    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }

    /// The size of the media item.
    var size: CGSize { get }

}
