
# react-native-smart-refreshview

## Getting started

`$ npm install react-native-smart-refreshview --save`

### Mostly automatic installation

`$ react-native link react-native-smart-refreshview`

### Manual installation


#### iOS
1. Drag DWRefreshManager.xcodeproj to your project on Xcode.
2. Click on your main project file (the one that represents the .xcodeproj) select Build Phases and drag libDWRefreshManager..a from the Products folder inside the DWRefreshManager.xcodeproj.
3. Add import PullToRefreshScrollView from 'react-native-smart-refreshview'; to your code.


#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.view.smartrefresh.RNSmartRefreshPackage;` to the imports at the top of the file
  - Add `new RNSmartRefreshPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-smart-refreshview'
    include ':react-native-smart-refreshview:ptrrefresh'
  	project(':react-native-smart-refreshview').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-smart-refreshview/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-smart-refreshview')
  	```

#### Windows

## Usage

#### iOS
```javascript
import React from 'react';
import {
    View,
    ScrollView,
} from 'react-native';
import PullToRefreshScrollView from 'react-native-smart-refreshview';
var SCROLLVIEW = 'ScrollView';
var DROP_VIEW_DID_BEGIN_REFRESHING_EVENT = 'dropViewDidBeginRefreshing';
class RefreshDemo extends React.Component {
    componentDidMount() {
        this.msgStatusListener = NativeAppEventEmitter.addListener(DROP_VIEW_DID_BEGIN_REFRESHING_EVENT,(data)=>{
            console.log(data)
            });

        PullToRefreshScrollView.configure({
            node: this.refs[SCROLLVIEW],
            tintColor: '#DC143C',
            activityIndicatorViewColor: '#DC143C'
        }, () => {
            this.timer = setTimeout(() => {
                PullToRefreshScrollView.endRefreshing(this.refs[SCROLLVIEW]);
            }, 2000);
        });
    }
    componentWillUnmount() {
        this.msgStatusListener && this.msgStatusListener.remove();
        this.timer && clearTimeout(this.timer);
    }

    render() {
        return (
            <View style={{flex: 1}} >
                <ScrollView ref={SCROLLVIEW} style={{flex: 1}}>
                    <View style={{backgroundColor: '#FF1493', height: 150}} />
                    <View style={{backgroundColor: '#00FFFF', height: 150}} />
                    <View style={{backgroundColor: '#DAA520', height: 150}} />
                </ScrollView>
            </View>
            )}
    }
```

#### Android
```javascript
import PullToRefreshScrollView from 'react-native-smart-refreshview';

// TODO: What to do with the module?

<PullToRefreshScrollView
                refreshing={this.state.refreshing}
                onPullRefresh={this.onPullRefresh.bind(this)}
                style={{backgroundColor:'#f7f7f7',flex:1}}>
</PullToRefreshScrollView>
```
  # react-native-smart-refreshview
