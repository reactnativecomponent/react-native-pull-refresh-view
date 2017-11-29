package com.view.smartrefresh;

import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;


/**
 * Created by panda on 2016/12/9 上午10:12.
 */
public class PtrEvent extends Event<PtrEvent> {

    public PtrEvent(int viewTag) {
        super(viewTag);
    }

    @Override
    public String getEventName() {
        return "ptrRefresh";
    }

    @Override
    public void dispatch(RCTEventEmitter rctEventEmitter) {
        rctEventEmitter.receiveEvent(getViewTag(), getEventName(), null);
    }
}
