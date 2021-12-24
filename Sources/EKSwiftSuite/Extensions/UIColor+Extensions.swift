
#if !os(macOS)
import UIKit
typealias Color = UIColor
#else
import AppKit
typealias Color = NSColor
#endif


//swiftlint:enable identifier_name
public extension Color {

    var luminance: CGFloat {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return 0.299 * red + 0.587 * green + 0.114 * blue
    }

    func toHex() -> String {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.displayP3),
              let rgbaComponents = self.cgColor.converted(to: colorSpace, intent: .defaultIntent, options: nil)?.components,
              rgbaComponents.count > 3 else {
                return toHexFallback()
        }
        
        var hex = "#"
        for index in 0...3 {
            let value = UInt8(rgbaComponents[index] * 255)
            if (index == 3 && value == 255) == false {
                hex += String(format:"%0.2X", value)
            }
        }
        return hex
    }
    
    
    private func toHexFallback() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#F4F56F5"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        
    }
    
}

public extension Color {
    
    // MARK: - Initialization
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {  self.init(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1); return }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
            return
        }
        
        self.init(displayP3Red: r, green: g, blue: b, alpha: a)
    }
    
}
