package com.view.smartrefresh;

import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.scwang.smartrefresh.header.WaterDropHeader;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;

import java.util.Map;

/**
 * Created by dowin on 2017/11/14.
 */

public class ReactSmartRefreshLayoutManager extends ViewGroupManager<SmartRefreshLayout> implements LifecycleEventListener {

    private static final String REACT_NAME = "RCTSmartRefreshLayout";
    private static final String TAG = "RCTSmartRefreshLayout";

    private static final String ON_REFRESH_EVENT = "onPullRefresh";
    private static final String ON_PULL_TO_REFRESH_EVENT = "onPullRefresh";

    private SmartRefreshLayout swipeRefreshLayout;

    @Override
    public String getName() {
        return REACT_NAME;
    }

    @Override
    protected SmartRefreshLayout createViewInstance(final ThemedReactContext reactContext) {
        swipeRefreshLayout = new SmartRefreshLayout(reactContext) {
            private final Runnable measureAndLayout = new Runnable() {

                int width = 0;
                int height = 0;

                @Override
                public void run() {

                    width = getWidth();
                    height = getHeight();
                    measure(MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
                            MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY));
                    layout(getLeft(), getTop(), getRight(), getBottom());
                }
            };

            @Override
            public void requestLayout() {
                super.requestLayout();
                post(measureAndLayout);
            }
        };

        final Handler handler = new Handler() {

            @Override
            public void handleMessage(Message msg) {
                switch (msg.what) {
                    case 1:
                        Toast.makeText(reactContext,"完成刷新！   ",Toast.LENGTH_SHORT).show();
                        swipeRefreshLayout.finishRefresh(true);
                        break;
                }
            }
        };
        WaterDropHeader header = new WaterDropHeader(reactContext);
        swipeRefreshLayout.setRefreshHeader(header);
        swipeRefreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                Log.w(TAG,"=======onRefresh=======");
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), ON_PULL_TO_REFRESH_EVENT, null);
                handler.sendEmptyMessageDelayed(1, 5000);
            }
        });
        return swipeRefreshLayout;
    }

    @ReactProp(name = "refreshing", defaultBoolean = false)
    public void setRefresh(SmartRefreshLayout view, @Nullable boolean refreshing) {
        if (!refreshing)
            view.finishRefresh();
    }

    int getId() {
        return swipeRefreshLayout.getId();
    }

    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.<String, Object>builder()
                .put(ON_PULL_TO_REFRESH_EVENT, MapBuilder.of("registrationName", ON_PULL_TO_REFRESH_EVENT))
                .build();
    }

    @Override
    public void addView(SmartRefreshLayout parent, View child, int index) {
        super.addView(parent, child, index);
    }

    @Override
    public void onDropViewInstance(SmartRefreshLayout view) {
        super.onDropViewInstance(view);
        Log.w(TAG, "onDropViewInstance");
    }


    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {

    }
}
