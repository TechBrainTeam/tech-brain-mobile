import Foundation

extension Int {
    func yuzdelikEki() -> String {
        if self % 10 == 0 {
            switch self {
            case 10: return "'u"
            case 20: return "'si"
            case 30: return "'u"
            case 40: return "'ı"
            case 50: return "'si"
            case 60: return "'ı"
            case 70: return "'i"
            case 80: return "'i"
            case 90: return "'ı"
            default: return "'u"
            }
        } else {
            let mod = self % 10
            switch mod {
            case 1: return "'i"
            case 2: return "'si"
            case 4: return "'ü"
            case 5: return "'i"
            case 6: return "'sı"
            case 7: return "'si"
            case 8: return "'i"
            case 9: return "'u"
            default: return "'i"
            }
        }
    }
}