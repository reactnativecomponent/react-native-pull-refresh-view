package com.view.smartrefresh;

import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

import javax.annotation.Nullable;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;


/**
 * Created by panda on 2016/12/7 下午4:50.
 */
public class ReactPtrAndroidManager extends ViewGroupManager<PtrClassicFrameLayout> {

    private static final int REFRESH_COMPLETE = 0;
    private static final int AUTO_REFRESH = 1;

    private static final String ON_REFRESH = "onPtrRefresh";

    private ReactContext mContext;

    @Override
    public String getName() {
        return "RCTPtrAndroid";
    }

    @Override
    protected PtrClassicFrameLayout createViewInstance(final ThemedReactContext reactContext) {
        mContext = reactContext;
        PtrClassicFrameLayout layout = new PtrClassicFrameLayout(reactContext) {
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
        layout.setLayoutParams(new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        return layout;
    }

    @ReactProp(name = "resistance", defaultFloat = 1.7f)
    public void setResistance(PtrClassicFrameLayout ptr, float resistance) {
        ptr.setResistance(resistance);
    }

    @ReactProp(name = "durationToCloseHeader", defaultInt = 200)
    public void setDurationToCloseHeader(PtrClassicFrameLayout ptr, int duration) {
        ptr.setDurationToCloseHeader(duration);
    }

    @ReactProp(name = "durationToClose", defaultInt = 300)
    public void setDurationToClose(PtrClassicFrameLayout ptr, int duration) {
        ptr.setDurationToClose(duration);
    }

    @ReactProp(name = "ratioOfHeaderHeightToRefresh", defaultFloat = 1.2f)
    public void setRatioOfHeaderHeightToRefresh(PtrClassicFrameLayout ptr, float ratio) {
        ptr.setRatioOfHeaderHeightToRefresh(ratio);
    }

    @ReactProp(name = "pullToRefresh", defaultBoolean = false)
    public void setPullToRefresh(PtrClassicFrameLayout ptr, boolean pullToRefresh) {
        ptr.setPullToRefresh(pullToRefresh);
    }

    @ReactProp(name = "keepHeaderWhenRefresh", defaultBoolean = false)
    public void setKeepHeaderWhenRefresh(PtrClassicFrameLayout ptr, boolean keep) {
        ptr.setKeepHeaderWhenRefresh(keep);
    }

    @ReactProp(name = "pinContent", defaultBoolean = false)
    public void setPinContent(PtrClassicFrameLayout ptr, boolean pinContent) {
        ptr.setPinContent(pinContent);
    }

    @ReactProp(name = "refreshableTitlePull")
    public void setRefreshableTitlePull(PtrClassicFrameLayout ptr, String refreshableTitlePull) {
        ptr.setRefreshableTitlePull(refreshableTitlePull);
    }

    @ReactProp(name = "refreshableTitleRefreshing")
    public void setRefreshableTitleRefreshing(PtrClassicFrameLayout ptr, String refreshableTitleRefreshing) {
        ptr.setRefreshableTitleRefreshing(refreshableTitleRefreshing);
    }

    @ReactProp(name = "refreshableTitleRelease")
    public void setRefreshableTitleRelease(PtrClassicFrameLayout ptr, String refreshableTitleRelease) {
        ptr.setRefreshableTitleRelease(refreshableTitleRelease);
    }

    @ReactProp(name = "refreshableTitleComplete")
    public void setRefreshableTitleComplete(PtrClassicFrameLayout ptr, String refreshableTitleComplete) {
        ptr.setRefreshableTitleComplete(refreshableTitleComplete);
    }

    @ReactProp(name = "dateTitle")
    public void setDateTitle(PtrClassicFrameLayout ptr, String dateTitle) {
        ptr.setDateTitle(dateTitle);
    }

    @ReactProp(name = "titleColor")
    public void setTitleColor(PtrClassicFrameLayout ptr, String tintColor) {
        if (TextUtils.isEmpty(tintColor)) {
            return;
        }
        ptr.setTitleColor(Color.parseColor(tintColor));
    }

    @ReactProp(name = "lastUpdateColor")
    public void setLastUpdateColor(PtrClassicFrameLayout ptr, String tintColor) {
        if (TextUtils.isEmpty(tintColor)) {
            return;
        }
        ptr.setLastUpdateColor(Color.parseColor(tintColor));
    }

    @ReactProp(name = "progressDrawable")
    public void setProgressDrawable(PtrClassicFrameLayout ptr, String progressDrawable) {
        if (TextUtils.isEmpty(progressDrawable)) {
            return;
        }
        int drawableId = mContext.getResources().getIdentifier(progressDrawable, "drawable", mContext.getPackageName());
        if (drawableId != 0) {
            Drawable d = null;
            try {
                d = mContext.getResources().getDrawable(drawableId);
                ptr.setProgressDrawable(d);
            } catch (Resources.NotFoundException e) {
                e.printStackTrace();
            }

        }
    }

    @ReactProp(name = "arrowDrawable")
    public void setArrowDrawable(PtrClassicFrameLayout ptr, String arrowDrawable) {
        if (TextUtils.isEmpty(arrowDrawable)) {
            return;
        }
        int drawableId = mContext.getResources().getIdentifier(arrowDrawable, "drawable", mContext.getPackageName());
        if (drawableId != 0) {
            Drawable d = null;
            try {
                d = mContext.getResources().getDrawable(drawableId);
                ptr.setArrowDrawable(d);
            } catch (Resources.NotFoundException e) {
                e.printStackTrace();
            }

        }
    }

    @Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        return MapBuilder.of("autoRefresh", AUTO_REFRESH, "refreshComplete", REFRESH_COMPLETE);
    }

    @Override
    public void receiveCommand(PtrClassicFrameLayout root, int commandId, @Nullable ReadableArray args) {
        switch (commandId) {
            case AUTO_REFRESH:
                root.autoRefresh();
                break;
            case REFRESH_COMPLETE:
                root.refreshComplete();
                break;
            default:
                break;
        }
    }

    @Override
    protected void addEventEmitters(final ThemedReactContext reactContext, final PtrClassicFrameLayout view) {
        view.setLastUpdateTimeRelateObject(this);
        view.setPtrHandler(new PtrDefaultHandler() {
            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, content, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                reactContext
                        .getNativeModule(UIManagerModule.class)
                        .getEventDispatcher()
                        .dispatchEvent(new PtrEvent(view.getId()));
            }
        });
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.<String, Object>of(
                "ptrRefresh", MapBuilder.of("registrationName", ON_REFRESH));
    }

    @Override
    public void addView(PtrClassicFrameLayout parent, View child, int index) {
        super.addView(parent, child, 1);
        parent.finishInflateRN();
    }
}
