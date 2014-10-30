##MagicUI
Simple helper for StablexUI.

MagicUI create controls on StablexUI widget that allows you to resize and move it.
It also generate tooltip with basic widget info: name, position and size.

###Usage:

MagicUI.makeItWhistle(content, generateBackground, recursive);

**content** - StablexUI widget to process with helper.

**generateBackground** - Bool parameter which tells helper to generate random background to content (useful when own content background is transparent).

**recursive** - Process content's children that are stablexui widgets too.

###Important!

* Helper does not change widget's parent behaviour. So if you have parent align not set to '' your drag and drop actions will be ignored and on every drop widget will return to it's origin posotion.

* Size controls will not appear on Text widgets and their derivatives.

* Background generator ignore Bmp widgets.
