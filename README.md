![](./docs/banner.png)

---

<div align="center">

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Github Stars](https://img.shields.io/github/stars/AbsoluteStratos/VRC_Graffiti)](https://github.com/AbsoluteStratos/VRC_Graffiti)
[![Repository Liscens: MIT](https://img.shields.io/github/license/AbsoluteStratos/VRC_Graffiti)](https://github.com/AbsoluteStratos/VRC_Graffiti/blob/main/LICENSE)

</div>

An fully functional graffiti can for avatars in VRChat. 
This prefab allows you tag any opaque object in a VR chat world, even your friends.
Supports three different tag slots that are easily customizable with any graphic of your choosing and has customizable size control and togglable sound effects.



## Installation

## Controls

## Customize

Customizing your tags takes only three steps:

### Step 1
Add the the image you want to be your tag to your Unity project (I recommend the tag folder). Create a copy of the image for the menu icon.

### Step 2
For the tag slot of your choosing (1-3), replace the texture on the tag decal object located under `VRCGraffiti/GraffitiAnchor/Tags/DecalTag#` in the prefab on your avatar.

### Step 3
Update the icon of the tag you editted in the `VRC_Graffiti/VRCGraffitiTagMenu.asset` file.

## F.A.Q.

| Does this work in any VRC world on any object?

Generally speaking yes, but not transparent objects. Anything that with a opaque materials should work fine. 

| Why does it make my avatar poor? Is there a way to get around this?

Its poor because theres a inactive light in the prefab. This light allows the graffiti to work across VRC worlds, but is not essential. 
The light, "DepthLight", can be removed but at the cost of limiting functionality of the graffiti to only work on some worlds (e.g. this will break things on maps like The Black Cat or The Great Pug).



## Contact / Support

If you find an issue / bug, have a feature request or have a question, create an issue on this repo.
Support isn't garenteed, but its the best way to get into contact with me.

*If you enjoy this project, support my work by simply starring this repo! Thanks Spartan!*