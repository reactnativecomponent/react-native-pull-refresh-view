'use strict'
import React, { Component} from 'react'
import {DeviceEventEmitter, NativeModules, findNodeHandle, ScrollView, processColor} from 'react-native'
const {DWRefreshManager} = NativeModules
const REF_PTR = "ptr_ref"
const DROP_VIEW_DID_BEGIN_REFRESHING_EVENT = 'dropViewDidBeginRefreshing'
let callbacks = {}

export default class PullToRefreshScrollView extends Component {
    static defaultProps = {
		type: '1', // 刷新指示器的样式0、1
		incremental:80,//刷新动画高度
        durationToCloseHeader: 500,//刷新完成延迟收起
        activityIndicatorViewColor: '#A9A9A9',
        refreshing:false,

        tintColor:"#05A5D1",//仅用于type = 0
        //以下仅用于type = 1
        refreshableTitlePull: '下拉刷新',
        refreshableTitleRefreshing: '加载中...',
        refreshableTitleRelease: '松手开始刷新',
        refreshableTitleComplete: '刷新完成',
        isShowLastTime: true,
        titleColor:"#696969",
        timeColor:"#A9A9A9"

    }
    constructor (props) {
        super(props)
        this._onRefresh = this._onRefresh.bind(this)
    }
    componentDidMount () {
      this.subscription = DeviceEventEmitter.addListener(
            DROP_VIEW_DID_BEGIN_REFRESHING_EVENT,
            (reactTag) => {
                callbacks[reactTag]()
                this.timer = setTimeout(() => {
                    this.onRefreshEnd();
                }, 3000);
            });

        var options = {
            type:this.props.type,
            incremental:this.props.incremental,
            activityIndicatorViewColor: processColor(this.props.activityIndicatorViewColor),
            strTitlePull:this.props.refreshableTitlePull,
            strTitleRelease:this.props.refreshableTitleRelease,
            strTitleRefreshing:this.props.refreshableTitleRefreshing,
            strTitleComplete:this.props.refreshableTitleComplete,
            durationToCloseHeader:this.props.durationToCloseHeader,
            isShowLastTime:this.props.isShowLastTime,
            titleColor:processColor(this.props.titleColor),
            timeColor:processColor(this.props.timeColor),
            
            tintColor: processColor(this.props.tintColor)
        };
        let nodeHandle = findNodeHandle(this.refs[REF_PTR])
        DWRefreshManager.configure(nodeHandle, options, (error) => {
            if (!error) {
                callbacks[nodeHandle] = this._onRefresh
            }
        })
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
            return
        }
        this.props.onRefresh()
    }
    // 刷新完成
    onRefreshEnd () {
        let nodeHandle = findNodeHandle(this.refs[REF_PTR])
        DWRefreshManager.endRefreshing(nodeHandle)
    }
    render () {
        return (
            <ScrollView ref={REF_PTR}>
                {this.props.children}
            </ScrollView>
        );
    }
}