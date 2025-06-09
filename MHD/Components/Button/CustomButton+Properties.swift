//
//
//
// Created by: Patrik Drab on 25/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import UIKitPro

/// A customizable button configuration system


/// # Type Options (Content)
/// - **Text + Icon**: Button with both text and icon
///   - `.textIcon(label: String, textColor: UIColor?, imageName: String, imageColor: UIColor?, spacing: CGFloat)`
///     - `label`: Button title text
///     - `textColor`: Color of the text (nil uses default)
///     - `imageName`: SF Symbol or asset catalog image name
///     - `imageColor`: Color of the icon (nil uses textColor)
///     - `spacing`: Space between text and icon in points
///
/// - **Icon Only**: Button with only an icon
///   - `.iconOnly(imageName: String, imageColor: UIColor?)`
///     - `imageName`: SF Symbol or asset catalog image name
///     - `imageColor`: Color of the icon
///
/// - **Text Only**: Button with only text
///   - `.textOnly(label: String, textColor: UIColor?)`
///     - `label`: Button title text
///     - `textColor`: Color of the text

enum CButtonType {
    case textIcon(
        label: String,
        textColor: UIColor?,
        iconName: String,
        iconColor: UIColor?,
        iconSize: CGFloat,
        spacing: CGFloat
    )
    case textOnly(label: String, textColor: UIColor?)
    case iconOnly(iconName: String, iconColor: UIColor?, iconSize: CGFloat)
}

extension CButtonType {
    /// Creates a text+icon button with sensible defaults
    static func makeTextIcon(
        label: String,
        textColor: UIColor? = .label,
        iconName: String,
        iconColor: UIColor? = nil,
        iconSize: CGFloat = 24,
        spacing: CGFloat = 8
    ) -> CButtonType {
        return .textIcon(
            label: label,
            textColor: textColor,
            iconName: iconName,
            iconColor: iconColor ?? textColor,
            iconSize: iconSize,
            spacing: spacing
        )
    }
    
    /// Creates a text-only button with default text color
    static func makeTextOnly(
        label: String,
        textColor: UIColor? = .label
    ) -> CButtonType {
        return .textOnly(
            label: label,
            textColor: textColor
        )
    }
    
    /// Creates an icon-only button with optional tint
     static func makeIconOnly(
         iconName: String,
         iconColor: UIColor? = nil,
         iconSize: CGFloat = 24
         
     ) -> CButtonType {
         return .iconOnly(
            iconName: iconName,
            iconColor: iconColor,
            iconSize: iconSize
         )
     }
}

/// # Style Options
/// - **Filled**: Solid background button
///   - `.filled(backgroundColor: UIColor, cornerRadius: CGFloat)`
///     - `backgroundColor`: Background color of the button
///     - `cornerRadius`: Corner radius for rounded corners (0 for square)
///
/// - **FilledWithOutline**: Filled button with border
///   - `.filledWithOutline(borderColor: UIColor, borderWidth: CGFloat, backgroundColor: UIColor, cornerRadius: CGFloat)`
///     - `borderColor`: Color of the border outline
///     - `borderWidth`: Width of the border in points
///     - `backgroundColor`: Background color of the button
///     - `cornerRadius`: Corner radius for rounded corners
///
/// - **Outlined**: Transparent button with border
///   - `.outlined(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat)`
///     - `borderColor`: Color of the border outline
///     - `borderWidth`: Width of the border in points
///     - `cornerRadius`: Corner radius for rounded corners
///
/// - **Plain**: Minimal style with no background or border
///   - `.plain(cornerRadius: CGFloat)`
///     - `cornerRadius`: Corner radius for rounded corners

enum CButtonStyle {
    case plain(cornerRadius: CGFloat)
    case filled(backgroundColor: UIColor, cornerRadius: CGFloat)
    case filledWithOutline(borderColor: UIColor, borderWidth: CGFloat, backgroundColor: UIColor, cornerRadius: CGFloat)
    case outlined(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat)
}

extension CButtonStyle {
    static func makePlain(cornerRadius: CGFloat = 0) -> CButtonStyle {
        return .plain(cornerRadius: cornerRadius)
    }
    
    static func makeFilled(
        backgroundColor: UIColor,
        cornerRadius: CGFloat = 0
    ) -> CButtonStyle {
        return .filled(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        )
    }
    
    static func makeFilledWithOutline(
        borderColor: UIColor,
        borderWidth: CGFloat,
        backgroundColor: UIColor,
        cornerRadius: CGFloat = 0
    ) -> CButtonStyle {
        return .filledWithOutline(
            borderColor: borderColor,
            borderWidth: borderWidth,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        )
    }
    
    static func makeOutlined(
        borderColor: UIColor,
        borderWidth: CGFloat,
        cornerRadius: CGFloat = 0
    ) -> CButtonStyle {
        return .outlined(
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius
        )
    }
}

/// # Size Options
/// - **Auto**: Size based on content with padding
///   - `.auto(pTop: CGFloat, pTrailing: CGFloat, pBottom: CGFloat, pLeading: CGFloat)`
///     - `pTop`: Top padding
///     - `pTrailing`: Right padding
///     - `pBottom`: Bottom padding
///     - `pLeading`: Left padding
///
/// - **Custom Fixed Size**: Explicit dimensions
///   - `.custom(width: CGFloat, height: CGFloat)`
///     - `width`: Fixed width in points
///     - `height`: Fixed height in points

enum CButtonSize {
    case auto(
        pTop: CGFloat,
        pTrailing: CGFloat,
        pBottom: CGFloat,
        pLeading: CGFloat
    )
    case custom(width: CGFloat, height: CGFloat)
}

extension CButtonSize {
    static func makeAuto(pTop: CGFloat = 10,
                         pTrailing: CGFloat = 10,
                         pBottom: CGFloat = 10,
                         pLeading: CGFloat = 10) -> CButtonSize {
        return .auto(pTop: pTop, pTrailing: pTrailing, pBottom: pBottom, pLeading: pLeading)
    }
    
    static func makeAuto(xAxes: CGFloat = 10, yAxes: CGFloat = 10) -> CButtonSize {
        return .auto(pTop: yAxes, pTrailing: xAxes, pBottom: yAxes, pLeading: xAxes)
    }
    
    static func makeAutoZero() -> CButtonSize {
        return .auto(pTop: 0, pTrailing: 0, pBottom: 0, pLeading: 0)
    }
}



struct CButtonShadow {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
}

extension CButtonShadow {
    static func makeCButtonShadow(
        color: UIColor = .black,
        opacity: Float = 0.5,
        offset: CGSize = .init(width: 0, height: 2),
        radius: CGFloat = 4
        
    ) -> CButtonShadow {
        return CButtonShadow(color: color, opacity: opacity, offset: offset, radius: radius)
    }
}
