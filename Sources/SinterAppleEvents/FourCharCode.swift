//
//  FourCharCode.swift
//  SinterPixelsBridge
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation

public extension FourCharCode {
    static var classApplication: FourCharCode { return FourCharCode(string: "capp")  }
    static var formAbsolutePosition: FourCharCode { return FourCharCode(string: "indx")  }
    static var formUniqueID: FourCharCode { return FourCharCode(string: "ID  ")  }
 
    static var all: FourCharCode { return FourCharCode(string: "all ")  }
    static var any: FourCharCode { return FourCharCode(string: "any ")  }
    static var first: FourCharCode { return FourCharCode(string: "firs")  }
    static var last: FourCharCode { return FourCharCode(string: "alast")  }
    static var middle: FourCharCode { return FourCharCode(string: "midd")  }
    
    static var pHeight: FourCharCode { return FourCharCode(string: "hght")  }
    static var pWidth: FourCharCode { return FourCharCode(string: "wdth")  }

    init(string: String) {
        precondition(string.utf16.count == 4)
        self = string.utf16.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}
