import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class App extends AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new MainView() ] as Array<Views or InputDelegates>;
    }
}

function getApp() as App {
    return Application.getApp() as App;
}
