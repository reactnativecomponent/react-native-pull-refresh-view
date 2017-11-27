
# react-native-smart-refreshview

## Getting started

`$ npm install react-native-smart-refreshview --save`

### Mostly automatic installation

`$ react-native link react-native-smart-refreshview`

### Manual installation


#### iOS

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.view.smartrefresh.RNSmartRefreshPackage;` to the imports at the top of the file
  - Add `new RNSmartRefreshPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-smart-refreshview'
  	project(':react-native-smart-refreshview').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-smart-refreshview/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-smart-refreshview')
  	```

#### Windows

## Usage
```javascript
import SmartRefreshLayout from 'react-native-smart-refreshview';

// TODO: What to do with the module?

<SmartRefreshLayout
                refreshing={this.state.isLoading}
                onPullRefresh={this.queryAdverts.bind(this)}
                style={{backgroundColor:'#f7f7f7',flex:1}}>
</SmartRefreshLayout>
```
  # react-native-smart-refreshview
