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
        var fontRes;

        switch (selectedFont) {
            default:
            case Comfortaa:
                fontRes = Rez.Fonts.Comfortaa;
                break;
            case Exo:
                fontRes = Rez.Fonts.Exo;
                break;
            case LexendTera:
                fontRes = Rez.Fonts.LexendTera;
                break;
            case Monofett:
                fontRes = Rez.Fonts.Monofett;
                break;
            case Montserrat:
                fontRes = Rez.Fonts.Montserrat;
                break;
            case OpenSans:
                fontRes = Rez.Fonts.OpenSans;
                break;
            case Poppins:
                fontRes = Rez.Fonts.Poppins;
                break;
            case Roboto:
                fontRes = Rez.Fonts.Roboto;
                break;
            case TiltNeon:
                fontRes = Rez.Fonts.TiltNeon;
                break;
            case Tourney:
                fontRes = Rez.Fonts.Tourney;
                break;
        }

        font = WatchUi.loadResource(fontRes);
    }

    function loadColors() {
        var presetColor = Application.Properties.getValue("PresetColor");
        var useCustomColors = Application.Properties.getValue("UseCustomColors");

        var redHourColor;
        var greenHourColor;
        var blueHourColor;
        var redMinutesColor;
        var greenMinutesColor;
        var blueMinutesColor;

        if (useCustomColors) {
            redHourColor = Application.Properties.getValue("RedHourColor");
            greenHourColor = Application.Properties.getValue("GreenHourColor");
            blueHourColor = Application.Properties.getValue("BlueHourColor");
            
            redMinutesColor = Application.Properties.getValue("RedMinutesColor");
            greenMinutesColor = Application.Properties.getValue("GreenMinutesColor");
            blueMinutesColor = Application.Properties.getValue("BlueMinutesColor");
        } else {
            switch (presetColor) {
                default:
                case Blue:
                    redHourColor = 102;
                    greenHourColor = 204;
                    blueHourColor = 255;
                    redMinutesColor = 230;
                    greenMinutesColor = 247;
                    blueMinutesColor = 255;
                    break;
                case Green:
                    redHourColor = 51;
                    greenHourColor = 204;
                    blueHourColor = 51;
                    redMinutesColor = 235;
                    greenMinutesColor = 250;
                    blueMinutesColor = 235;
                    break;
                case Grey:
                    redHourColor = 128;
                    greenHourColor = 128;
                    blueHourColor = 128;
                    redMinutesColor = 230;
                    greenMinutesColor = 230;
                    blueMinutesColor = 230;
                    break;
                case Orange:
                    redHourColor = 255;
                    greenHourColor = 153;
                    blueHourColor = 0;
                    redMinutesColor = 255;
                    greenMinutesColor = 245;
                    blueMinutesColor = 230;
                    break;
                case Pink:
                    redHourColor = 255;
                    greenHourColor = 51;
                    blueHourColor = 204;
                    redMinutesColor = 255;
                    greenMinutesColor = 230;
                    blueMinutesColor = 249;
                    break;
                case Red:
                    redHourColor = 255;
                    greenHourColor = 0;
                    blueHourColor = 0;
                    redMinutesColor = 255;
                    greenMinutesColor = 230;
                    blueMinutesColor = 230;
                    break;
                case Yellow:
                    redHourColor = 255;
                    greenHourColor = 255;
                    blueHourColor = 0;
                    redMinutesColor = 255;
                    greenMinutesColor = 255;
                    blueMinutesColor = 230;
                    break;
            }
        }

        hourColor = convertRgbToHex(redHourColor, greenHourColor, blueHourColor);
        minutesColor = convertRgbToHex(redMinutesColor, greenMinutesColor, blueMinutesColor);
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

    enum {
        Comfortaa,
        Exo,
        LexendTera,
        Monofett,
        Montserrat,
        OpenSans,
        Poppins,
        Roboto,
        TiltNeon,
        Tourney
    }

    enum {
        Blue,
        Green,
        Grey,
        Orange,
        Pink,
        Red,
        Yellow
    }

}