import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;


const TIME_FONT_WIDTH = 48;
const TIME_FONT_HEIGHT = 66;
const TIME_FONT_SPACING = 5;

const HOUR_X = 8;
const HOUR_Y = 8;

const MINUTE_X = HOUR_X;
const MINUTE_Y = HOUR_Y + TIME_FONT_HEIGHT + 8;

const BATTERY_WIDTH = 25;
const BATTERY_HEIGHT = 13;

const BATTERY_X = 115;
const BATTERY_Y = 8 + 8 + 66;


class MainView extends WatchFace {
    var timeFontBitmaps as Array<BitmapResource>;
    var timeFontWidths as Array<Number>;

    var subscreenBox as BoundingBox;
    var subscreenCenterX as Number;
    var subscreenCenterY as Number;
    var subscreenR as Number;

    function initialize() {
        WatchFace.initialize();

        self.timeFontBitmaps = [
            WatchUi.loadResource(Rez.Drawables.Time0),
            WatchUi.loadResource(Rez.Drawables.Time1),
            WatchUi.loadResource(Rez.Drawables.Time2),
            WatchUi.loadResource(Rez.Drawables.Time3),
            WatchUi.loadResource(Rez.Drawables.Time4),
            WatchUi.loadResource(Rez.Drawables.Time5),
            WatchUi.loadResource(Rez.Drawables.Time6),
            WatchUi.loadResource(Rez.Drawables.Time7),
            WatchUi.loadResource(Rez.Drawables.Time8),
            WatchUi.loadResource(Rez.Drawables.Time9)
        ];

        self.timeFontWidths = new [10];
        for (var i = 0; i < 10; i++) {
            self.timeFontWidths[i] = self.timeFontBitmaps[i].getWidth();
        }

        self.subscreenBox = WatchUi.getSubscreen();
        self.subscreenCenterX = self.subscreenBox.x + self.subscreenBox.width / 2;
        self.subscreenCenterY = self.subscreenBox.y + self.subscreenBox.height / 2;
        self.subscreenR = self.subscreenBox.width / 2 + 2;
    }

    function drawNumber(dc as Dc, num as Number, x as Number, y as Number) as Void {
        var digit0 = num % 10;
        var digit1 = num / 10;

        var digit1width = self.timeFontWidths[digit1];
        var digit1diff = $.TIME_FONT_WIDTH - digit1width;
        var digit1offset = digit1diff / 2;
        var digit0left = ($.TIME_FONT_WIDTH - self.timeFontWidths[digit0]) / 2;
        var digit1right = digit1diff - digit1offset;
        var digit0offset = digit1width + digit1right + $.TIME_FONT_SPACING + digit0left;

        x += digit1offset;
        dc.drawBitmap(x, y, self.timeFontBitmaps[digit1]);
        x += digit0offset;
        dc.drawBitmap(x, y, self.timeFontBitmaps[digit0]);
    }

    function drawCalendar(dc as Dc, day as Number, dayOfWeek as String) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(self.subscreenCenterX, self.subscreenCenterY, self.subscreenR);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            self.subscreenCenterX,
            self.subscreenCenterY - 24,
            Graphics.FONT_MEDIUM,
            dayOfWeek.toUpper(),
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.drawText(
            self.subscreenCenterX,
            self.subscreenCenterY - 8,
            Graphics.FONT_NUMBER_MILD,
            day.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawBatteryInfo(dc as Dc, remaining as Float, remainingDays as Float, x as Number, y as Number) as Void {
        var u = x + $.BATTERY_WIDTH;
        var v = y + $.BATTERY_HEIGHT;

        dc.drawLine(x, y, u, y);
        dc.drawLine(x, v, u, v);
        dc.drawLine(x, y, x, v);
        dc.drawLine(u, y, u, v + 1);
        dc.drawLine(u + 1, y + 3, u + 1, v - 3);
        dc.fillRectangle(x + 2, y + 2, ((remaining + 0.5) / 100 * ($.BATTERY_WIDTH - 3) + 0.5).toNumber(), $.BATTERY_HEIGHT - 3);
        dc.drawText(
            x,
            v + 3,
            Graphics.FONT_SMALL,
            Lang.format("$1$d", [remainingDays.toNumber()]),
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

    function onUpdate(dc as Dc) as Void {
        var timeInfo = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var stats = System.getSystemStats();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        self.drawNumber(dc, timeInfo.hour, $.HOUR_X, $.HOUR_Y);
        self.drawNumber(dc, timeInfo.min, $.MINUTE_X, $.MINUTE_Y);

        self.drawCalendar(dc, timeInfo.day, timeInfo.day_of_week);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        self.drawBatteryInfo(dc, stats.battery, stats.batteryInDays, $.BATTERY_X, $.BATTERY_Y);
    }
}
