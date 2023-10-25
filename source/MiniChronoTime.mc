import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;

class MiniChronoTime extends WatchUi.Drawable {

    private const GAP_X = 5;

    private var font;
    private var hourColor;
    private var minutesColor;

    function initialize() {
        Drawable.initialize({ :identifier => "MiniChronoTime" });

        font = WatchUi.loadResource(Rez.Fonts.TiltNeon);

        hourColor = Application.Properties.getValue("HourColor");
        minutesColor = Application.Properties.getValue("MinutesColor");
    }

    function draw(dc) {
        var currentTime = getCurrentTime();
        var hour = currentTime[:hour];
        var minutes = currentTime[:minutes];

        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        var fontHeight = dc.getFontHeight(font);
        var y = centerY - fontHeight / 2;

		dc.setColor(hourColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
            centerX - GAP_X, 
            y,
			font,
			hour,
            Graphics.TEXT_JUSTIFY_RIGHT
		);

		dc.setColor(minutesColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
            centerX + GAP_X, 
            y,
			font,
			minutes,
			Graphics.TEXT_JUSTIFY_LEFT
		);
    }
    
    function getCurrentTime() {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minutes = clockTime.min;

        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        return {
            :hour => hour.format("%02d"),
            :minutes => minutes.format("%02d")
        };
    }

}