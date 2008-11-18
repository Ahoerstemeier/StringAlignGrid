TStringAlignGrid

Descendant of TStringGrid with the possibility to change the alignment of
the text to left (same as StringGrid) or right aligned or centered. You can
change this for all cells of the grid with the property Alignment (also visible
in the Object Inspector) or for each column with the AlignCol or FAlignCol (for
the fixed cells) array. The possible values of these properties are
alLeft, alRight and alCenter.

The value set in the (F)AlignCol property overrules the one set in Alignment,
and you cannot "unset" the value of (F)AlignCol[column] to set back to the
alignment set by Alignment. If DefaultDrawing is set to false this component
will behave exactly as a StringGrid with DefaultDrawing set to false.


If you spot any bug, have any idea how to improve, want to let me know what a
great job I did :-) or anything else, you can mail me at:

hoerste@hal1.physik.uni-dortmund.de
andy@farpoint.sauerland.de
fido: 2:2444/4505.3
snail mail: Andreas H"orstemeier
            Oberlinweg 7
            58675 Hemer
            Germany

["o means the umlaut o, that is an o with two dots above]

This component is Public Domain, but if you want to send me money I won't
complain :-) You are free to put this component on a CD-ROM, but you have
to send me one copy of that CD then. And of course only spread this component
complete with the readme's.


Andreas H"orstemeier
