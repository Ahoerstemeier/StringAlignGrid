TStringAlignGrid  (Version 1.4 of 1994-03-07)

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

New in version 1.3 is a field similar to AlignCell named HintCell - as you may
guess it is used to set a hint for each cell - but the default behaviour of
one hint for the whole grid is therefore switched off, a hint only pops up
if the hint for the respective cell is set. This all works only if you don't
override the OnShowHint of the Application...

Version 1.4 addes a FontCell etc. for setting the font the same way as the
alignments. I greatly improved the OnHintCell with much easier to use
functions (although normally everything is done automagically by the grid).
Additional to the Column properties I also added Row properties, with the
following hierachy: first comes the Cell, then the Column, then the Rows and
finally the global one. And then there's now a Component Editor which allows
you to set nearly every property of the grid (except the Fonts, but I'm
working on it) with just a few mouse clicks. Now you can also edit the
grid cells on design time!

What's missing: I haven't made the DCR-File (the one containing the icon for
the component library) in a 32bit version, so in D2 you'll see the icon of
the normal TStringGrid instead. The fonts are not editable at design time
due to some problems with the internals of reading/writing data in the DFM
files. And finally there seems to be a bug with the hints in D2, they only
appear in the upper left corner of the grid - I'll crawl through the VCL
to trace this ASAP.

If you spot any bug, have any idea how to improve, want to let me know what a
great job I did :-), use any part of this component for your own one or
anything else, you can mail me at (note the new address):

ah@scp.de
andy@farpoint.westend.de
http://www.westend.de/~hoerstemeier
snail mail: Andreas H"orstemeier
            Mefferdatisstrasse 16-18
            52062 Aachen
            Germany

["o means the umlaut o, that is an o with two dots above]

This component is Public Domain, but if you want to send me money I won't
complain :-) You are free to put this component on a CD-ROM, but if you do
so please send me a copy. And of course only spread this component
complete with all the readme's and sources.


Andreas H"orstemeier
