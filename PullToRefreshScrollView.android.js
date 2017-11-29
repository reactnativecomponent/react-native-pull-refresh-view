/**
 * Created by dowin on 2017/11/28.
 */
'use strict';
import React, {
    Component,
} from 'react';
import {
    requireNativeComponent,
    ScrollView,
    View,
} from 'react-native';
import PropTypes from 'prop-types';
const UIManager = require('react-native/lib/UIManager');
const ReactNative = require('react-native');
const REF_PTR = "ptr_ref";

export default class PullToRefreshScrollView extends Component {

    static defaultProps = {
        durationToCloseHeader: 300,
        durationToClose: 200,
        resistance: 2,
        pinContent: false,
        ratioOfHeaderHeightToRefresh: 1.2,
        pullToRefresh: false,
        keepHeaderWhenRefresh: true,
        refreshing:false,
        refreshableTitlePull: '下拉刷新',
        refreshableTitleRefreshing: '加载中...',
        refreshableTitleRelease: '松手开始刷新',
        displayDate: false,
        dateTitle: '最后更新时间: ',
    }

    constructor(props) {
        super(props);
        this._onRefresh = this._onRefresh.bind(this);
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
     * 自动刷新
     */
    autoRefresh() {
        let self = this;
        UIManager.dispatchViewManagerCommand(
            ReactNative.findNodeHandle(self.refs[REF_PTR]),
            1,
            null
        );
    }

    /**
     * 刷新完成
     */
    onRefreshEnd() {
        UIManager.dispatchViewManagerCommand(
            ReactNative.findNodeHandle(this.refs[REF_PTR]),
            0,
            null
        );
    }

    render() {
        // onPtrRefresh 事件对应原生的ptrRefresh事件
        return (
            <RCTPtrAndroid
                ref={REF_PTR}
                {...this.props}
                onPtrRefresh={() => this._onRefresh()}>
                <ScrollView style={{flex: 1, flexDirection: 'column'}}>
                    {this.props.children}
                </ScrollView>
            </RCTPtrAndroid>
        );
    }
}

//PullToRefreshScrollView.name = "RCTPtrAndroid"; //便于调试时显示(可以设置为任意字符串)
PullToRefreshScrollView.propTypes = {
    onPtrRefresh: PropTypes.func,
    resistance: PropTypes.number,
    durationToCloseHeader: PropTypes.number,
    durationToClose: PropTypes.number,
    ratioOfHeaderHeightToRefresh: PropTypes.number,
    pullToRefresh: PropTypes.bool,
    keepHeaderWhenRefresh: PropTypes.bool,
    pinContent: PropTypes.bool,
    ...View.propTypes,
};

const RCTPtrAndroid = requireNativeComponent('RCTPtrAndroid', PullToRefreshScrollView, {nativeOnly: {onPtrRefresh: true}});