//
//  FourCharCode.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation

public extension FourCharCode {
    static var classApplication: FourCharCode { return FourCharCode(string: "capp")  }
    static var classDocument: FourCharCode { return FourCharCode(string: "docu")  }
    static var classProperty: FourCharCode { return FourCharCode(string: "prop")  }
    static var classScriptableObject: FourCharCode { return FourCharCode(string: "cobj")  }
 
    static var formAbsolutePosition: FourCharCode { return FourCharCode(string: "indx")  }
    static var formUniqueID: FourCharCode { return FourCharCode(string: "ID  ")  }
    static var formPropertyID: FourCharCode { return FourCharCode(string: "prop")  }
 
    // keyAEObject and keyAEPosition are used by InsertionLocation
    static var keyAEObject: FourCharCode { return FourCharCode(string: "kobj")  }
    static var keyAEPosition: FourCharCode { return FourCharCode(string: "kpos")  }
 
    static var all: FourCharCode { return FourCharCode(string: "all ")  }
    static var any: FourCharCode { return FourCharCode(string: "any ")  }
    static var first: FourCharCode { return FourCharCode(string: "firs")  }
    static var last: FourCharCode { return FourCharCode(string: "last")  }
    static var middle: FourCharCode { return FourCharCode(string: "midd")  }
    
    static var height: FourCharCode { return FourCharCode(string: "hght")  }
    static var width: FourCharCode { return FourCharCode(string: "wdth")  }

    init(string: String) {
        precondition(string.utf16.count == 4)
        self = string.utf16.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}

 
