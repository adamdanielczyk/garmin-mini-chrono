import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;

class MiniChronoTime extends WatchUi.Drawable {

    private const VALUES_GAP = 5;

    private var font;
    private var hourColor;
    private var minutesColor;

    private var useVerticalLayout;

    function initialize() {
        Drawable.initialize({ :identifier => "MiniChronoTime" });

        font = WatchUi.loadResource(Rez.Fonts.TiltNeon);

        var redHourColor = Application.Properties.getValue("RedHourColor");
        var greenHourColor = Application.Properties.getValue("GreenHourColor");
        var blueHourColor = Application.Properties.getValue("BlueHourColor");
        hourColor = convertRgbToHex(redHourColor, greenHourColor, blueHourColor);

        var redMinutesColor = Application.Properties.getValue("RedMinutesColor");
        var greenMinutesColor = Application.Properties.getValue("GreenMinutesColor");
        var blueMinutesColor = Application.Properties.getValue("BlueMinutesColor");
        minutesColor = convertRgbToHex(redMinutesColor, greenMinutesColor, blueMinutesColor);

        useVerticalLayout = Application.Properties.getValue("UseVerticalLayout");
    }

    function convertRgbToHex(r, g, b) {
        return r & 0x0000FF << 16 | g & 0x0000FF << 8 | b & 0x0000FF;
    }

    function draw(dc) {
        var currentTime = getCurrentTime();
        var hour = currentTime[:hour];
        var minutes = currentTime[:minutes];

        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        var fontHeight = dc.getFontHeight(font);

        if (useVerticalLayout) {
            drawVerticalLayout(dc, hour, minutes, centerX, centerY, fontHeight);
        } else {
            drawHorizontalLayout(dc, hour, minutes, centerX, centerY, fontHeight);
        }
    }

    function drawVerticalLayout(dc, hour, minutes, centerX, centerY, fontHeight) {
        drawValue(dc, hourColor, centerX, centerY - VALUES_GAP - fontHeight, hour, Graphics.TEXT_JUSTIFY_CENTER);
        drawValue(dc, minutesColor, centerX, centerY + VALUES_GAP, minutes, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHorizontalLayout(dc, hour, minutes, centerX, centerY, fontHeight) {
        var y = centerY - fontHeight / 2;

        drawValue(dc, hourColor, centerX - VALUES_GAP, y, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        drawValue(dc, minutesColor, centerX + VALUES_GAP, y, minutes, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawValue(dc, color, x, y, hour, textJustify) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, hour, textJustify);
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