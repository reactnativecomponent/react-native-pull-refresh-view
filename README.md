
# react-native-pull-refresh-view
## 预览
![Preview](https://github.com/reactnativecomponent/react-native-pull-refresh-view/blob/master/screen/pull.gif)

## Getting started

`$ npm install react-native-pull-refresh-view --save`

### Mostly automatic installation

`$ react-native link react-native-pull-refresh-view`

### IOS
Drag LNRefresh.bundle to Resources
### Manual installation


#### iOS
1. Drag DWRefreshManager.xcodeproj to your project on Xcode.
2. Click on your main project file (the one that represents the .xcodeproj) select Build Phases and drag libDWRefreshManager..a from the Products folder inside the DWRefreshManager.xcodeproj.

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.view.smartrefresh.RNSmartRefreshPackage;` to the imports at the top of the file
  - Add `new RNSmartRefreshPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-pull-refresh-view'
    include ':react-native-pull-refresh-view:ptrrefresh'
  	project(':react-native-pull-refresh-view').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-pull-refresh-view/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-pull-refresh-view')
  	```

## Usage
```javascript
import PullToRefreshScrollView from 'react-native-pull-refresh-view';

<PullToRefreshScrollView
   refreshing={this.state.refreshing}
   onPullRefresh={this.onPullRefresh.bind(this)}}>
</PullToRefreshScrollView>
```
  # react-native-pull-refresh-view
