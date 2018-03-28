'use strict';
import React, {
    Component,
} from 'react';

import {DeviceEventEmitter,NativeModules,findNodeHandle,ScrollView,processColor} from 'react-native'
const {DWRefreshManager} = NativeModules
const REF_PTR = "ptr_ref";
const DROP_VIEW_DID_BEGIN_REFRESHING_EVENT = 'dropViewDidBeginRefreshing';
let callbacks = {};


// subscription.remove();

export default class PullToRefreshScrollView extends Component {
    static defaultProps = {
        durationToCloseHeader: 300,
        durationToClose: 200,
        resistance: 2,
        ratioOfHeaderHeightToRefresh: 1.2,
        refreshing:false,
        refreshableTitlePull: '下拉刷新',
        refreshableTitleRefreshing: '加载中...',
        refreshableTitleRelease: '松手开始刷新',
        refreshableTitleComplete: '刷新完成.',
        dateTitle: '最后更新时间: ',
        tintColor:"#05A5D1",
        activityIndicatorViewColor: '#05A5D1'
    }
    constructor(props) {
        super(props);
        this._onRefresh = this._onRefresh.bind(this);
    }

    componentDidMount() {
      this.subscription = DeviceEventEmitter.addListener(
            DROP_VIEW_DID_BEGIN_REFRESHING_EVENT,
            (reactTag) => callbacks[reactTag]()
        );

        var options = {
            tintColor: processColor(this.props.tintColor),
            activityIndicatorViewColor: processColor(this.props.activityIndicatorViewColor)
        };
        let nodeHandle = findNodeHandle(this.refs[REF_PTR]);
        DWRefreshManager.configure(nodeHandle, options, (error) => {
            if (!error) {
                callbacks[nodeHandle] = this._onRefresh
            }
        });
    }

    componentWillUnmount() {
        this.subscription && this.subscription.remove()
    }
    componentWillReceiveProps(nextProps) {
        if(nextProps.refreshing === false && nextProps.refreshing !== this.props.refreshing){
            this.onRefreshEnd()
        }
    }
    _onRefresh() {
        if (!this.props.onRefresh) {
            return;
        }
        this.props.onRefresh();
    };

    /**
     * 刷新完成
     */
    onRefreshEnd() {
        let nodeHandle = findNodeHandle(this.refs[REF_PTR]);
        DWRefreshManager.endRefreshing(nodeHandle);
    }
    render() {
        return (
            <ScrollView ref={REF_PTR}>
                {this.props.children}
            </ScrollView>
        );
    }
}