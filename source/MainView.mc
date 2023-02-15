import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;


const TIME_FONT_WIDTH = 48;
const TIME_FONT_HEIGHT = 66;
const TIME_FONT_SPACING = 5;

const HOUR_X = 8;
const HOUR_Y = 8;

const MINUTE_X = HOUR_X;
const MINUTE_Y = HOUR_Y + TIME_FONT_HEIGHT + 8;

const LOW_BATTERY_THRESHOLD = 20.0;


class MainView extends WatchFace {
    var timeFontBitmaps as Array<BitmapResource>;

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

        self.subscreenBox = WatchUi.getSubscreen();
        self.subscreenCenterX = self.subscreenBox.x + self.subscreenBox.width / 2;
        self.subscreenCenterY = self.subscreenBox.y + self.subscreenBox.height / 2;
        self.subscreenR = self.subscreenBox.width / 2 + 2;
    }

    function drawNumber(dc as Dc, num as Number, x as Number, y as Number) as Void {
        dc.drawBitmap(x, y, self.timeFontBitmaps[num / 10]);
        x += $.TIME_FONT_WIDTH + $.TIME_FONT_SPACING;
        dc.drawBitmap(x, y, self.timeFontBitmaps[num % 10]);
    }

    function drawCalendar(dc as Dc, day as Number, dayOfWeek as String, dark as Boolean) as Void {
        dc.setColor(dark ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(self.subscreenCenterX, self.subscreenCenterY, self.subscreenR);

        dc.setColor(dark ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
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

    function onUpdate(dc as Dc) as Void {
        var timeInfo = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var stats = System.getSystemStats();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        self.drawNumber(dc, timeInfo.hour, $.HOUR_X, $.HOUR_Y);
        self.drawNumber(dc, timeInfo.min, $.MINUTE_X, $.MINUTE_Y);

        self.drawCalendar(dc, timeInfo.day, timeInfo.day_of_week, stats.battery <= $.LOW_BATTERY_THRESHOLD);
    }
}
