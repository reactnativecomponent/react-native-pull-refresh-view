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
        incremental:80,//刷新动画高度,type=0时建议高度小于60
        activityIndicatorViewColor: '#A9A9A9',
        refreshing:false,

        tintColor:"#05A5D1",//仅用于type = 0
        //以下仅用于type = 1
        durationToCloseHeader: 500,//刷新完成延迟收起
        refreshableTitlePull: '下拉刷新',
        refreshableTitleRefreshing: '加载中...',
        refreshableTitleRelease: '松手开始刷新',
        refreshableTitleComplete: '刷新完成',
        isShowLastTime: true,
        titleColor:"#696969",
        timeColor:"#A9A9A9",
        titleWidth:90,//固定title的宽度，默认是自动计算宽度
        titleHiddenType:2,//titlelabel显示类型，0，默认类型，显示，1，不显示，2，刷新完成时不显示，3，下拉过程不显示,完成时显示
        isShowCompleteImage: true,//是否显示刷新完成的图标

    }
    constructor (props) {
        super(props)
        this._onRefresh = this._onRefresh.bind(this)
        this.subscription = DeviceEventEmitter.addListener(
            DROP_VIEW_DID_BEGIN_REFRESHING_EVENT,
            (reactTag) => {
            callbacks[reactTag]()
                // setTimeout(()=>{
                //     this.onRefreshEnd();
                // },2000)
        })
    }
    componentDidMount () {

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
            <ScrollView onLayout={(e)=>{
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
                tintColor: processColor(this.props.tintColor),
                titleWidth:this.props.titleWidth,
                titleHiddenType:this.props.titleHiddenType,
                isShowCompleteImage:this.props.isShowCompleteImage
            }
            let nodeHandle = findNodeHandle(this.refs[REF_PTR])
            DWRefreshManager.configure(nodeHandle, options, (error) => {
                if (!error) {
                callbacks[nodeHandle] = this._onRefresh
            }
        })
        }} ref={REF_PTR}>
            {this.props.children}
    </ScrollView>
    );
    }
}
