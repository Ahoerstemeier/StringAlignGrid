TStringAlignGrid  (Version 1.1 of 1996-07-03)

Descendant of TStringGrid with the possibility to change the alignment of
the text to left (same as StringGrid) or right aligned or centered. You can
change this for all cells of the grid with the property Alignment (also visible
in the Object Inspector) or for each column with the AlignCol or FAlignCol (for
the fixed cells) array. Finally you can set it for each cell alone with the
AlignCell property. The possible values of these properties are alLeft,
alRight and alCenter.

The value set in the (F)AlignCol property overrules the one set in Alignment,
the same holds for the AlignCell property which overrules both the
(F)AlignCell and the Alignment.
To unset the value of an (F)AlignCol or AlignCell for any Col or Cell you can
use the Reset(F)AlignCol and ResetAlignCell methods.
If DefaultDrawing is set to false this component will behave exactly as a
StringGrid with DefaultDrawing set to false, so this property is totally
useless (it's just a problem of inheritance - you cannot unpublish a property
so all descendents of the StringGrid have this property published).

If you spot any bug, have any idea how to improve, want to let me know what a
great job I did :-), use any part of this component for your own one or
anything else, you can mail me at (note the new address):

ah@scp.de
andy@farpoint.sauerland.de
fido: 2:2444/4505.3
snail mail: Andreas H"orstemeier
            Mefferdatisstrasse 16-18
            52062 Aachen
            Germany

["o means the umlaut o, that is an o with two dots above]

This component is Public Domain, but if you want to send me money I won't
complain :-) You are free to put this component on a CD-ROM, but you have
to send me one copy of that CD then. And of course only spread this component
complete with all the readme's.


Andreas H"orstemeier
