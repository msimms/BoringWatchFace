// MIT License
// 
// Copyright (c) 2020 Mike Simms
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BoringWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format the date and time correctly.
        var timeFormat = "$1$:$2$";
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [ today.hour, today.min.format("%02d")]);
        var dateString = Lang.format("$1$ $2$ $3$", [ today.day_of_week, today.day, today.month ] );

		// Foreground color.
		var foregroundColor = Application.getApp().getProperty("ForegroundColor");

        // Update the time.
        var timeView = View.findDrawableById("TimeLabel");
        timeView.setColor(foregroundColor);
        timeView.setText(timeString);

		// Update the date.
        var dateView = View.findDrawableById("DateLabel");
        dateView.setColor(foregroundColor);
        dateView.setText(dateString);

		// Update the message count.
    	var notificationAmount = System.getDeviceSettings().notificationCount;
		var formattedNotificationAmount = "";
		if (notificationAmount > 0) {
			formattedNotificationAmount = notificationAmount.format("%d");
			if (notificationAmount == 1) {
				formattedNotificationAmount = formattedNotificationAmount + " Msg";
			} else {
				formattedNotificationAmount = formattedNotificationAmount + " Msgs";
			}
		}
		var notificationCountDisplay = View.findDrawableById("MessageCount");      
        notificationCountDisplay.setColor(foregroundColor);
		notificationCountDisplay.setText(formattedNotificationAmount);

        // Call the parent onUpdate function to redraw the layout.
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the state
    // of this View here. This includes freeing resources from memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
