+++
title = "Assistive Bottle Opener"
date = Date(2020, 1, 17)
tags = ["3D Printing"]
+++

{{pageheader}}

Biomedical engineering was a natural choice for me. It combines my knack for engineering with my desire to help people. Biomedical engineers are more or less guaranteed to work on projected intended to help people. The spark of altruism at the beginning of a project can slowly fade as a project get longer. This project came out of a desire to work a smaller project where I could see that spark through from beginning to end. Inspiration for this project come from two places. First, I stumbled upon [an article](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6371113/) discussing the cost savings from 3D printing assistive devices. Second, I stumbled across [MakersMakingChange.com](https://makersmakingchange.com/) where such devices are posted.

## Starting Point
<!-- ![.](/assets/blog_images/bottle_opener_01_fig01.jpg) -->
{{postfig 1 "Bottle opener opener downloaded as a starting point"}}

I can't claim credit for this design. I believe I downloaded this design from [MyMiniFactory](https://www.myminifactory.com/object/3d-print-assistive-bottle-opener-74399), though there appears to be several versions of this opener floating around on the web. Armed with my [Prusa i3 MK3](https://www.myminifactory.com/object/3d-print-assistive-bottle-opener-74399), I printed this design as a starting point for my prototyping.

This version works well for bottles within a small range of cap diameters. There were many bottle caps in my kitchen with smaller caps than this opener could accommodate.

I also wanted to improve the aesthetics of this device if I could. The hard surface transitions and utilitarian design doesn't make for an inviting object to hold. I liked the curved profile of the handles. The outside of the curve finds the center of my palm nicely making for a secure grip.

## Prototype 1 - Complete Failure
<!-- ![](/assets/blog_images/bottle_opener_01_fig02.jpg) -->
{{postfig 2 "Prototype 1 of bottle opener"}}

My next thought was to add a conical taper to the cap-gripping portion. I increased the height of the cap-gripping section to have a gently tapering cone. As I was designing this, I suspected that the opener would simply slide upward as the grips were closed. This was indeed the case.

If there was enough friction and the taper angle of the cone were shallow enough, I'm pretty sure this design would work. I wanted this design to be printable in a variety of different materials.

## Prototype 2 - Progress
<!-- ![](/assets/blog_images/bottle_opener_01_fig03.jpg) -->
{{postfig 3 "Prototype 2 of bottle opener"}}

With this new prototype I added three different sections of different diameters. This opened most of the caps that I tested. I added a taper between each section of different diameters. This taper helps with 3D printing. The added benefit is that if the cap is slightly larger than one of the sections, a small amount of downward pressure will expand the opener to allow the cap to fit.

There were a few issues that I wanted to improve:

    The handles could be a bit longer to get the right amount of leverage and to improve the grip comfort.
    The force required to close the opener is higher than I would like. This is mostly because of how thick the plastic is around the cap-gripping portion. This section acts like a large live hinge.
    The gaps between the three different diameter sections were too large. More diameters would work better.

## Prototype 3 - Ready for Testing
<!-- ![](/assets/blog_images/bottle_opener_01_fig04.jpg) -->
{{postfig 4 "Prototype 3 of bottle opener"}}

I added several more sections of different diameters to the cap-gripping section. The handles were lengthened and materials was taken away from around the cap-gripper. This prototype works wonderfully. The are only a few bottle that it doesn't work on. If a bottle has a small cap and the neck of the bottle is much wider, the bottle opener can run into the bottle's neck before the cap gets to the right section of the cap-gripper.

Next steps are to give it to a family member that has trouble opening bottles to get their feedback. Stay tuned.

<!-- ![Close up of the current prototype.](/assets/blog_images/bottle_opener_01_fig05.jpg) -->

## Other Ideas - Jamming

I would like to try a design based on a jamming principle next. That is, when bottle opener is torqued against the cap, the applied torque works to close the gripers further. A small amount of pretension with a spring or rubber band should be applied to the jamming mechanism. This pretension keeps the jamming mechanism in contact with the cap. This design would have a clear advantage over the designs above. The amount of torque applied to the cap is not limited by a user's grip strength. The user just need to apply a force to the opener's handle and that force would be translated into a gripping action by the jamming mechanism. A key test of this device would be open a bottle without closing my hand.

With a jamming mechanism bottle opener, the limiting factor may become the user's grip on the bottle itself. I'd like to build a jamming mechanism for holding the bottle secure to a kitchen countertop or table. Caps have a smaller range of sizes compared with bottles. I suspect the challenge will be to make a mechanism that can hold bottles of all different sizes securely.

## Gallery

{{gallery [1,2,3,4] 600}}

## Additional Articles:

 * Gallup N, Bow JK, Pearce JM. [Economic Potential for Distributed Manufacturing of Adaptive Aids for Arthritis Patients in the U.S.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6371113/) Geriatrics (Basel). 2018;3(4):89. Published 2018 Dec 6. doi:10.3390/geriatrics3040089
