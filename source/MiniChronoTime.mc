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
    private var hideHourLeadingZero;

    function initialize() {
        Drawable.initialize({ :identifier => "MiniChronoTime" });
        loadConfiguration();
    }

    function onSettingsChanged() {
        loadConfiguration();
    }
        
    function loadConfiguration() {
        loadFont();
        loadColors();

        useVerticalLayout = Application.Properties.getValue("UseVerticalLayout");
        hideHourLeadingZero = Application.Properties.getValue("HideHourLeadingZero");
    }

    function loadFont() {
        var selectedFont = Application.Properties.getValue("SelectedFont");
        font = WatchUi.loadResource(fonts[selectedFont]);
    }

    function loadColors() {
        var hourRgb;
        var minutesRgb;

        var useCustomColors = Application.Properties.getValue("UseCustomColors");

        if (useCustomColors) {
            hourRgb = new Rgb(
                Application.Properties.getValue("RedHourColor"),
                Application.Properties.getValue("GreenHourColor"),
                Application.Properties.getValue("BlueHourColor") 
            );

            minutesRgb = new Rgb(
                Application.Properties.getValue("RedMinutesColor"),
                Application.Properties.getValue("GreenMinutesColor"),
                Application.Properties.getValue("BlueMinutesColor") 
            );
        } else {
            var presetColor = Application.Properties.getValue("PresetColor");
            switch (presetColor) {
                default:
                case Blue:
                    hourRgb = new Rgb(102, 204, 255);
                    minutesRgb = new Rgb(230, 247, 255);
                    break;
                case Green:
                    hourRgb = new Rgb(51, 204, 51);
                    minutesRgb = new Rgb(235, 250, 235);
                    break;
                case Grey:
                    hourRgb = new Rgb(128, 128, 128);
                    minutesRgb = new Rgb(230, 230, 230);
                    break;
                case Orange:
                    hourRgb = new Rgb(255, 153, 0);
                    minutesRgb = new Rgb(255, 245, 230);
                    break;
                case Pink:
                    hourRgb = new Rgb(255, 51, 204);
                    minutesRgb = new Rgb(255, 230, 249);
                    break;
                case Red:
                    hourRgb = new Rgb(255, 0, 0);
                    minutesRgb = new Rgb(255, 230, 230);
                    break;
                case Yellow:
                    hourRgb = new Rgb(255, 255, 0);
                    minutesRgb = new Rgb(255, 255, 230);
                    break;
            }
        }

        hourColor = hourRgb.getHex();
        minutesColor = minutesRgb.getHex();
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
        drawValue(dc, hourColor, centerX, centerY - VALUES_GAP - fontHeight, hour, hideHourLeadingZero ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_CENTER);
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
            :hour => hour.format(hideHourLeadingZero ? "%d" : "%02d"),
            :minutes => minutes.format("%02d")
        };
    }

    private const fonts = [
        Rez.Fonts.Comfortaa,
        Rez.Fonts.Exo,
        Rez.Fonts.LexendTera,
        Rez.Fonts.Monofett,
        Rez.Fonts.Montserrat,
        Rez.Fonts.OpenSans,
        Rez.Fonts.Poppins,
        Rez.Fonts.Roboto,
        Rez.Fonts.TiltNeon,
        Rez.Fonts.Tourney
    ];

    enum {
        Blue,
        Green,
        Grey,
        Orange,
        Pink,
        Red,
        Yellow
    }

    class Rgb {
        private var r;
        private var g;
        private var b;

        function initialize(r, g, b) {
            me.r = r;
            me.g = g;
            me.b = b;
        }

        function getHex() {
            return r & 0x0000FF << 16 | g & 0x0000FF << 8 | b & 0x0000FF;
        }
    }

}