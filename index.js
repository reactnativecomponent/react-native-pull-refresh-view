import React, {Component, PropTypes} from 'react';
import {View, requireNativeComponent,NativeModules} from 'react-native';

export default class SmartRefreshLayout extends Component {

    constructor(props) {
        super(props);
        this._onPullRefresh = this._onPullRefresh.bind(this);
    }
    _onPullRefresh(event: Event) {
        if (!this.props.onPullRefresh) {
            return;
        }
        this.props.onPullRefresh(event.nativeEvent.message);
    }
    render() {
        return (
            <RCTSmartRefreshLayout
                {...this.props}
                onPullRefresh={this._onPullRefresh}
            />);
    }
}
SmartRefreshLayout.propTypes = {
    ...View.propTypes,
    onPullRefresh:PropTypes.func,
    refreshing:PropTypes.bool,
};
const RCTSmartRefreshLayout = requireNativeComponent('RCTSmartRefreshLayout', SmartRefreshLayout);