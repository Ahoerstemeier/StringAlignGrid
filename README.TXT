TStringAlignGrid  (Version 1.5 of 1997-05-22)

Originally it was a descendant of TStringGrid with the possibility to change
the alignment of the text to left (same as StringGrid) or right aligned or
centered, but with newer versions many more features appeared but the name
stayed (as there is already a TSuperGrid I've to stick to the name...)


For the quick use: move the PAS and DCR file into your component path and
include it in your library. You can then just drop it onto your forms and set
all the needed properties with the component editor (just double-click the
grid). If you're using Delphi 1 be sure to use the DCR file in the
subdirectory 16 as the one in the main directory is a 32bit one.


The more advanced use: here is the description of the new properties and
methods the component offers. If there are several settings which would have
an impact on a specific cell they always follow the hierachy 1. cell 2. column
3. row 4. global; so any cell specific setting is always used, and only if no
cell, column and row specific setting is found the global one is used.

HintCell[Col,Row]         the hint strings for each cell
ShowCellHints             show hints cell specific or for the whole grid

Alignment                 the global alignment for the cell texts
AlignCell[Col,Row]        the alignment for a specific cell
AlignCol/FixAlignCol[Col] the alignment for a column (normal or fixed)
AlignRow/FixAlignRow[Row] the alignment for a row (normal or fixed)
                          possible values: alLeft, alRight, alCenter

ColorCell[Col,Row]        the background color for a specific cell
ColorCol/FixColorCol[Col] the background color for a column (normal or fixed)
ColorRow/FixColorRow[Row] the background color for a row (normal or fixed)

CellFont[Col,Row]         the font for a specific cell
ColFont/FixedColFont[Col] the font for a column (normal or fixed)
RowFont/FixedRowFont[Row] the font for a row (normal or fixed)

the following are to set a value back to the default value so a setting in a
lower level of the hierachy can take effect

ResetFontCell(Col,ARow)   reset the font for the cell
ResetFontCol(Col)         reset the font for the column
ResetFontFixedCol(Col)    reset the font for the fixed column
ResetFontRow(Row)         reset the font for the row
ResetFontFixedRow(Row)    reset the font for the fixed row

and just the same way the ResetAlign... and ResetColor... methods.

RemoveCol(Col)
RemoveRow(Row)
InsertCol(Col)
InsertRow(Row)            guess what: to remove and add a column or row

And for the expert: try to crawl through the code. I tried to comment at least
the most important parts, so maybe you could get some ideas from it.
If you wonder about the strange comment lines - they are added by the text
editor I use, to fold the code and make it much easier to overlook.


Acknowledgements:
there are some people who helped on developing this component -either by
sending bug reports, requesting new features, or by putting some code into
the public which was incoporated into this. I just list the names here:
 Jaap Bakker, Roland Hartmann, Steve Jordi, Paul B. Klerlein, James Sager


If you spot any bug, have any idea how to improve, want to let me know what a
great job I did :-), want to notify me of the use any part of this component
for your own one, want to hear from me when I throw something into the public,
or for any other reason, you can mail me:

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
