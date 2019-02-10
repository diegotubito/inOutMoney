//
//  nsimageExtension.swift
//  coreGym21
//
//  Created by David Diego Gomez on 29/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

extension UIImage {
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

