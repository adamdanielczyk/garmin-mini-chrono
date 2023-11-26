import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;

class MiniChronoTime extends WatchUi.Drawable {
    private var configurationProvider;

    function initialize() {
        Drawable.initialize({ :identifier => "MiniChronoTime" });
        loadConfiguration();
    }

    function onSettingsChanged() {
        loadConfiguration();
    }

    function loadConfiguration() {
        configurationProvider = new ConfigurationProvider();
    }

    function draw(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;

        var currentTime = configurationProvider.getCurrentTime();
        var hour = currentTime[:hour];
        var minutes = currentTime[:minutes];

        loadFontIfNeeded(dc, screenWidth, screenHeight, hour, minutes);

        var font = configurationProvider.font;
        var fontHeight = dc.getFontHeight(font);
        var centerOffset = getCenterOffset(fontHeight);

        if (configurationProvider.useVerticalLayout) {
            drawVerticalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset);
        } else {
            drawHorizontalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset);
        }
    }

    function loadFontIfNeeded(dc, screenWidth, screenHeight, hour, minutes) {
        if (configurationProvider.isFontSizeCalculated()) {
            return;
        }

        var isFontValid = false;
        while (!isFontValid) {
            isFontValid = configurationProvider.isMinimalFontSize() || isCurrentFontValid(dc, screenWidth, screenHeight, hour, minutes);

            if (isFontValid) {
                configurationProvider.setFontSizeCalculated();
            } else {
                configurationProvider.loadSmallerFont();
            }
        }
    }

    function isCurrentFontValid(dc, screenWidth, screenHeight, hour, minutes) {
        var font = configurationProvider.font;

        var timeWidth;
        var timeHeight;

        var fontHeight = dc.getFontHeight(font);
        var hourWidth = dc.getTextWidthInPixels(hour, font);
        var minutesWidth = dc.getTextWidthInPixels(minutes, font);
        var centerOffset = getCenterOffset(fontHeight);

        if (configurationProvider.useVerticalLayout) {
            timeWidth = hourWidth > minutesWidth ? hourWidth : minutesWidth;
            timeHeight = 2 * (fontHeight + centerOffset);
        } else {
            timeWidth = hourWidth + minutesWidth + 2 * centerOffset;
            timeHeight = fontHeight;
        }

        var additionalWidthSpace = screenWidth * 0.3;
        var additionalHeightSpace = screenHeight * 0.3;

        timeWidth += additionalWidthSpace;
        timeHeight += additionalHeightSpace;

        return timeWidth < screenWidth && timeHeight < screenHeight;
    }

    function getCenterOffset(fontHeight) {
        if (configurationProvider.useVerticalLayout) {
            return fontHeight * 0.15;
        } else {
            return fontHeight * 0.05;
        }
    }

    function drawVerticalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset) {
        var hourY = centerY - fontHeight - centerOffset;
        var minutesY = centerY + centerOffset;

        drawValue(dc, font, configurationProvider.hourColor, centerX, hourY, hour, Graphics.TEXT_JUSTIFY_CENTER);
        drawValue(dc, font, configurationProvider.minutesColor, centerX, minutesY, minutes, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHorizontalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset) {
        var hourX = centerX - centerOffset;
        var minutesX = centerX + centerOffset;
        var y = centerY - fontHeight / 2;

        drawValue(dc, font, configurationProvider.hourColor, hourX, y, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        drawValue(dc, font, configurationProvider.minutesColor, minutesX, y, minutes, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawValue(dc, font, color, x, y, hour, textJustify) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, hour, textJustify);
    }
}
