//
//  RefreshAction.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLStateMachine

public enum RefreshAction: ActionType {
    case pullToRefresh
    case loadingMore
    
    public var transitionState: RefreshState {
        switch self {
        case .pullToRefresh:
            return .refreshing
        case .loadingMore:
            return .paging
        }
    }
}
