//
//  RefreshState.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLStateMachine

public enum RefreshState: StateType {
    /// Initial state
    case initial
    /// Refreshing data
    case refreshing
    /// There's more data to load
    case paginated
    /// Loading more data
    case paging
    /// End of loading, no more data
    case populated
    
    case error(Error)
    
    public var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    public var stability: Stability {
        switch self {
        case .refreshing, .paging:
            return .transitional
        default:
            return .stable
        }
    }
    
    public static var initialState: RefreshState {
        return .initial
    }
}
