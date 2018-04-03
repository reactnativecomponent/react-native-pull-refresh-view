
# react-native-smart-refreshview
## 预览
![Preview](https://github.com/reactnativecomponent/react-native-smart-refreshview/blob/master/screen/pull.gif)

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

## Usage
```javascript
import PullToRefreshScrollView from 'react-native-smart-refreshview';

<PullToRefreshScrollView
   refreshing={this.state.refreshing}
   onPullRefresh={this.onPullRefresh.bind(this)}}>
</PullToRefreshScrollView>
```
  # react-native-smart-refreshview
