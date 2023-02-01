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

const WEEK_DAYS = ["NUL", "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];


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

    function onUpdate(dc as Dc) as Void {
        var timeInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        self.drawNumber(dc, timeInfo.hour, $.HOUR_X, $.HOUR_Y);
        self.drawNumber(dc, timeInfo.min, $.MINUTE_X, $.MINUTE_Y);

        dc.fillCircle(self.subscreenCenterX, self.subscreenCenterY, self.subscreenR);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            self.subscreenCenterX,
            self.subscreenCenterY - 24,
            Graphics.FONT_MEDIUM,
            $.WEEK_DAYS[timeInfo.day_of_week],
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.drawText(
            self.subscreenCenterX,
            self.subscreenCenterY - 8,
            Graphics.FONT_NUMBER_MILD,
            timeInfo.day.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
