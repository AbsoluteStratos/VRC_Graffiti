<div align="center">

![](./docs/banner.png)

</div>

---

<div align="center">

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Github Stars](https://img.shields.io/github/stars/AbsoluteStratos/VRC_Graffiti)](https://github.com/AbsoluteStratos/VRC_Graffiti)
[![Repository Liscens: MIT](https://img.shields.io/github/license/AbsoluteStratos/VRC_Graffiti)](https://github.com/AbsoluteStratos/VRC_Graffiti/blob/main/LICENSE)

</div>

A fully functional graffiti can for avatars in VRChat. 
This prefab allows you tag any opaque object in a VR chat world, even your friends.
Supports three different tag slots that are easily customizable with any graphic of your choosing and has customizable size control and togglable sound effects.

<div align="center">

![](./docs/GraffitiDemo.gif)

</div>

## Installation
The installation of the VRC graffiti can is simple!

1. Backup your avatar.
2. Download the latest prefab file from the Github [release page](https://github.com/AbsoluteStratos/VRC_Graffiti/releases).
3. Drag it into your Unity project which should create a `Assets/VRC_Graffiti` folder.
4. Add the prefab `Assets/VRC_Graffiti/VRC_Graffiti.prefab` to the root of your avatar.
5. Update the following avatar properties:
    * Expression menu with `Assets/VRC_Graffiti/VRC_Graffiti_Menu.asset`
    * Parameters with `Assets/VRC_Graffiti/VRC_Graffiti_Parameters.asset`
    * FX graph with `Assets/VRC_Graffiti/VRC_Graffiti_Controller.asset`

If you already have some custom controls / animations, adjust step 5 accordingly (e.g. add the `VRC_Graffiti_Menu` as a sub-menu to your existing expression menu).

## Controls


## Customize

Customizing your tags takes only three steps:

1. Add the the image you want to be your tag to your Unity project (I recommend the tag folder under `VRC_Graffiti/Materials/Tags`). Create a copy of the image for the menu icon.
2. For the tag slot of your choosing (1-3), replace the texture on the tag decal object located under `VRCGraffiti/GraffitiAnchor/Tags/DecalTag#` in the prefab on your avatar.
3. Update the icon of the tag you editted in the `VRC_Graffiti/VRC_Graffiti_Tag_Menu.asset` file.

## F.A.Q.

| Does this work in any VRC world on any object?

*Generally* speaking yes, but not transparent objects. Anything that with a opaque materials should work fine.
This will just not work in some worlds though.
If you're on a popular world where it doesnt work, drop a comment on the [open issue](https://github.com/AbsoluteStratos/VRC_Graffiti/issues/1) with the world name.

| Why does it make my avatar poor? Is there a way to get around this?

Its poor because theres a inactive light in the prefab. This light allows the graffiti to work across VRC worlds, but is not essential. 
The light, "DepthLight", can be removed but at the cost of limiting functionality of the graffiti to only work on some worlds (e.g. this will break things on maps like The Black Cat or The Great Pug).



## Contact / Support

If you find an issue / bug, have a feature request or have a question, create an issue on this repo.
Support isn't guaranteed, but its the best way to get into contact with me.

*If you enjoy this project, support my work by simply starring this repo! Thanks Spartan!*