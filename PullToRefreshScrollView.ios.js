'use strict';

import React, {Component} from 'react';

import ReactNative, {UIManager,NativeModules,NativeAppEventEmitter,findNodeHandle,StyleSheet, processColor} from 'react-native';

const { DWRefreshManager } = NativeModules;

var DROP_VIEW_DID_BEGIN_REFRESHING_EVENT = 'dropViewDidBeginRefreshing';

var callbacks = {};

var subscription = NativeAppEventEmitter.addListener(
  DROP_VIEW_DID_BEGIN_REFRESHING_EVENT,
  (reactTag) => callbacks[reactTag]()
);
// subscription.remove();

var PullToRefreshScrollView = {
  configure: function(configs, callback) {
    var nodeHandle = ReactNative.findNodeHandle(configs.node);
    var options = {
      tintColor: processColor(configs.tintColor),
      activityIndicatorViewColor: processColor(configs.activityIndicatorViewColor)
    };
    DWRefreshManager.configure(nodeHandle, options, (error) => {
      if (!error) {
        callbacks[nodeHandle] = callback;
      }
    });
  },
  endRefreshing: function(node) {
    var nodeHandle = ReactNative.findNodeHandle(node);
    DWRefreshManager.endRefreshing(nodeHandle);
  }
};

module.exports = PullToRefreshScrollView;