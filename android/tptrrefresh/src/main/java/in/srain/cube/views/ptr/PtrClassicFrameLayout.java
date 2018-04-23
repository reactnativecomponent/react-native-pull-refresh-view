package in.srain.cube.views.ptr;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;

public class PtrClassicFrameLayout extends PtrFrameLayout {

    private PtrClassicDefaultHeader mPtrClassicHeader;

    public PtrClassicFrameLayout(Context context) {
        super(context);
        initViews();
    }

    public PtrClassicFrameLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        initViews();
    }

    public PtrClassicFrameLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initViews();
    }

    private void initViews() {
        mPtrClassicHeader = new PtrClassicDefaultHeader(getContext());
        setHeaderView(mPtrClassicHeader);
        addPtrUIHandler(mPtrClassicHeader);
    }

    public PtrClassicDefaultHeader getHeader() {
        return mPtrClassicHeader;
    }

    /**
     * Specify the last update time by this key string
     *
     * @param key
     */
    public void setLastUpdateTimeKey(String key) {
        if (mPtrClassicHeader != null) {
            mPtrClassicHeader.setLastUpdateTimeKey(key);
        }
    }

    /**
     * Using an object to specify the last update time.
     *
     * @param object
     */
    public void setLastUpdateTimeRelateObject(Object object) {
        if (mPtrClassicHeader != null) {
            mPtrClassicHeader.setLastUpdateTimeRelateObject(object);
        }
    }

    public void setRefreshableTitlePull(String str) {
        mPtrClassicHeader.refreshableTitlePull = str;
    }

    public void setRefreshableTitleRefreshing(String str) {
        mPtrClassicHeader.refreshableTitleRefreshing = str;
    }

    public void setRefreshableTitleRelease(String str) {
        mPtrClassicHeader.refreshableTitleRelease = str;
    }

    public void setRefreshableTitleComplete(String str){
        mPtrClassicHeader.refreshableTitleComplete = str;
    }

    public void setDateTitle(String str) {
        mPtrClassicHeader.dateTitle = str;
    }

    public void setTitleColor(int color) {
        mPtrClassicHeader.setTitleColor(color);
    }
    public void setLastUpdateColor(int color) {
        mPtrClassicHeader.setLastUpdateColor(color);
    }
    public void setProgressDrawable(Drawable drawable) {
        mPtrClassicHeader.setProgressDrawable(drawable);
    }
    public void setArrowDrawable(Drawable drawable) {
        mPtrClassicHeader.setArrowDrawable(drawable);
    }
}
