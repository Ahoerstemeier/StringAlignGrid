TStringAlignGrid  (Version 1.7 of 1997-12-07)

Originally it was a descendant of TStringGrid with the possibility to change
the alignment of the text to left (same as StringGrid) or right aligned or
centered and only 4k source code, but with each new version more features
appeared but the name stayed (as there is already a TSuperGrid I've to stick
to the name...), and it now has 200k of source, and there are still further
items on my to do list.


For the quick use: move the PAS and DCR file into your component path and
include it in your library. You can then just drop it onto your forms and set
all the needed properties with the component editor (just double-click the
grid and the see the popup menu which comes after a click with the right mouse
button). If you're using Delphi 1 be sure to use the DCR file in the
subdirectory 16 (you need to unzip with directories for this of course) as
the one in the main directory is the 32bit one for D2 and D3. For Delphi 3
users there's also a package file, which only includes this one component,
just load this file in D3 and select "Install package" - but
you can of course add this component to any other package you like, too.

The more advanced use: here is the description of the new properties and
methods the component offers. If there are several settings which would have
an impact on a specific cell they always follow the hierachy 1. cell 2. column
3. row 4. global; so any cell specific setting is always used, and only if no
cell, column and row specific setting is found the global one is used.

Properties:
-----------
HintCell[Col,Row]         the hint strings for each cell
ShowCellHints             show hints cell specific or for the whole grid

Alignment                 the global alignment for the cell texts
AlignCell[Col,Row]        the alignment for a specific cell
AlignCol/FixAlignCol[Col] the alignment for a column (normal or fixed)
AlignRow/FixAlignRow[Row] the alignment for a row (normal or fixed)
                          possible values: alLeft, alRight, alCenter

Editing                   the global editing (but does not override a missing
                          goEditing in options)
EditCell[Col,Row]         is specific cell editable
EditCol[Col]              is column editable
EditRow[Row]              is row editable
                          all only have any function if goEditing is in the
                          grid's options

ColorCell[Col,Row]        the background color for a specific cell
ColorCol/FixColorCol[Col] the background color for a column (normal or fixed)
ColorRow/FixColorRow[Row] the background color for a row (normal or fixed)

these colors are done internally via these brushes, so you can use the brush
directly if you want

BrushCell[Col,Row]        the background Brush for a specific cell
BrushCol/FixBrushCol[Col] the background Brush for a column (normal or fixed)
BrushRow/FixBrushRow[Row] the background Brush for a row (normal or fixed)

CellFont[Col,Row]         the font for a specific cell
ColFont/FixedColFont[Col] the font for a column (normal or fixed)
RowFont/FixedRowFont[Row] the font for a row (normal or fixed)

and finally

SelectedColorCell[Col,Row]      to set the colors used for the highlighted
SelectedColorCol[Col]           cells; as I doubt these to be needed that
SelectedColorRow[Row]           often (and can make the grid unusable easily)
SelectedFontColorCell[Col,Row]  they are not in the component editor yet
SelectedFontColorCol[Col]
SelectedFontColorRow[Row]

--------
The following methods are to set a value back to the default value so a
setting in a lower level of the hierachy can take effect

ResetFontCell(Col,ARow)   reset the font for the cell
ResetFontCol(Col)         reset the font for the column
ResetFontFixedCol(Col)    reset the font for the fixed column
ResetFontRow(Row)         reset the font for the row
ResetFontFixedRow(Row)    reset the font for the fixed row

and just the same way the ResetAlign... and ResetColor... and ResetEdit...
and ResetBrush... methods.

RemoveCol(Col)
RemoveRow(Row)
InsertCol(Col)
InsertRow(Row)            guess what: to remove and add a column or row, of
                          course including all the special features of the
                          column/row
AdjustColWidth(Col)       resize the column to the maximum width in this
                          column
AdjustColWidths           resize all widths
AdjustRowHeight(Row)      resize the row to the maximum height in this row
AdjustRowHeights          resize all heights

AutoEditNextCell          Jump to the next cell after finishing editing in the
                          current one
NextCellEdit              the direction of the next cell to choose (I doubt
                          anything else then nc_rightdown will be needed)
AfterLastCellEdit         what should happen if a jump into the cell after the
                          last one is attempted: nothing (lc_stop), jumping
                          back to the start (lc_first) or inserting a new row
                          or col (lc_newcolrow)
NextCellTab               the same for the goTabs option
AfterLastCellTab          the same for the goTabs option

Contents2HTML             Convert the grid to a HTML table
Contents2CSV              Convert the grid to a ASCII table with a common
                          separator char
