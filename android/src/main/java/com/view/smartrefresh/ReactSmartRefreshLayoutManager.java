package com.view.smartrefresh;

import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.scwang.smartrefresh.header.BezierCircleHeader;
import com.scwang.smartrefresh.header.DeliveryHeader;
import com.scwang.smartrefresh.header.DropboxHeader;
import com.scwang.smartrefresh.header.FlyRefreshHeader;
import com.scwang.smartrefresh.header.FunGameBattleCityHeader;
import com.scwang.smartrefresh.header.FunGameHitBlockHeader;
import com.scwang.smartrefresh.header.MaterialHeader;
import com.scwang.smartrefresh.header.PhoenixHeader;
import com.scwang.smartrefresh.header.StoreHouseHeader;
import com.scwang.smartrefresh.header.TaurusHeader;
import com.scwang.smartrefresh.header.WaterDropHeader;
import com.scwang.smartrefresh.header.WaveSwipeHeader;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshHeader;
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
    private ReactContext reactContext;

    @Override
    public String getName() {
        return REACT_NAME;
    }

    @Override
    protected SmartRefreshLayout createViewInstance(final ThemedReactContext reactContext) {
        this.reactContext = reactContext;
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
                Log.w(TAG, "=======onRefresh=======");
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

    @ReactProp(name = "hStyle", defaultInt = 0)
    public void setRefresh(SmartRefreshLayout view, @Nullable int hStyle) {
        RefreshHeader header;
        switch (hStyle) {
            case 1:
                header = new BezierCircleHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 2:
                header = new DeliveryHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 3:
                header = new DropboxHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 4:
                header = new FlyRefreshHeader(reactContext);//
                view.setRefreshHeader(header);
                break;
            case 5:
                header = new FunGameBattleCityHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 6:
                header = new FunGameHitBlockHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 7:
                header = new MaterialHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 8:
                header = new PhoenixHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 9:
                header = new StoreHouseHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 10:
                header = new TaurusHeader(reactContext);//
                view.setRefreshHeader(header);
                break;
            case 11:
                header = new WaterDropHeader(reactContext);
                view.setRefreshHeader(header);
                break;
            case 12:
                header = new WaveSwipeHeader(reactContext);
                view.setRefreshHeader(header);
                break;
        }
        view.requestLayout();

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
