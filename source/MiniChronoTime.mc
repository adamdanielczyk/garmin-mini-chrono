import Toybox.Graphics;
import Toybox.WatchUi;

class MiniChronoTime extends WatchUi.Drawable {

    private const VALUES_GAP = 5;

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
        var currentTime = configurationProvider.getCurrentTime();
        var hour = currentTime[:hour];
        var minutes = currentTime[:minutes];

        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        var fontHeight = dc.getFontHeight(configurationProvider.font);

        if (configurationProvider.useVerticalLayout) {
            drawVerticalLayout(dc, hour, minutes, centerX, centerY, fontHeight);
        } else {
            drawHorizontalLayout(dc, hour, minutes, centerX, centerY, fontHeight);
        }
    }

    function drawVerticalLayout(dc, hour, minutes, centerX, centerY, fontHeight) {
        drawValue(dc, configurationProvider.hourColor, centerX, centerY - VALUES_GAP - fontHeight, hour, configurationProvider.hideHourLeadingZero ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_CENTER);
        drawValue(dc, configurationProvider.minutesColor, centerX, centerY + VALUES_GAP, minutes, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHorizontalLayout(dc, hour, minutes, centerX, centerY, fontHeight) {
        var y = centerY - fontHeight / 2;

        drawValue(dc, configurationProvider.hourColor, centerX - VALUES_GAP, y, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        drawValue(dc, configurationProvider.minutesColor, centerX + VALUES_GAP, y, minutes, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawValue(dc, color, x, y, hour, textJustify) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, configurationProvider.font, hour, textJustify);
    }
}