CSV2Contents              and back
Contents2CSVClipboard     to put it into the clipboard as above
ClipBoardCSV2Contents     and back
SaveToFile                basically a Contents2CSV with #7 (TAB) as separator
LoadFromFile              and back
CopyToClipboard           basically a Contents2CSVClipboard with #7
CopyFromClipboard         and back

The data parameter for Contents2HTML and Contents2CSV can be a set to an
existing stream to allow appending or reusing of a stream. If it is NIL a new
TMemorystream will be created (and this must be freed in your code if you
don't want memory leaks).

The Rect in the two CSV routines can be (-1,-1,-1,-1) to cover the whole grid,
or e.g. (1,1,-1,-1) to only cover the non-fixed cells (for FixedRows=1 and
FixedCols=1), or (0,0,1,1) to only cover the four top-left cells.

Events:
-------
OnBeforeEdit              a (editable) cell is entered for Edit
OnAfterEdit               a cell has finished its editing successfully
                          use this e.g. for validation of entered data
OnAfterCancel             a cell has canceled its editing (ESC hit)
OnColWidthChanged         any change in the width of one or several columns
OnRowHeightChanged        any change in the height of one or several rows

If you want to implement contents checking you can add a ShowEdit if the
contents is invalid - this will make sure that the grid won't loose the focus
and the edit for this cell won't be closed.


All the color properties are made internally with the brush for the
cell/column/row - this done to have fitting colors even in 16/256 color
display or while printing.


Sorting:
--------
with the SortColumn(Column:longint; Ascending:boolean) and
SortRow(row,ascending) you can sort the grid; currently with a simple
Bubblesort, so don't expect to much performance on larger grids
(No, I can't use the Quicksort from the VCL as this is missing in Delphi 1).
By default the sorting is done by simple string comparison, but you can define
your own comparison routine with the OnCompareRow and OnCompareCol event
respectively. You can either use the such methods of the grid itself
(CompareColString and CompareColInteger) by assigning these to the event, or
create your own one. The general syntax of such a routine is simply

function form1.CompareColXXX(Sender:TObject; Column,Row1,Row2:longint):t_relation;
begin
  if false then
  else if some_value(Column,Row1)=some_value(Column,Row2) then
    result:=rel_equal
  else if some_value(Column,Row1)>some_value(Column,Row2) then
    result:=rel_greater
  else
    result:=rel_less;
  end;


And for the expert: try to crawl through the code. I tried to comment at least
the most important parts (especially when it becomes tricky), so maybe you
could get some ideas from it. If you wonder about some strange comment lines
within the source code: these are created by the editor I use, they contain
folding information and a big part of the documentation, too, so the source
is much easier to be searched.


Acknowledgements:
there are a lot of people who helped on developing this component - either by
sending bug reports, requesting new features, or by putting some code into
the public which was incorporated into this. Naming them all would make this
readme even larger than it already is, so just a global "Thanks" to all of
you, and keep on writing... At least those I've "stolen" code from are
mentioned in the source.


If you spot any bug (which isn't mentioned on my bug list at
http://www.westend.de/~hoerstemeier/bug.htm) , have any idea how to improve
this component or even want to send me source for addition, want to let me
know what a great job I did :-), want to notify me of the use of any part of
this component for your own one or one of your projects, or for any other
reason, you can mail me:

ah@scp.de            (at work)
andy@hoerstemeier.de (at home)
http://www.westend.de/~hoerstemeier
snail mail: Andreas H"orstemeier
            Mefferdatisstrasse 16-18
            52062 Aachen
            Germany

["o means the umlaut o, that is an o with two dots above]


If you want to complain about anything regarding my components please keep in
mind: I did them in my spare time for fun only, and putting them out for free
is just because of my good will, so keep friendly.

If you want to ask Delphi questions not directly related to my components
please consider asking them in one of the several Newsgroups on the Usenet -
answering email eats quite a lot of my time, and maybe others do know more
about your problem. As I read many of the newsgroups myself you may even get
an answer by me...

If you want to get a notification once I release a new component or a new
version of an existing one you can subscribe to my announce mailing list,
just send an email with subject "subscribe" to "ah-delphi-request@scp.de".
Note this is not for discussion.

This component is Public Domain. If you like it you can send me a thank you
on a nice postcard from your hometown, but if you really want to send me
money I won't complain :-) , but count it as a gift not a payment.
You are free to put this component on a CD-ROM, but if you do so please send
me a copy. And of course only spread this component complete with all the
readme's and sources.

Have fun,
  Andreas H"orstemeier
