/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // move cube
        ppmod.get(Vector(256, 191.938, 18.188), 1, "prop_weighted_cube").SetOrigin(Vector(28.5, -67, -365.781));

        // make second room harder :3

        ppmod.addscript("button_2-button", "OnPressed", function() {
            ppmod.wait(function() {
                ppmod.fire("room_2_exit_door-proxy", "OnProxyRelay1");
                
                // disable stamina
                ::renderStamina = false;
                local stamina = ::contr.stamina._staminaText;
                if (stamina) {
                    if (stamina.ent)
                        stamina.ent.Destroy();
                    ::contr.stamina._staminaText = null;
                }

                // display text if player is close
                if ((::player.GetOrigin() - ppmod.get("button_2-button").GetOrigin()).Length() < 400) {
                    local text = ppmod.text("Thank you for volunteering in the advanced version!");
                    text.SetFade(1, 1, false);
                    text.SetColor("255 64 0")
                    text.Display(5);
                }

                ppmod.wait(function () {
                    ::renderStamina = true;
                }, 8);

            }, 0.2);
        });     

        ppmod.button("prop_button", Vector(1136, 384, 658)).then(function (btn) {
            btn.SetDelay(2.0);
            btn.SetTimer(true);
            btn.OnPressed(function () {
                ppmod.fire("room_2_exit_door-proxy", "OnProxyRelay2");
                ppmod.wait(function() {
                    ppmod.fire("room_2_exit_door-proxy", "OnProxyRelay1");
                }, 2.0);
            });

        });
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}