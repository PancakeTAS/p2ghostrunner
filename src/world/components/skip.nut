/**
 * Skip instance
 */
class Skip {

    text = null;
    skip_relay = null;
    skip_relay_delay = null;

    /**
     * Display the skip text
     */
    constructor(duration, func1, func2) {

        // don't show stamina bar
        ::contr.stamina.toggleVisibility(false);

        // bind skip key
        this.skip_relay = func1;
        this.skip_relay_delay = func2;
        ::active_skip <- this;
        SendToConsole("bind e \"script ::active_skip.skip();\"");

        // display skip text
        this.text = ppmod.text("Press E to skip the cutscene", -1, 0.7);
        this.text.SetFade(1, 1, false);
        this.text.SetColor("255 255 255");
        this.text.Display(duration);

        // unbidn skip key
        ppmod.wait(function () {
            SendToConsole("bind e +alt2");
        }, duration);
    }

    /**
     * Skip the cutscene
     */
    function skip() {
        // remove skip text
        this.text.SetFade(0, 0, false);
        this.text.Display(0.1);

        // unbind skip key
        SendToConsole("bind e +alt2");

        // call skip relay
        this.skip_relay();

        // call skip relay delay and show stamina bar
        local inst = this;
        ppmod.wait(function ():(inst) {
            ::contr.stamina.toggleVisibility(true);
            if (inst.skip_relay_delay)
                inst.skip_relay_delay();
        }, 0.1);
    }

}