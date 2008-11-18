unit Aligrid;

{ Copyright 1995/97 Andreas Hörstemeier             Version 1.5 1997-05-22   }
{ this component is public domain - please check the file readme.txt for     }
{ more detailed info on usage and distributing                               }

{ To do: - More documentation - I started documenting the source, but
           there's still no help file nor a nice demo application
         - Providing a URL for the editor that creates all the strange
           comment lines - they contain the data how to fold the code
         - Fix the strange drawing of the focus rect when RowSelect is set
           (no bug from me but from Borland themselves :-) }

(*@/// interface *)
interface

(*@/// uses *)
uses
  SysUtils,
  typinfo,
(*$ifdef ver80 *)
  WinTypes,
  WinProcs,
(*$else *)
  windows,
(*$endif *)
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Grids,
  dsgnintf,
  stdctrls,
  menus;
(*@\\\0000000801*)

type TMyAlign=(alRight,alLeft,alCenter);

(*@/// TStringAlignGrid=class(TStringGrid) *)
TStringAlignGrid = class(TStringGrid)
private
(*@///   Internal routines and variables for the Read/write of the alignments *)
private
  FSaveAlignCell: Boolean;
  FSaveAlignCol: Boolean;
  FSaveAlignRow: Boolean;
  FSaveFixedAlignCol: Boolean;
  FSaveFixedAlignRow: Boolean;
  procedure ReadAlignCell(Stream: TStream); virtual;
  procedure WriteAlignCell(Stream: TStream); virtual;
  procedure ReadAlignCol(Stream: TStream); virtual;
  procedure WriteAlignCol(Stream: TStream); virtual;
  procedure ReadAlignRow(Stream: TStream); virtual;
  procedure WriteAlignRow(Stream: TStream); virtual;
  procedure ReadFixedAlignCol(Stream: TStream); virtual;
  procedure WriteFixedAlignCol(Stream: TStream); virtual;
  procedure ReadFixedAlignRow(Stream: TStream); virtual;
  procedure WriteFixedAlignRow(Stream: TStream); virtual;

  function ReadAlignColRow(Stream: TStream; list:TList):boolean;
  procedure WriteAlignColRow(Stream: TStream; count: integer; list:TList);
(*@\\\*)
(*@///   Internal routines and variables for the Read/write of the colors *)
private
  FSaveColorCell: Boolean;
  FSaveColorCol: Boolean;
  FSaveColorRow: Boolean;
  FSaveFixedColorCol: Boolean;
  FSaveFixedColorRow: Boolean;

  procedure ReadColorCell(Reader: TReader); virtual;
  procedure WriteColorCell(Writer: TWriter); virtual;
  procedure ReadColorCol(Reader: TReader); virtual;
  procedure WriteColorCol(Writer: TWriter); virtual;
  procedure ReadColorRow(Reader: TReader); virtual;
  procedure WriteColorRow(Writer: TWriter); virtual;
  procedure ReadFixedColorCol(Reader: TReader); virtual;
  procedure WriteFixedColorCol(Writer: TWriter); virtual;
  procedure ReadFixedColorRow(Reader: TReader); virtual;
  procedure WriteFixedColorRow(Writer: TWriter); virtual;

  function ReadColorColRow(Reader: TReader; list:TList):boolean;
  procedure WriteColorColRow(Writer: TWriter; count: integer; list:TList);
(*@\\\0000000203*)
(*@///   Internal routines and variables for the Read/write of the hints *)
private
  FSaveHint: Boolean;
  procedure ReadHint(Reader: TReader); virtual;
  procedure WriteHint(Writer: TWriter); virtual;
(*@\\\*)
(*@///   Internal routines and variables for the Read/write of the cells itself *)
private
  FSaveCells: Boolean;
  procedure ReadCells(Reader: TReader); virtual;
  procedure WriteCells(Writer: TWriter); virtual;
(*@\\\*)
(*@///   Internal routines and variables for the Read/write of the fonts *)
private
  FSaveFontCell: Boolean;
  FSaveFontCol: Boolean;
  FSaveFontRow: Boolean;
  FSaveFixedFontCol: Boolean;
  FSaveFixedFontRow: Boolean;
  procedure ReadFontCell(Reader: TReader); virtual;
  procedure WriteFontCell(Writer: TWriter); virtual;
  procedure ReadFontCol(Reader: TReader); virtual;
  procedure WriteFontCol(Writer: TWriter); virtual;
  procedure ReadFontRow(Reader: TReader); virtual;
  procedure WriteFontRow(Writer: TWriter); virtual;
  procedure ReadFixedFontCol(Reader: TReader); virtual;
  procedure WriteFixedFontCol(Writer: TWriter); virtual;
  procedure ReadFixedFontRow(Reader: TReader); virtual;
  procedure WriteFixedFontRow(Writer: TWriter); virtual;

  function ReadFontColRow(Reader: TReader; list:TList):boolean;
  procedure WriteFontColRow(Writer: TWriter; count: integer; list:TList);

  procedure WriteFont(Writer: TWriter; v:TFont);
  function ReadFont(Reader: TReader):TFont;
(*@\\\0000001601*)
protected
  function CreateEditor: TInplaceEdit; override;
  function CanEditShow: Boolean; override;
protected
  procedure Loaded; override;
  procedure DefineProperties(Filer: TFiler); override;
private
  FShowCellHints: Boolean;
  FAlign: TMyAlign;
  FHintCellLast: TPoint;
  f_SelCellColor, f_SelFontColor: TColor;
(*@///   F... : TList; *)
FAlignCol: TList;
FAlignRow: TList;
FFAlignCol: TList;
FFAlignRow: TList;
FAlignCell: TList;

FColorCol: TList;
FColorRow: TList;
FFColorCol: TList;
FFColorRow: TList;
FColorCell: TList;

FHintCell: TList;
FCell: TList;        { Only for loading and saving the cells property }

FFontCol: TList;
FFontRow: TList;
FFFontCol: TList;
FFFontRow: TList;
FFontCell: TList;
(*@\\\*)
  f_fixedcols, f_fixedrows: integer;

  procedure ListToCells(List:TList);
  procedure CellsToList(var List:TList);

  function is_fixed(ACol,ARow: integer):boolean;

(*@///   property read/write for the alignments *)
function GetAlign: TMyAlign;
procedure SetAlign(const Value: TMyAlign);

function GetAlignCol(ACol: integer):TMyAlign;
procedure SetAlignCol(ACol: integer; const Value: TMyAlign);
function GetFixAlignCol(ACol: integer):TMyAlign;
procedure SetFixAlignCol(ACol: integer; const Value: TMyAlign);

function GetAlignRow(ARow:Integer):TMyAlign;
procedure SetAlignRow(ARow:integer; const Value: TMyAlign);
function GetFixAlignRow(ARow:Integer):TMyAlign;
procedure SetFixAlignRow(ARow:integer; const Value: TMyAlign);

function GetAlignCell(ACol,ARow: integer):TMyAlign;
procedure SetAlignCell(ACol,ARow: integer; const Value: TMyAlign);
(*@\\\*)
(*@///   property read/write for the colors *)
function GetColorCol(ACol: integer):TColor;
procedure SetColorCol(ACol: integer; const Value: TColor);
function GetFixColorCol(ACol: integer):TColor;
procedure SetFixColorCol(ACol: integer; const Value: TColor);

function GetColorRow(ARow:Integer):TColor;
procedure SetColorRow(ARow:integer; const Value: TColor);
function GetFixColorRow(ARow:Integer):TColor;
procedure SetFixColorRow(ARow:integer; const Value: TColor);

function GetColorCell(ACol,ARow: integer):TColor;
procedure SetColorCell(ACol,ARow: integer; const Value: TColor);
(*@\\\*)
  procedure SetSelCellColor(Value: TColor);
  procedure SetSelFontColor(Value: TColor);

  function GetHintCell(ACol,ARow: integer):string;
  procedure SetHintCell(ACol,ARow: integer; const Value: string);

  function GetFontCellComplete(ACol,ARow: integer):TFont;
  function GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont;
  procedure FontChanged(AFont: TObject);

(*@///   property read/write for the fonts *)
function GetFontCell(ACol,ARow: integer):TFont;
procedure SetFontCell(ACol,ARow: integer; const Value: TFont);

function GetFontCol(ACol: integer):TFont;
procedure SetFontCol(ACol: integer; const Value: TFont);
function GetFontFixedCol(ACol: integer):TFont;
procedure SetFontFixedCol(ACol: integer; const Value: TFont);
function GetFontRow(ARow: integer):TFont;
procedure SetFontRow(ARow: integer; const Value: TFont);
function GetFontFixedRow(ARow: integer):TFont;
procedure SetFontFixedRow(ARow: integer; const Value: TFont);
function GetFontColRowInternal(AColRow: integer; create:boolean; List:TList):TFont;
(*@\\\*)

  procedure Initialize;
protected
  procedure DrawCell(ACol,ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  procedure ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  procedure RowMoved(FromIndex, ToIndex: Longint); override;
  procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;

(*@///   property AlignCell/AlignCol/FixAlignCol/AlignRow/FixAlignRow *)
{ The Alignments for each cell or whole Columns (Fixed and normal) }
property AlignCell[ACol,ARow:integer]: TMyAlign read GetAlignCell write SetAlignCell;
property AlignCol[ACol:integer]: TMyAlign read GetAlignCol write SetAlignCol;
property FixAlignCol[ACol:integer]: TMyAlign read GetFixAlignCol write SetFixAlignCol;
property AlignRow[ARow:integer]: TMyAlign read GetAlignRow write SetAlignRow;
property FixAlignRow[ARow:integer]: TMyAlign read GetFixAlignRow write SetFixAlignRow;
(*@\\\*)
(*@///   property ColorCell/ColorCol/FixColorCol/ColorRow/FixColorRow *)
{ The Colors for each cell or whole Columns (Fixed and normal) }
property ColorCell[ACol,ARow:integer]: TColor read GetColorCell write SetColorCell;
property ColorCol[ACol:integer]: TColor read GetColorCol write SetColorCol;
property FixColorCol[ACol:integer]: TColor read GetFixColorCol write SetFixColorCol;
property ColorRow[ARow:integer]: TColor read GetColorRow write SetColorRow;
property FixColorRow[ARow:integer]: TColor read GetFixColorRow write SetFixColorRow;
(*@\\\*)
(*@///   property CellFont/ColFont/FixedColFont/RowFont/FixedRowFont *)
{ The font for each cell and for col and row }
property CellFont[ACol,ARow:integer]: TFont read GetFontCell write SetFontCell;
property ColFont[ACol:integer]: TFont read GetFontCol write SetFontCol;
property RowFont[ARow:integer]: TFont read GetFontRow write SetFontRow;
property FixedColFont[ACol:integer]: TFont read GetFontFixedCol write SetFontFixedCol;
property FixedRowFont[ARow:integer]: TFont read GetFontFixedRow write SetFontFixedRow;
(*@\\\*)

  { The hint string for each cell }
  property HintCell[ACol,ARow:integer]:string read GetHintCell write SetHintCell;

  { To set the respective property back to default behaviour }
  procedure ResetFontCell(ACol,ARow:integer);
  procedure ResetFontCol(ACol:integer);
  procedure ResetFontFixedCol(ACol:integer);
  procedure ResetFontRow(ARow:integer);
  procedure ResetFontFixedRow(ARow:integer);
  procedure ResetAlignCell(ACol,ARow:integer);
  procedure ResetAlignCol(ACol:integer);
  procedure ResetAlignFixedCol(ACol:integer);
  procedure ResetAlignRow(ARow:integer);
  procedure ResetAlignFixedRow(ARow:integer);
  procedure ResetColorCell(ACol,ARow:integer);
  procedure ResetColorCol(ACol:integer);
  procedure ResetColorFixedCol(ACol:integer);
  procedure ResetColorRow(ARow:integer);
  procedure ResetColorFixedRow(ARow:integer);
  procedure ResetAlignment;

  { Insertion and removing of columns and rows }
  procedure RemoveCol(ACol:Integer);
  procedure RemoveRow(ARow:Integer);
  procedure InsertCol(ACol:Integer);
  procedure InsertRow(ARow:Integer);

  { A little utility function }
  procedure ClearSelection;

  function Contents2HTML:TMemorystream;
published
  { The Alignment can be set globally using this property }
  property Alignment: TMyAlign read GetAlign write SetAlign default alLeft;
  { To switch the Hints from cell-specific to grid-global }
  property ShowCellHints: boolean read FShowCellHints write FShowCellHints default true;
  property SelectedCellColor:TColor read f_SelCellColor write SetSelCellColor default clActiveCaption;
  property SelectedFontColor:TColor read f_SelFontColor write SetSelFontColor default clWhite;
end;
(*@\\\0000000701*)
(*@/// TGridComponentEditor = class(TComponentEditor) *)
TGridComponentEditor = class(TComponentEditor)
private
  Align_Items: array[0..4,0..3] of TMenuItem;
  font_Items: array[0..4,0..1] of TMenuItem;
  color_Items: array[0..4,0..1] of TMenuItem;
  ShowHints, ShowCells: TMenuItem;
  Grid: TStringAlignGrid;
  PopupCell: TPoint;
  popup_menu: TPopupMenu;
public
  procedure Edit; override;
  procedure AlignItem(Sender: TObject);
  procedure FontItem(Sender: TObject);
  procedure ColorItem(Sender: TObject);
  procedure MouseDown(Sender:TObject; Button:TMouseButton; Shift: TSHiftstate; X,Y:Integer);
  end;
(*@\\\*)

procedure AddShowHintProc(proc:TShowHintEvent);
procedure RemoveShowHintProc(proc:TShowHintEvent);
procedure AddIdleProc(proc:TIdleEvent);
procedure RemoveIdleProc(proc:TIdleEvent);

procedure Register;
(*@\\\*)
(*@/// implementation *)
implementation

(*@/// Some internal utility procedures *)
{ Some internal utility procedures }
(*@/// procedure cleanlist(List:TList; size:integer); *)
procedure cleanlist(List:TList; size:integer);
var
  i:integer;
begin
  if list<>NIL then begin
    for i:=0 to List.Count-1 do
      if List.Items[i] <> NIL then
        Freemem(List.Items[i],size);
    end;
  end;
(*@\\\*)
(*@/// procedure cleanlist_pstring(List:TList); *)
procedure cleanlist_pstring(List:TList);
var
  i:integer;
begin
  if list<>NIL then begin
    for i:=0 to List.Count-1 do
      if List.Items[i] <> NIL then
        DisposeStr(List.Items[i]);
    end;
  end;
(*@\\\*)
(*@/// procedure cleanlist_object(List:TList); *)
procedure cleanlist_object(List:TList);
var
  i:integer;
begin
  if list<>NIL then begin
    for i:=0 to List.Count-1 do
      TObject(List.Items[i]).Free;
    end;
  end;
(*@\\\*)
(*@\\\0000000401*)

{ A utility class to only save entries really touched by the user }
(*@/// TMyFont              = class(TFont) *)
type
  TMyFont = class(TFont)
  protected
    procedure Changed; override;
  public
    HasChanged: boolean;
    end;

(*@/// procedure TMyFont.Changed; *)
procedure TMyFont.Changed;
begin
  HasChanged:=true;
  inherited changed;
  end;
(*@\\\*)
(*@\\\0000000901*)

{ The InPlace edit field - see below for where I got it }
(*@/// TNewInplaceEdit      = class(TInplaceEdit) *)
type
(*@///   TNewInplaceEdit = class(TInplaceEdit) *)
TNewInplaceEdit = class(TInplaceEdit)
private
  FAlignment: TMyAlign;
protected
  procedure CreateParams(var Params: TCreateParams); override;
  procedure SetAlignment(Value:TMyAlign);
public
(*$ifdef ver80 *)
  { In Delphi 1's VCL the override is missing in TInplaceEdit }
  constructor Create(AOwner:TComponent);
(*$else *)
  constructor Create(AOwner:TComponent); override;
(*$endif *)
  property Alignment: TMyAlign read FAlignment write SetAlignment;
  property Passwordchar;
end;
(*@\\\003C000C01000D01000B01000B01000A01*)
(*@/// procedure TNewInplaceEdit.CreateParams(var Params: TCreateParams); *)
procedure TNewInplaceEdit.CreateParams(var Params: TCreateParams);
const
  Alignments : array[TMyAlign] of Longint = (ES_RIGHT,ES_LEFT,ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style
    and (not ES_MULTILINE)    (* otherwise the passwordchar won't work *)
    or Alignments[FAlignment];
  end;
(*@\\\0000000701*)
(*@/// procedure TNewInplaceEdit.SetAlignment(Value: TMyAlign); *)
procedure TNewInplaceEdit.SetAlignment(Value: TMyAlign);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    RecreateWnd;
    SetSel(0,-1);
    end;
  end;
(*@\\\*)
(*@/// constructor TNewInplaceEdit.Create(AOwner:TComponent); *)
constructor TNewInplaceEdit.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FAlignment := alRight;
  end;
(*@\\\*)
(*@\\\0000000537*)

{ The Grid itself }
(*@/// TStringAlignGrid     = class(TStringGrid) *)
(*@/// The component action: create, initialize, destroy the internal data *)
{ The component action: create, initialize, destroy the internal data }
(*@/// constructor TStringAlignGrid.Create(AOwner: TComponent); *)
constructor TStringAlignGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSaveAlignCell:=false;
  FSaveAlignCol:=false;
  FSaveFixedAlignCol:=false;
  FSaveAlignRow:=false;
  FSaveFixedAlignRow:=false;
  FSaveColorCell:=false;
  FSaveColorCol:=false;
  FSaveFixedColorCol:=false;
  FSaveColorRow:=false;
  FSaveFixedColorRow:=false;
  FSaveFontCell:=false;
  FSaveFontCol:=false;
  FSaveFixedFontCol:=false;
  FSaveFontRow:=false;
  FSaveFixedFontRow:=false;
  FSaveHint:=false;
  FSaveCells:=false;
  Initialize;
  end;
(*@\\\*)
(*@/// destructor TStringAlignGrid.Destroy; *)
destructor TStringAlignGrid.Destroy;
var
  i:integer;
begin
(*@///   FAlignCol.Free; *)
if FAlignCol<>NIL then
  cleanlist(FAlignCol,sizeof(TMyAlign));
FAlignCol.Free;
FAlignCol:=NIL;
(*@\\\*)
(*@///   FAlignRow.Free; *)
if FAlignRow<>NIL then
  cleanlist(FAlignRow,sizeof(TMyAlign));
FAlignRow.Free;
FAlignRow:=NIL;
(*@\\\*)
(*@///   FAlignCell.Free; *)
if FAlignCell<>NIL then
  for i:=0 to FAlignCell.Count-1 do
    cleanlist(TList(FAlignCell.Items[i]),sizeof(TMyAlign));
FAlignCell.Free;
FAlignCell:=NIL;
(*@\\\*)
(*@///   FFAlignCol.Free; *)
if FFAlignCol<>NIL then
  cleanlist(FFAlignCol,sizeof(TMyAlign));
FFAlignCol.Free;
FFAlignCol:=NIL;
(*@\\\*)
(*@///   FFAlignRow.Free; *)
if FFAlignRow<>NIL then
  cleanlist(FFAlignRow,sizeof(TMyAlign));
FFAlignRow.Free;
FFAlignRow:=NIL;
(*@\\\*)
(*@///   FColorCol.Free; *)
if FColorCol<>NIL then
  cleanlist(FColorCol,sizeof(TColor));
FColorCol.Free;
FColorCol:=NIL;
(*@\\\*)
(*@///   FColorRow.Free; *)
if FColorRow<>NIL then
  cleanlist(FColorRow,sizeof(TColor));
FColorRow.Free;
FColorRow:=NIL;
(*@\\\*)
(*@///   FColorCell.Free; *)
if FColorCell<>NIL then
  for i:=0 to FColorCell.Count-1 do
    cleanlist(TList(FColorCell.Items[i]),sizeof(TColor));
FColorCell.Free;
FColorCell:=NIL;
(*@\\\*)
(*@///   FFColorCol.Free; *)
if FFColorCol<>NIL then
  cleanlist(FFColorCol,sizeof(TColor));
FFColorCol.Free;
FFColorCol:=NIL;
(*@\\\*)
(*@///   FFColorRow.Free; *)
if FFColorRow<>NIL then
  cleanlist(FFColorRow,sizeof(TColor));
FFColorRow.Free;
FFColorRow:=NIL;
(*@\\\*)
(*@///   FHintCell.Free; *)
if FHintCell<>NIL then
  for i:=0 to FHintCell.Count-1 do
    cleanlist_pstring(TList(FHintCell.Items[i]));
FHintCell.Free;
FHintCell:=NIL;
(*@\\\*)
(*@///   FFontCol.Free; *)
if FFontCol<>NIL then
  cleanlist_object(FFontCol);
FFontCol.Free;
FFontCol:=NIL;
(*@\\\*)
(*@///   FFontRow.Free; *)
if FFontRow<>NIL then
  cleanlist_object(FFontRow);
FFontRow.Free;
FFontRow:=NIL;
(*@\\\*)
(*@///   FFFontCol.Free; *)
if FFFontCol<>NIL then
  cleanlist_object(FFFontCol);
FFFontCol.Free;
FFFontCol:=NIL;
(*@\\\*)
(*@///   FFFontRow.Free; *)
if FFFontRow<>NIL then
  cleanlist_object(FFFontRow);
FFFontRow.Free;
FFFontRow:=NIL;
(*@\\\*)
(*@///   FFontCell.Free; *)
if FFontCell<>NIL then
  for i:=0 to FFontCell.Count-1 do
    cleanlist_object(TList(FFontCell.Items[i]));
FFontCell.Free;
FFontCell:=NIL;
(*@\\\*)
(*@///   FCell.Free; *)
if FCell<>NIL then
  for i:=0 to FCell.Count-1 do
    cleanlist_pstring(TList(FCell.Items[i]));
FCell.Free;
FCell:=NIL;
(*@\\\*)
  RemoveShowHintProc(ShowHintCell);
  inherited Destroy;
  end;
(*@\\\0000000501*)
(*@/// procedure TStringAlignGrid.Initialize; *)
procedure TStringAlignGrid.Initialize;
begin
  FAlignCell:=TList.Create;
  FAlignCol:=TList.Create;
  FFAlignCol:=TList.Create;
  FAlignRow:=TList.Create;
  FFAlignRow:=TList.Create;
  FColorCell:=TList.Create;
  FColorCol:=TList.Create;
  FFColorCol:=TList.Create;
  FColorRow:=TList.Create;
  FFColorRow:=TList.Create;
  FHintCell:=TList.Create;
  FCell:=TList.Create;
  FFontCell:=TList.Create;
  FFontCol:=TList.Create;
  FFFontCol:=TList.Create;
  FFontRow:=TList.Create;
  FFFontRow:=TList.Create;
  FAlign:=alLeft;
  FShowCellHints:=true;
  FHintCellLast:=point(-1,-1);
  f_SelCellColor:=clActiveCaption;
  f_SelFontColor:=clWhite;
  f_fixedcols:=0;
  f_fixedrows:=0;
  AddShowHintProc(ShowHintCell);
  end;
(*@\\\0000001B01*)
(*@\\\0000000401*)

(*@/// Internal routines for saving any data pointer (or a longint) in a List *)
{ Internal routines for saving any data pointer (or a longint) in a List }
(*@/// function GetItemCol(ACol: Integer; List:TList):Pointer; *)
function GetItemCol(ACol: Integer; List:TList):Pointer;
begin
  if (ACol+1 > List.Count) or (ACol<0) then
    GetItemCol:=NIL
  else
    if List.Items[ACol] = NIL then
      GetItemCol:=NIL
    else begin
      GetItemCol:=List.Items[ACol];
      end;
  end;
(*@\\\*)
(*@/// function SetItemCol(ACol: Integer; List:TList; value:Pointer):pointer; *)
function SetItemCol(ACol: Integer; List:TList; value:Pointer):pointer;
var
  i:integer;
  t:pointer;
begin
  t:=NIL;
  if ACol+1 > List.Count then
    for i:=List.Count to ACol do
      List.Add(NIL);
  if List.Items[ACol] <> NIL then begin
    t:=List.Items[ACol];
    List.Items[ACol]:=value;
    end
  else
    List.Items[ACol]:=value;
  SetItemCol:=t;
  end;
(*@\\\*)
(*@/// procedure ExchangeItemCol(ACol1,ACol2: Integer; List:TList); *)
procedure ExchangeItemCol(ACol1,ACol2: Integer; List:TList);
var
  p: pointer;
begin
  p:=SetItemCol(ACol1,List,NIL);
  p:=SetItemCol(ACol2,List,p);
  SetItemCol(ACol1,List,p);
  end;
(*@\\\0000000703*)
(*@/// procedure MoveItemCol(FromIndex, ToIndex: integer; list:TList); *)
procedure MoveItemCol(FromIndex, ToIndex: integer; list:TList);
var
  p: pointer;
begin
  p:=SetItemCol(FromIndex,list,NIL);
  list.Delete(FromIndex);
  while ToIndex>list.count do
    list.add(NIL);
  list.Insert(ToIndex,p);
  end;
(*@\\\0000000701*)
(*@\\\000000050B*)
(*@/// Internal routines for saving any data pointer in a two-dimensional List *)
{ Internal routines for saving any data pointer in a two-dimensional List }
(*@/// function GetItemCell(ACol,ARow: Integer; List:TList):Pointer; *)
function GetItemCell(ACol,ARow: Integer; List:TList):Pointer;
var
  sublist: TList;
begin
  if (ACol+1 > List.Count) or (ACol<0) or (ARow<0) then
    GetItemCell:=NIL
  else
    if List.Items[ACol] = NIL then
      GetItemCell:=NIL
    else begin
      sublist:=TList(List.Items[ACol]);
      if ARow+1 > sublist.Count then
        GetItemCell:=NIL
      else
        GetItemCell:=sublist.Items[ARow]
    end;
  end;
(*@\\\0000000B01*)
(*@/// function SetItemCell(ACol,ARow: Integer; List:TList; value:Pointer):pointer; *)
function SetItemCell(ACol,ARow: Integer; List:TList; value:Pointer):pointer;
(* give back the pointer to the previously stored element to let the caller dispose it *)
var
  i:integer;
  t:pointer;
  sublist:TList;
begin
  t:=NIL;
  if ACol+1 > List.Count then
    for i:=List.Count to ACol do
      List.Add(NIL);
  if List.Items[ACol] = NIL then
    List.Items[ACol]:=TList.Create;
  sublist:=TList(List.Items[ACol]);
  if ARow+1 > sublist.Count then
    for i:=sublist.Count to ARow do
      sublist.Add(NIL);
  if sublist.items[ARow] <> NIL then begin
    t:=sublist.items[ARow];
{     FreeMem(t,size); }
    sublist.Items[ARow]:=value;
    end
  else
    sublist.Items[ARow]:=value;
  SetItemCell:=t;
  end;
(*@\\\0000000301*)
(*@/// procedure ExchangeItemColRow(ARow1,ARow2:integer; list:TList); *)
procedure ExchangeItemColRow(ARow1,ARow2:integer; list:TList);
var
  i:integer;
  sublist:TList;
begin
  for i:=List.Count-1 downto 0 do begin
    sublist:=TList(List.Items[i]);
    if sublist=NIL then begin
      sublist:=TList.Create;
      List.Items[i]:=sublist;
      end;
    ExchangeItemCol(ARow1,ARow2,sublist);
    end;
  end;
(*@\\\0000000C01*)
(*@/// procedure MoveItemColRow(FromRow,ToRow:integer; list:TList); *)
procedure MoveItemColRow(FromRow,ToRow:integer; list:TList);
var
  i:integer;
  sublist:TList;
  p: pointer;
begin
  for i:=list.Count-1 downto 0 do begin
    sublist:=TList(list.Items[i]);
    if sublist=NIL then begin
      sublist:=TList.Create;
      list.Items[i]:=sublist;
      end;
    p:=SetItemCol(FromRow,sublist,NIL);
    sublist.Delete(FromRow);
    while ToRow>sublist.count do
      sublist.add(NIL);
    sublist.Insert(ToRow,p);
    end;
  end;
(*@\\\0000001001*)
(*@\\\0000000501*)

(*@/// Property read and write for Alignment *)
{ Property read and write for Alignment }
(*@/// function TStringAlignGrid.GetAlign: TMyAlign; *)
function TStringAlignGrid.GetAlign: TMyAlign;
begin
  GetAlign:=FAlign;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetAlign(const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlign(const Value: TMyAlign);
begin
  FAlign:=Value;
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for AlignCell *)
{ Property read and write for AlignCell }
(*@/// function TStringAlignGrid.GetAlignCell(ACol,ARow:Integer):TMyAlign; *)
function TStringAlignGrid.GetAlignCell(ACol,ARow:Integer):TMyAlign;
var
  v:^tmyalign;
  fixed: boolean;
begin
  v:=GetItemCell(ACol,ARow,FAlignCell);
  fixed:=is_fixed(ACol,ARow);
  if v=NIL then begin
    if fixed then
      v:=GetItemCol(ACol,FFAlignCol)
    else
      v:=GetItemCol(ACol,FAlignCol);
    if v=NIL then begin
      if fixed then
        v:=GetItemCol(ARow,FFAlignRow)
      else
        v:=GetItemCol(ARow,FAlignRow);
      if v=NIL then
        result:=Alignment
      else
        result:=v^;
      end
    else
      result:=v^;
    end
  else
    result:=v^;
  end;
(*@\\\000000070C*)
(*@/// procedure TStringAlignGrid.SetAlignCell(ACol,ARow:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlignCell(ACol,ARow:integer; const Value: TMyAlign);
var
  v:^tmyalign;
begin
  FSaveAlignCell:=true;
  New(v);
  v^:=value;
  v:=SetItemCell(ACol,ARow, FAlignCell, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000201*)
(*@\\\0000000201*)
(*@/// Property read and write for AlignCol and FixedAlignCol *)
{ Property read and write for AlignCol and FixedAlignCol }
(*@/// function TStringAlignGrid.GetAlignCol(ACol:Integer):TMyAlign; *)
function TStringAlignGrid.GetAlignCol(ACol:Integer):TMyAlign;
var
  v:^tmyalign;
begin
  v:=GetItemCol(ACol, FAlignCol);
  if v=NIL then
    GetAlignCol:=Alignment
  else
    GetAlignCol:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetAlignCol(ACol:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlignCol(ACol:integer; const Value: TMyAlign);
var
  v:^tmyalign;
begin
  FSaveAlignCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FAlignCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFixAlignCol(ACol:Integer):TMyAlign; *)
function TStringAlignGrid.GetFixAlignCol(ACol:Integer):TMyAlign;
var
  v:^tmyalign;
begin
  v:=GetItemCol(ACol, FFAlignCol);
  if v=NIL then
    GetFixAlignCol:=Alignment
  else
    GetFixAlignCol:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFixAlignCol(ACol:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetFixAlignCol(ACol:integer; const Value: TMyAlign);
var
  v:^tmyalign;
begin
  FSaveFixedAlignCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FFAlignCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for AlignRow and FixedAlignRow *)
{ Property read and write for AlignRow and FixedAlignRow }
(*@/// function TStringAlignGrid.GetAlignRow(ARow:Integer):TMyAlign; *)
function TStringAlignGrid.GetAlignRow(ARow:Integer):TMyAlign;
var
  v:^tmyalign;
begin
  v:=GetItemCol(ARow, FAlignRow);
  if v=NIL then
    GetAlignRow:=Alignment
  else
    GetAlignRow:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetAlignRow(ARow:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlignRow(ARow:integer; const Value: TMyAlign);
var
  v:^tmyalign;
begin
  FSaveAlignRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FAlignRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFixAlignRow(ARow:Integer):TMyAlign; *)
function TStringAlignGrid.GetFixAlignRow(ARow:Integer):TMyAlign;
var
  v:^tmyalign;
begin
  v:=GetItemCol(ARow, FFAlignRow);
  if v=NIL then
    GetFixAlignRow:=Alignment
  else
    GetFixAlignRow:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFixAlignRow(ARow:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetFixAlignRow(ARow:integer; const Value: TMyAlign);
var
  v:^tmyalign;
begin
  FSaveFixedAlignRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FFAlignRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for FontCell *)
{ Property read and write for FontCell }
(*@/// function TStringAlignGrid.GetFontCell(ACol,ARow: integer):TFont; *)
function TStringAlignGrid.GetFontCell(ACol,ARow: integer):TFont;
begin
  GetFontCell:=GetFontCellInternal(ACol,ARow,true);
  end;
(*@\\\0000000323*)
(*@/// procedure TStringAlignGrid.SetFontCell(ACol,ARow: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontCell(ACol,ARow: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TMyFont.Create;
  TFont(v).Assign(value);
  TFont(v).OnChange:=FontChanged;
  TMyFont(v).HasChanged:=true;
  v:=SetItemCell(ACol,ARow, FFontCell, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000901*)
(*@\\\0000000201*)
(*@/// Property read and write for FontCol/FixedFontCol *)
{ Property read and write for FontCol/FixedFontCol }
(*@/// function TStringAlignGrid.GetFontCol(ACol: integer):TFont; *)
function TStringAlignGrid.GetFontCol(ACol: integer):TFont;
begin
  GetFontCol:=GetFontColRowInternal(ACol,true,FFontCol);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.SetFontCol(ACol: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontCol(ACol: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TMyFont.Create;
  TMyFont(v).Assign(value);
  TMyFont(v).OnChange:=FontChanged;
  TMyFont(v).HasChanged:=true;
  v:=SetItemCol(ACol, FFontCol, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000126*)
(*@/// function TStringAlignGrid.GetFontFixedCol(ACol: integer):TFont; *)
function TStringAlignGrid.GetFontFixedCol(ACol: integer):TFont;
begin
  GetFontFixedCol:=GetFontColRowInternal(ACol,true,FFFontCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFontFixedCol(ACol: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontFixedCol(ACol: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TMyFont.Create;
  TMyFont(v).Assign(value);
  TMyFont(v).OnChange:=FontChanged;
  TMyFont(v).HasChanged:=true;
  v:=SetItemCol(ACol, FFFontCol, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000706*)
(*@\\\0000000301*)
(*@/// Property read and write for FontRow/FixedFontRow *)
{ Property read and write for FontRow }
(*@/// function TStringAlignGrid.GetFontRow(ARow: integer):TFont; *)
function TStringAlignGrid.GetFontRow(ARow: integer):TFont;
begin
  GetFontRow:=GetFontColRowInternal(ARow,true,FFontRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFontRow(ARow: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontRow(ARow: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TMyFont.Create;
  TMyFont(v).Assign(value);
  TMyFont(v).OnChange:=FontChanged;
  TMyFont(v).HasChanged:=true;
  v:=SetItemCol(ARow, FFontRow, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000706*)
(*@/// function TStringAlignGrid.GetFontFixedRow(ARow: integer):TFont; *)
function TStringAlignGrid.GetFontFixedRow(ARow: integer):TFont;
begin
  GetFontFixedRow:=GetFontColRowInternal(ARow,true,FFFontRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFontFixedRow(ARow: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontFixedRow(ARow: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TMyFont.Create;
  TMyFont(v).Assign(value);
  TMyFont(v).OnChange:=FontChanged;
  TMyFont(v).HasChanged:=true;
  v:=SetItemCol(ARow, FFFontRow, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000706*)
(*@\\\0000000501*)
(*@/// Property read and write for HintCell *)
{ Property read and write for HintCell }
(*@/// function TStringAlignGrid.GetHintCell(ACol,ARow: integer):string; *)
function TStringAlignGrid.GetHintCell(ACol,ARow: integer):string;
var
  v:pstring;
begin
  v:=GetItemCell(ACol,ARow,FHintCell);
  if v=NIL then
    GetHintCell:=''
  else
    GetHintCell:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetHintCell(ACol,ARow: integer; const Value: string); *)
procedure TStringAlignGrid.SetHintCell(ACol,ARow: integer; const Value: string);
var
  v:pstring;
begin
  FSaveHint:=true;
  v:=NewStr(value);
  v:=SetItemCell(ACol,ARow, FHintCell, v);
  if v<>NIL then
    DisposeStr(v);
  end;
(*@\\\0000000901*)
(*@\\\0000000301*)
(*@/// Property read and write for ColorCell *)
{ Property read and write for ColorCell }
(*@/// function TStringAlignGrid.GetColorCell(ACol,ARow:Integer):TColor; *)
function TStringAlignGrid.GetColorCell(ACol,ARow:Integer):TColor;
var
  v:^TColor;
  fixed: boolean;
begin
  v:=GetItemCell(ACol,ARow,FColorCell);
  fixed:=is_fixed(ACol,ARow);
  if v=NIL then begin
    if fixed then
      v:=GetItemCol(ACol,FFColorCol)
    else
      v:=GetItemCol(ACol,FColorCol);
    if v=NIL then begin
      if fixed then
        v:=GetItemCol(ARow,FFColorRow)
      else
        v:=GetItemCol(ARow,FColorRow);
      if v=NIL then begin
        if fixed then
          result:=clBtnFace
        else
          result:=Color;
        end
      else
        result:=v^;
      end
    else
      result:=v^;
    end
  else
    result:=v^;
  end;
(*@\\\000000070C*)
(*@/// procedure TStringAlignGrid.SetColorCell(ACol,ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetColorCell(ACol,ARow:integer; const Value: TColor);
var
  v:^tColor;
begin
  FSaveColorCell:=true;
  New(v);
  v^:=value;
  v:=SetItemCell(ACol,ARow, FColorCell, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\0000000201*)
(*@/// Property read and write for ColorCol and FixedColorCol *)
{ Property read and write for ColorCol and FixedColorCol }
(*@/// function TStringAlignGrid.GetColorCol(ACol:Integer):TColor; *)
function TStringAlignGrid.GetColorCol(ACol:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ACol, FColorCol);
  if v=NIL then
    GetColorCol:=Color
  else
    GetColorCol:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetColorCol(ACol:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetColorCol(ACol:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveColorCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FColorCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFixColorCol(ACol:Integer):TColor; *)
function TStringAlignGrid.GetFixColorCol(ACol:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ACol, FFColorCol);
  if v=NIL then
    GetFixColorCol:=Color
  else
    GetFixColorCol:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFixColorCol(ACol:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetFixColorCol(ACol:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveFixedColorCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FFColorCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for ColorRow and FixedColorRow *)
{ Property read and write for ColorRow and FixedColorRow }
(*@/// function TStringAlignGrid.GetColorRow(ARow:Integer):TColor; *)
function TStringAlignGrid.GetColorRow(ARow:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ARow, FColorRow);
  if v=NIL then
    GetColorRow:=Color
  else
    GetColorRow:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetColorRow(ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetColorRow(ARow:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveColorRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FColorRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFixColorRow(ARow:Integer):TColor; *)
function TStringAlignGrid.GetFixColorRow(ARow:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ARow, FFColorRow);
  if v=NIL then
    GetFixColorRow:=Color
  else
    GetFixColorRow:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFixColorRow(ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetFixColorRow(ARow:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveFixedColorRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FFColorRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)

(*@/// procedure TStringAlignGrid.SetSelCellColor(Value: TColor); *)
procedure TStringAlignGrid.SetSelCellColor(Value: TColor);
begin
  f_SelCellColor:=value;
  invalidate;
  end;
(*@\\\0000000303*)
(*@/// procedure TStringAlignGrid.SetSelFontColor(Value: TColor); *)
procedure TStringAlignGrid.SetSelFontColor(Value: TColor);
begin
  f_SelFontColor:=value;
  invalidate;
  end;
(*@\\\0000000301*)


(*@/// Reset alignment and use the one defined a level above *)
{ Clear the respective alignment and use the one defined a level above }
(*@/// procedure TStringAlignGrid.ResetAlignCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetAlignCell(ACol,ARow:integer);
var
  v:^tmyalign;
begin
  v:=SetItemCell(ACol,ARow, FAlignCell, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetAlignCol(ACol:integer); *)
procedure TStringAlignGrid.ResetAlignCol(ACol:integer);
var
  v:^tmyalign;
begin
  v:=SetItemCol(ACol, FAlignCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetAlignFixedCol(ACol:integer); *)
procedure TStringAlignGrid.ResetAlignFixedCol(ACol:integer);
var
  v:^tmyalign;
begin
  v:=SetItemCol(ACol, FFAlignCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetAlignRow(ARow:integer); *)
procedure TStringAlignGrid.ResetAlignRow(ARow:integer);
var
  v:^tmyalign;
begin
  v:=SetItemCol(ARow, FAlignRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetAlignFixedRow(ARow:integer); *)
procedure TStringAlignGrid.ResetAlignFixedRow(ARow:integer);
var
  v:^tmyalign;
begin
  v:=SetItemCol(ARow, FFAlignRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetAlignment; *)
procedure TStringAlignGrid.ResetAlignment;
begin
  FAlign:=alLeft;
  Invalidate;
  end;
(*@\\\*)
(*@\\\000000021C*)
(*@/// Reset font and use the one defined a level above *)
{ Clear the respective font and use the one defined a level above }
(*@/// procedure TStringAlignGrid.ResetFontCol(ACol:integer); *)
procedure TStringAlignGrid.ResetFontCol(ACol:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ACol, FFontCol, NIL);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetFontFixedCol(ACol:integer); *)
procedure TStringAlignGrid.ResetFontFixedCol(ACol:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ACol, FFFontCol, NIL);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetFontRow(ARow:integer); *)
procedure TStringAlignGrid.ResetFontRow(ARow:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ARow, FFontRow, NIL);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetFontFixedRow(ARow:integer); *)
procedure TStringAlignGrid.ResetFontFixedRow(ARow:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ARow, FFFontRow, NIL);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetFontCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetFontCell(ACol,ARow:integer);
var
  v:pointer;
begin
  v:=SetItemCell(ACol,ARow, FFontCell, NIL);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Reset color and use the one defined a level above *)
{ Clear the respective colors and use the one defined a level above }
(*@/// procedure TStringAlignGrid.ResetColorCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetColorCell(ACol,ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCell(ACol,ARow, FColorCell, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorCol(ACol:integer); *)
procedure TStringAlignGrid.ResetColorCol(ACol:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ACol, FColorCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorFixedCol(ACol:integer); *)
procedure TStringAlignGrid.ResetColorFixedCol(ACol:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ACol, FFColorCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorRow(ARow:integer); *)
procedure TStringAlignGrid.ResetColorRow(ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ARow, FColorRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorFixedRow(ARow:integer); *)
procedure TStringAlignGrid.ResetColorFixedRow(ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ARow, FFColorRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)

(*@/// Insertion, removing and moving of Rows and Columns *)
{ Insertion and removing of Rows and Columns }
(*@/// procedure TStringAlignGrid.RemoveCol(ACol:Integer); *)
procedure TStringAlignGrid.RemoveCol(ACol:Integer);
var
  v:^tmyalign;
  w:^TColor;
  x:pointer;
  i:integer;
begin
  if (ACol<FixedCols) or (ACol>=Colcount) then EXIT;
     (* can't remove a fixed column *)
(*@///   AlignCol/Cell *)
if FAlignCol.Count>=ACol then begin
  v:=SetItemCol(ACol,FAlignCol,NIL);
  if v<>NIL then
    dispose(v);
  FAlignCol.Delete(ACol);
  end;
if FFAlignCol.Count>=ACol then begin
  v:=SetItemCol(ACol,FFAlignCol,NIL);
  if v<>NIL then
    dispose(v);
  FFAlignCol.Delete(ACol);
  end;
if FAlignCell.Count>=ACol then begin
  cleanlist(TList(FAlignCell.Items[ACol]),sizeof(TMyAlign));
  FAlignCell.Delete(ACol);
  end;
(*@\\\0000001007*)
(*@///   ColorCol/Cell *)
if FColorCol.Count>=ACol then begin
  w:=SetItemCol(ACol,FColorCol,NIL);
  if w<>NIL then
    dispose(w);
  FColorCol.Delete(ACol);
  end;
if FFColorCol.Count>=ACol then begin
  w:=SetItemCol(ACol,FFColorCol,NIL);
  if w<>NIL then
    dispose(w);
  FFColorCol.Delete(ACol);
  end;
if FColorCell.Count>=ACol then begin
  cleanlist(TList(FColorCell.Items[ACol]),sizeof(TColor));
  FColorCell.Delete(ACol);
  end;
(*@\\\0000000F01*)
(*@///   FontCol/Cell *)
if FFontCol.Count>=ACol then begin
  x:=SetItemCol(ACol,FFontCol,NIL);
  if x<>NIL then
    TMyFont(x).free;
  FFontCol.Delete(ACol);
  end;
if FFFontCol.Count>=ACol then begin
  x:=SetItemCol(ACol,FFFontCol,NIL);
  if x<>NIL then
    TMyFont(x).free;
  FFFontCol.Delete(ACol);
  end;
if FFontCell.Count>=ACol then begin
  cleanlist_object(TList(FFontCell.Items[ACol]));
  FFontCell.Delete(ACol);
  end;
(*@\\\*)
(*@///   HintCell *)
if FHintCell.Count>=ACol then begin
  cleanlist_pstring(TList(FHintCell.Items[ACol]));
  FHintCell.Delete(ACol);
  end;
(*@\\\*)
(*@///   Cell *)
for i:=ACol to ColCount-1 do
  self.Cols[i].Assign(self.Cols[i+1]);
(*@\\\0000000202*)
  colcount:=colcount-1;
  invalidate;
  end;
(*@\\\0000000201*)
(*@/// procedure TStringAlignGrid.RemoveRow(ARow:Integer); *)
procedure TStringAlignGrid.RemoveRow(ARow:Integer);
var
  v:^tmyalign;
  w:^TColor;
  x:pointer;
  y:pstring;
  l:TList;
  i:integer;
begin
  if (ARow<FixedRows) or (ARow>=Rowcount) then EXIT;
     (* can't remove a fixed row *)
(*@///   AlignRow/Cell *)
if FAlignRow.Count>=ARow then begin
  v:=SetItemCol(ARow,FAlignRow,NIL);
  if v<>NIL then
    dispose(v);
  FAlignRow.Delete(ARow);
  end;
if FFAlignRow.Count>=ARow then begin
  v:=SetItemCol(ARow,FFAlignRow,NIL);
  if v<>NIL then
    dispose(v);
  FFAlignRow.Delete(ARow);
  end;
for i:=0 to FAlignCell.Count-1 do begin
  l:=TList(FAlignCell.Items[i]);
  if l.Count>=ARow then begin
    v:=SetItemCol(ARow,l,NIL);
    if v<>NIL then
      dispose(v);
    l.Delete(ARow);
    end;
  end;
(*@\\\0000001501*)
(*@///   ColorRow/Cell *)
if FColorRow.Count>=ARow then begin
  w:=SetItemCol(ARow,FColorRow,NIL);
  if w<>NIL then
    dispose(w);
  FColorRow.Delete(ARow);
  end;
if FFColorRow.Count>=ARow then begin
  w:=SetItemCol(ARow,FFColorRow,NIL);
  if w<>NIL then
    dispose(w);
  FFColorRow.Delete(ARow);
  end;
for i:=0 to FColorCell.Count-1 do begin
  l:=TList(FColorCell.Items[i]);
  if l.Count>=ARow then begin
    w:=SetItemCol(ARow,l,NIL);
    if w<>NIL then
      dispose(w);
    l.Delete(ARow);
    end;
  end;
(*@\\\*)
(*@///   FontRow/Cell *)
if FFontRow.Count>=ARow then begin
  x:=SetItemCol(ARow,FFontRow,NIL);
  if x<>NIL then
    TMyFont(x).free;
  FFontRow.Delete(ARow);
  end;
if FFFontRow.Count>=ARow then begin
  x:=SetItemCol(ARow,FFFontRow,NIL);
  if x<>NIL then
    TMyFont(x).free;
  FFFontRow.Delete(ARow);
  end;
for i:=0 to FFontCell.Count-1 do begin
  l:=TList(FFontCell.Items[i]);
  if l.Count>=ARow then begin
    x:=SetItemCol(ARow,l,NIL);
    if x<>NIL then
      TMyFont(x).free;
    l.Delete(ARow);
    end;
  end;
(*@\\\0000000D01*)
(*@///   HintCell *)
for i:=0 to FHintCell.Count-1 do begin
  l:=TList(FHintCell.Items[i]);
  if l.Count>=ARow then begin
    y:=SetItemCol(ARow,l,NIL);
    if y<>NIL then
      DisposeStr(y);
    l.Delete(ARow);
    end;
  end;
(*@\\\*)
(*@///   Cell *)
for i:=ARow to RowCount-1 do
  self.Rows[i].Assign(self.Rows[i+1]);
(*@\\\0000000202*)
  rowcount:=rowcount-1;
  invalidate;
  end;
(*@\\\0000000E01*)

(*@/// procedure TStringAlignGrid.InsertCol(ACol:Integer); *)
procedure TStringAlignGrid.InsertCol(ACol:Integer);
var
  i: integer;
begin
  if (ACol<FixedCols) then ACol:=FixedCols;
  ColCount:=ColCount+1;
(*@///   AlignCol/Cell *)
if FAlignCol.Count>=ACol then
  FAlignCol.Insert(ACol,NIL);
if FFAlignCol.Count>=ACol then
  FFAlignCol.Insert(ACol,NIL);
if FAlignCell.Count>=ACol then
  FAlignCell.Insert(ACol,NIL);
(*@\\\0000000201*)
(*@///   ColorCol/Cell *)
if FColorCol.Count>=ACol then
  FColorCol.Insert(ACol,NIL);
if FFColorCol.Count>=ACol then
  FFColorCol.Insert(ACol,NIL);
if FColorCell.Count>=ACol then
  FColorCell.Insert(ACol,NIL);
(*@\\\*)
(*@///   FontCol/Cell *)
if FFontCol.Count>=ACol then
  FFontCol.Insert(ACol,NIL);
if FFFontCol.Count>=ACol then
  FFFontCol.Insert(ACol,NIL);
if FFontCell.Count>=ACol then
  FFontCell.Insert(ACol,NIL);
(*@\\\0000000501*)
(*@///   HintCell *)
if FHintCell.Count>=ACol then
  FHintCell.Insert(ACol,NIL);
(*@\\\*)
(*@///   Cell *)
for i:=ColCount downto ACol+1 do
  self.Cols[i].Assign(self.Cols[i-1]);
self.Cols[ACol].Clear;
(*@\\\0000000301*)
  invalidate;
  end;
(*@\\\0000000701*)
(*@/// procedure TStringAlignGrid.InsertRow(ARow:Integer); *)
procedure TStringAlignGrid.InsertRow(ARow:Integer);
var
  i: integer;
  l: TList;
begin
  if (ARow<FixedRows) then ARow:=FixedRows;
  rowcount:=rowcount+1;
(*@///   AlignRow/Cell *)
if FAlignRow.Count>=ARow then
  FAlignRow.Insert(ARow,NIL);
if FFAlignRow.Count>=ARow then
  FFAlignRow.Insert(ARow,NIL);
for i:=0 to FAlignCell.Count-1 do begin
  l:=TList(FAlignCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\0000000501*)
(*@///   ColorRow/Cell *)
if FColorRow.Count>=ARow then
  FColorRow.Insert(ARow,NIL);
if FFColorRow.Count>=ARow then
  FFColorRow.Insert(ARow,NIL);
for i:=0 to FColorCell.Count-1 do begin
  l:=TList(FColorCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\*)
(*@///   FontRow/Cell *)
if FFontRow.Count>=ARow then
  FFontRow.Insert(ARow,NIL);
if FFFontRow.Count>=ARow then
  FFFontRow.Insert(ARow,NIL);
for i:=0 to FFontCell.Count-1 do begin
  l:=TList(FFontCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\*)
(*@///   HintCell *)
for i:=0 to FHintCell.Count-1 do begin
  l:=TList(FHintCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\0000000607*)
(*@///   Cell *)
for i:=RowCount downto ARow+1 do
  self.Rows[i].Assign(self.Rows[i-1]);
self.Rows[ARow].Clear;
(*@\\\0000000301*)
  invalidate;
  end;
(*@\\\0000000801*)

(*@/// procedure TStringAlignGrid.RowMoved(FromIndex, ToIndex: Longint); *)
procedure TStringAlignGrid.RowMoved(FromIndex, ToIndex: Longint);
begin
(*@///   AlignRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FAlignRow);
MoveItemCol(FromIndex,ToIndex,FFAlignRow);
MoveItemColRow(FromIndex,ToIndex,FAlignCell);
(*@\\\*)
(*@///   ColorRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FColorRow);
MoveItemCol(FromIndex,ToIndex,FFColorRow);
MoveItemColRow(FromIndex,ToIndex,FColorCell);
(*@\\\*)
(*@///   FontRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FFontRow);
MoveItemCol(FromIndex,ToIndex,FFFontRow);
MoveItemColRow(FromIndex,ToIndex,FFontCell);
(*@\\\*)
(*@///   HintCell *)
MoveItemColRow(FromIndex,ToIndex,FHintCell);
(*@\\\*)
  inherited RowMoved(FromIndex, ToIndex);
  end;
(*@\\\0000000501*)
(*@/// procedure TStringAlignGrid.ColumnMoved(FromIndex, ToIndex: Longint); *)
procedure TStringAlignGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
(*@///   AlignCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FAlignCol);
MoveItemCol(FromIndex,ToIndex,FFAlignCol);
MoveItemCol(FromIndex,ToIndex,FAlignCell);
(*@\\\*)
(*@///   ColorCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FColorCol);
MoveItemCol(FromIndex,ToIndex,FFColorCol);
MoveItemCol(FromIndex,ToIndex,FColorCell);
(*@\\\*)
(*@///   FontCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FFontCol);
MoveItemCol(FromIndex,ToIndex,FFFontCol);
MoveItemCol(FromIndex,ToIndex,FFontCell);
(*@\\\*)
(*@///   HintCell *)
MoveItemCol(FromIndex,ToIndex,FHintCell);
(*@\\\*)
  invalidate;
  inherited ColumnMoved(FromIndex, ToIndex);
  end;
(*@\\\0000000603*)
(*@\\\0000000901*)

(*@/// Utility methods for the fonts *)
(*@/// function TStringAlignGrid.GetFontColRowInternal(AColRow: integer; create:boolean; List:TList):TFont; *)
function TStringAlignGrid.GetFontColRowInternal(AColRow: integer; create:boolean; List:TList):TFont;
var
  v: Pointer;
begin
  v:=GetItemCol(AColRow,List);
  if (v=NIL) then begin
    if create then begin
      v:=TMyFont.Create;
      TMyFont(v).Assign(self.font);
      TMyFont(v).OnChange:=FontChanged;
      SetItemCol(AColRow, List, v);
      end
    else v:=self.Font;
    end;
  GetFontColRowInternal:=TFont(v);
  end;
(*@\\\0000000B01*)
(*@/// function TStringAlignGrid.GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont; *)
function TStringAlignGrid.GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont;
var
  v: Pointer;
begin
  v:=GetItemCell(ACol,ARow,FFontCell);
  if (v=NIL) then begin
    if create then begin
      v:=TMyFont.Create;
      TMyFont(v).Assign(self.font);
      TMyFont(v).OnChange:=FontChanged;
      SetItemCell(ACol,ARow, FFontCell, v);
      end
    else v:=self.Font;
    end;
  GetFontCellInternal:=TFont(v);
  end;
(*@\\\*)

{ The Font for the Cell through all levels (Cell, Col, Row, Grid) }
(*@/// function TStringAlignGrid.GetFontCellComplete(ACol,ARow: integer):TFont; *)
function TStringAlignGrid.GetFontCellComplete(ACol,ARow: integer):TFont;
var
  v: Pointer;
  fixed: boolean;
begin
  v:=GetItemCell(ACol,ARow,FFontCell);
  fixed:=is_fixed(ACol,ARow);
  if (v=NIL) then begin
    if fixed then
      v:=GetItemCol(ACol,FFFontCol)
    else
      v:=GetItemCol(ACol,FFontCol);
    if v=NIL then begin
      if fixed then
        v:=GetItemCol(ARow,FFFontRow)
      else
        v:=GetItemCol(ARow,FFontRow);
      if v=NIL then
        v:=self.font;
      end;
    end;
  GetFontCellComplete:=TFont(v);
  end;
(*@\\\000000011B*)

{ A callback to be sure the displayed font is the same as the internal }
(*@/// procedure TStringAlignGrid.FontChanged(AFont: TObject); *)
procedure TStringAlignGrid.FontChanged(AFont: TObject);
begin
  invalidate;
  end;
(*@\\\0000000301*)
(*@\\\*)
(*@/// Utility methods for the cell-specific hints *)
{ The utility methods for the cell-specific hints }
(*@/// procedure TStringAlignGrid.ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo); *)
procedure TStringAlignGrid.ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
  col,row:longint;
  HintPos:TRect;
begin
  if (hintinfo.hintcontrol=self) and FShowCellHints then begin
    self.mousetocell(hintinfo.cursorpos.x,hintinfo.cursorpos.y,col,row);
    FHintCellLast:=Point(col,row);
    hintpos:=self.Cellrect(col,row);
    hintinfo.hintpos.x:=hintpos.left;
    hintinfo.hintpos.y:=hintpos.bottom+6;
    hintinfo.hintpos:=self.clienttoscreen(hintinfo.hintpos);
    hintstr:=HintCell[col,row];
    end;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.MouseMove(Shift: TShiftState; X, Y: Integer); *)
procedure TStringAlignGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  col,row: longint;
begin
  if (FHintCellLast.x>=0) and (FHintCellLast.y>=0) then begin
    self.mousetocell(x,y,col,row);
    if (col<>FHintCellLast.x) or (row<>FHintCellLast.y) then begin
      Application.CancelHint;
      FHintCellLast:=Point(-1,-1);
      end;
    end;
  inherited MouseMove(Shift, X, Y);
  end;
(*@\\\*)
(*@\\\*)
(*@/// The Inplace-Editor which also gets the alignment, font and color *)
{ The Inplace-Editor which also gets the alignment, font and color -
  got the idea from James Sager's (jsager@ao.net) TIEAlignStringGrid -
  see UNDU #19 (http://www.informant.com/undu) }
(*@/// function TStringAlignGrid.CreateEditor: TInplaceEdit; *)
function TStringAlignGrid.CreateEditor: TInplaceEdit;
begin
  Result := TNewInplaceEdit.Create(Self);
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.CanEditShow: Boolean; *)
function TStringAlignGrid.CanEditShow: Boolean;
begin
  Result := inherited CanEditShow;
  if (InplaceEditor <> nil) and Result then
    if InplaceEditor is TNewInplaceEdit then begin
      TNewInplaceEdit(InplaceEditor).Alignment:=GetAlignCell(Col,Row);
      TNewInplaceEdit(InplaceEditor).Font:=GetFontCellComplete(Col,Row);
      TNewInplaceEdit(InplaceEditor).Color:=ColorCell[Col,Row];
{       TNewInplaceEdit(InplaceEditor).Passwordchar:='*'; }
      end;
  end;
(*@\\\0000000A01*)
(*@\\\0000000501*)
(*@/// The stuff for reading and writing the data from/to the DFM file *)
{ The stuff for reading and writing the data from/to the DFM file }

(*@/// procedure TStringAlignGrid.DefineProperties(Filer: TFiler); *)
procedure TStringAlignGrid.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('AlignCell', ReadAlignCell, WriteAlignCell, FSaveAlignCell);
  Filer.DefineBinaryProperty('AlignCol', ReadAlignCol, WriteAlignCol, FSaveAlignCol);
  Filer.DefineBinaryProperty('FixedAlignCol', ReadFixedAlignCol, WriteFixedAlignCol, FSaveFixedAlignCol);
  Filer.DefineBinaryProperty('AlignRow', ReadAlignRow, WriteAlignRow, FSaveAlignRow);
  Filer.DefineBinaryProperty('FixedAlignRow', ReadFixedAlignRow, WriteFixedAlignRow, FSaveFixedAlignRow);
  Filer.DefineProperty('HintCell', ReadHint, WriteHint, FSaveHint);
  Filer.DefineProperty('Cells', ReadCells, WriteCells, FSaveCells);
  Filer.DefineProperty('FontCell', ReadFontCell, WriteFontCell, FSaveFontCell);
  Filer.DefineProperty('FontCol', ReadFontCol, WriteFontCol, FSaveFontCol);
  Filer.DefineProperty('FontFixedCol', ReadFixedFontCol, WriteFixedFontCol, FSaveFixedFontCol);
  Filer.DefineProperty('FontRow', ReadFontRow, WriteFontRow, FSaveFontRow);
  Filer.DefineProperty('FontFixedRow', ReadFixedFontRow, WriteFixedFontRow, FSaveFixedFontRow);
  Filer.DefineProperty('ColorCell', ReadColorCell, WriteColorCell, FSaveColorCell);
  Filer.DefineProperty('ColorCol', ReadColorCol, WriteColorCol, FSaveColorCol);
  Filer.DefineProperty('ColorFixedCol', ReadFixedColorCol, WriteFixedColorCol, FSaveFixedColorCol);
  Filer.DefineProperty('ColorRow', ReadColorRow, WriteColorRow, FSaveColorRow);
  Filer.DefineProperty('ColorFixedRow', ReadFixedColorRow, WriteFixedColorRow, FSaveFixedColorRow);
  end;
(*@\\\0000001201*)
(*@/// procedure TStringAlignGrid.Loaded; *)
procedure TStringAlignGrid.Loaded;
{ Fill the cell list into the original cells property after loading;
  if in designing mode hold the internal list for the later writing }
var
  i: integer;
begin
  inherited Loaded;
  ListToCells(FCell);
  if not (csDesigning in ComponentState) then begin
(*@///     FCell.Free; *)
for i:=0 to FCell.Count-1 do
  cleanlist_pstring(TList(FCell.Items[i]));
FCell.Free;
FCell:=NIL;
(*@\\\*)
    end;
  end;
(*@\\\*)

(*@/// Read and write several alignment lists to the DFM *)
{ All the routines for the several alignment lists }
(*@/// procedure TStringAlignGrid.ReadAlignCell(Stream: TStream); *)
procedure TStringAlignGrid.ReadAlignCell(Stream: TStream);
var
  ACol,ARow: word;
  p:^tmyalign;
begin
  Stream.Seek(0,0);
  while Stream.Position<Stream.Size do begin
    New(p);
    Stream.Read(ACol,sizeof(word));
    Stream.Read(ARow,sizeof(word));
    Stream.Read(p^,sizeof(TMyAlign));
    p:=SetItemCell(ACol,ARow,FAlignCell,p);
    FSaveAlignCell:=true;
    if p<>NIL then
      dispose(p);
    end;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteAlignCell(Stream: TStream); *)
procedure TStringAlignGrid.WriteAlignCell(Stream: TStream);
var
  ACol,ARow: word;
  p:^tmyalign;
begin
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      p:=GetItemCell(ACol,ARow,FAlignCell);
      if p<>NIL then begin
        Stream.Write(ACol,sizeof(word));
        Stream.Write(ARow,sizeof(word));
        Stream.Write(p^,sizeof(TMyAlign));
        end;
      end;
    end;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.ReadAlignCol(Stream: TStream);
begin
  FSaveAlignCol:=ReadAlignColRow(Stream,FAlignCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.ReadFixedAlignCol(Stream: TStream);
begin
  FSaveFixedAlignCol:=ReadAlignColRow(Stream,FFAlignCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.ReadAlignRow(Stream: TStream);
begin
  FSaveAlignRow:=ReadAlignColRow(Stream,FAlignRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.ReadFixedAlignRow(Stream: TStream);
begin
  FSaveFixedAlignRow:=ReadAlignColRow(Stream,FFAlignRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.WriteAlignCol(Stream: TStream);
begin
  WriteAlignColRow(Stream, ColCount-1, FAlignCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.WriteFixedAlignCol(Stream: TStream);
begin
  WriteAlignColRow(Stream, ColCount-1, FFAlignCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.WriteAlignRow(Stream: TStream);
begin
  WriteAlignColRow(Stream, RowCount-1, FAlignRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.WriteFixedAlignRow(Stream: TStream);
begin
  WriteAlignColRow(Stream, RowCount-1, FFAlignRow);
  end;
(*@\\\*)

{ All the ReadCol, ReadRow are so similar, so these to routines are there
  to avoid code-copy }
(*@/// function TStringAlignGrid.ReadAlignColRow(Stream: TStream; list:TList):boolean; *)
function TStringAlignGrid.ReadAlignColRow(Stream: TStream; List:TList):boolean;
var
  AColRow: word;
  p:^tmyalign;
begin
  result:=false;
  Stream.Seek(0,0);
  while Stream.Position<Stream.Size do begin
    New(p);
    Stream.Read(AColRow,sizeof(word));
    Stream.Read(p^,sizeof(TMyAlign));
    p:=SetItemCol(AColRow,List,p);
    result:=true;
    if p<>NIL then
      dispose(p);
    end;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteAlignColRow(Stream: TStream; count: integer; list:TList); *)
procedure TStringAlignGrid.WriteAlignColRow(Stream: TStream; count: integer; list:TList);
var
  AColRow: word;
  p:^tmyalign;
begin
  for AColRow:=0 to Count do begin
    p:=GetItemCol(AColRow,List);
    if p<>NIL then begin
      Stream.Write(AColRow,sizeof(word));
      Stream.Write(p^,sizeof(TMyAlign));
      end;
    end;
  end;
(*@\\\*)
(*@\\\0000000201*)
(*@/// Read and write the hint strings to the DFM *)
{ The hint and the cell strings }
(*@/// procedure TStringAlignGrid.ReadHint(Reader: TReader); *)
procedure TStringAlignGrid.ReadHint(Reader: TReader);
var
  ACol,ARow: word;
  v:pstring;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    v:=NewStr(Reader.ReadString);
    v:=SetItemCell(ACol,ARow, FHintCell, v);
    FSaveHint:=true;
    if v<>NIL then
      DisposeStr(v);
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteHint(Writer: TWriter); *)
procedure TStringAlignGrid.WriteHint(Writer: TWriter);
var
  v:pstring;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      v:=GetItemCell(ACol,ARow,FHintCell);
      if v<>NIL then begin
        Writer.WriteInteger(ACol);
        Writer.WriteInteger(ARow);
        Writer.WriteString(v^);
        end;
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)
(*@\\\0000000301*)
(*@/// Read and write the cell strings to the DFM *)
(*@/// procedure TStringAlignGrid.ReadCells(Reader: TReader); *)
procedure TStringAlignGrid.ReadCells(Reader: TReader);
var
  ACol,ARow: word;
  v:pstring;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    v:=NewStr(Reader.ReadString);
    v:=SetItemCell(ACol,ARow, FCell, v);
    FSaveCells:=true;
    if v<>NIL then
      DisposeStr(v);
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteCells(Writer: TWriter); *)
procedure TStringAlignGrid.WriteCells(Writer: TWriter);
var
  v:string;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      v:=Cells[ACol,ARow];
      if v<>'' then begin
        Writer.WriteInteger(ACol);
        Writer.WriteInteger(ARow);
        Writer.WriteString(v);
        end;
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)

{ To convert TStringGrid's own Cell property to my list and vice versa }
(*@/// procedure TStringAlignGrid.ListToCells(List:TList); *)
procedure TStringAlignGrid.ListToCells(List:TList);
var
  v:pstring;
  ACol, ARow: integer;
begin
  for ACol:=0 to ColCount-1 do
    for ARow:=0 to RowCount-1 do begin
      v:=GetItemCell(ACol,ARow,List);
      if v<>NIL then
        Cells[ACol,ARow]:=v^
      else
        Cells[ACol,ARow]:='';
      end;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.CellsToList(var List:TList); *)
procedure TStringAlignGrid.CellsToList(var List:TList);
var
  v:pstring;
  ACol, ARow: integer;
begin
  for ACol:=0 to ColCount-1 do
    for ARow:=0 to RowCount-1 do begin
      if cells[ACol,ARow]<>'' then begin
        v:=NewStr(cells[ACol,ARow]);
        end
      else
        v:=NIL;
      v:=SetItemCell(ACol,ARow, List, v);
      if v<>NIL then
        DisposeStr(v);
    end;
  end;
(*@\\\*)
(*@\\\0000000201*)
(*@/// Read and write several font lists to the DFM *)
{ All the routines for the different font lists }
(*@/// procedure TStringAlignGrid.ReadFontCell(Reader: TReader); *)
procedure TStringAlignGrid.ReadFontCell(Reader: TReader);
var
  ACol,ARow: word;
  v:pointer;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    v:=ReadFont(Reader);
    v:=SetItemCell(ACol,ARow, FFontCell, v);
    FSaveFontCell:=true;
    if v<>NIL then
      TFont(v).free;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFontCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadFontCol(Reader: TReader);
begin
  FSaveFontCol:=ReadFontColRow(Reader,FFontCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFontRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadFontRow(Reader: TReader);
begin
  FSaveFontRow:=ReadFontColRow(Reader,FFontRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedFontCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedFontCol(Reader: TReader);
begin
  FSaveFixedFontCol:=ReadFontColRow(Reader,FFFontCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedFontRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedFontRow(Reader: TReader);
begin
  FSaveFixedFontRow:=ReadFontColRow(Reader,FFFontRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFontCell(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFontCell(Writer: TWriter);
var
  v:pointer;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      v:=GetItemCell(ACol,ARow,FFontCell);
      if (v<>NIL) and TMyFont(v).HasChanged then begin
        Writer.WriteInteger(ACol);
        Writer.WriteInteger(ARow);
        WriteFont(Writer,TFont(v));
        end;
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFontCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFontCol(Writer: TWriter);
begin
  WriteFontColRow(Writer, ColCount-1, FFontCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFontRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFontRow(Writer: TWriter);
begin
  WriteFontColRow(Writer, RowCount-1, FFontRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedFontCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFixedFontCol(Writer: TWriter);
begin
  WriteFontColRow(Writer, ColCount-1, FFFontCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedFontRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFixedFontRow(Writer: TWriter);
begin
  WriteFontColRow(Writer, RowCount-1, FFFontRow);
  end;
(*@\\\*)

{ All the ReadCol, ReadRow are so similar, so these to routines are there
  to avoid code-copy }
(*@/// function TStringAlignGrid.ReadFontColRow(Reader:TReader; list:TList):boolean; *)
function TStringAlignGrid.ReadFontColRow(Reader:TReader; list:TList):boolean;
var
  AColRow: word;
  v: pointer;
begin
  result:=false;
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    AColRow:=Reader.ReadInteger;
    v:=ReadFont(Reader);
    v:=SetItemCol(AColRow, list, v);
    result:=true;
    if v<>NIL then
      TFont(v).free;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFontColRow(Writer:TWriter; count:integer; list:TList); *)
procedure TStringAlignGrid.WriteFontColRow(Writer:TWriter; count:integer; list:TList);
var
  AColRow: word;
  v: pointer;
begin
  Writer.WriteListBegin;
  for AColRow:=0 to Count do begin
    v:=GetItemCol(AColRow,List);
    if (v<>NIL) and TMyFont(v).HasChanged then begin
      Writer.WriteInteger(AColRow);
      WriteFont(Writer,TFont(v));
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)

{ Writing and reading a single font entry }
(*@/// procedure TStringAlignGrid.WriteFont(Writer: TWriter; v:TFont); *)
procedure TStringAlignGrid.WriteFont(Writer: TWriter; v:TFont);
var
  t: TFontStyles;
begin

(* I HATE Borland - here a simple Writer.WriteProperties() would do, but these
   idiots have made this method private and only the trivial ones are public.
   They invent such powerfull mechanisms to access properties at design time
   and then they destroy any way to use these for advanced components :-(
   So I have to write every property and not only those that are changed
   from the default, and I have to do the assumption that they won't change
   the TFontStyles and TFontPitch types as that would run this into great
   problems. And of course what to do with a beast like a TButton instead of
   a TFont - then the mechanism below won't be enough.
   So anyone knowing a better way to do it is greatly welcome! *)

  Writer.WriteInteger(v.Color);
  Writer.WriteInteger(v.height);
  Writer.WriteString(v.name);
(* WriteEnum is missing, have to write as an integer *)
  Writer.WriteInteger(cardinal(v.Pitch));
(* The WriteSet is also missing, again only savable as an integer *)
  t:=v.Style;
(* and why can't I cast a set to an integer directly ? *)
  Writer.WriteInteger(cardinal((@t)^));
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.ReadFont(Reader: TReader):TFont; *)
function TStringAlignGrid.ReadFont(Reader: TReader):TFont;
var
  t: integer;
begin
(* The same work-around as in WriteFont *)
  result:=TFont.Create;
  result.Color:=Reader.ReadInteger;
  result.height:=Reader.ReadInteger;
  result.name:=Reader.ReadString;
  result.pitch:=TFontPitch(Reader.ReadInteger);
  t:=reader.readinteger;
  result.style:=TFontStyles((@t)^);
  end;
(*@\\\*)
(*@\\\0000000301*)
(*@/// Read and write several color lists to the DFM *)
{ All the routines for the different Color lists }
(*@/// procedure TStringAlignGrid.ReadColorCell(Reader: TReader); *)
procedure TStringAlignGrid.ReadColorCell(Reader: TReader);
var
  ACol,ARow: word;
  v:^TColor;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    new(v);
    v^:=Reader.ReadInteger;
    v:=SetItemCell(ACol,ARow, FColorCell, v);
    FSaveColorCell:=true;
    if v<>NIL then
      dispose(v);
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadColorCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadColorCol(Reader: TReader);
begin
  FSaveColorCol:=ReadColorColRow(Reader,FColorCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadColorRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadColorRow(Reader: TReader);
begin
  FSaveColorRow:=ReadColorColRow(Reader,FColorRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedColorCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedColorCol(Reader: TReader);
begin
  FSaveFixedColorCol:=ReadColorColRow(Reader,FFColorCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedColorRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedColorRow(Reader: TReader);
begin
  FSaveFixedColorRow:=ReadColorColRow(Reader,FFColorRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteColorCell(Writer: TWriter); *)
procedure TStringAlignGrid.WriteColorCell(Writer: TWriter);
var
  v:^TColor;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      v:=GetItemCell(ACol,ARow,FColorCell);
      if (v<>NIL) then begin
        Writer.WriteInteger(ACol);
        Writer.WriteInteger(ARow);
        Writer.WriteInteger(v^);
        end;
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteColorCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteColorCol(Writer: TWriter);
begin
  WriteColorColRow(Writer, ColCount-1, FColorCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteColorRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteColorRow(Writer: TWriter);
begin
  WriteColorColRow(Writer, RowCount-1, FColorRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedColorCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFixedColorCol(Writer: TWriter);
begin
  WriteColorColRow(Writer, ColCount-1, FFColorCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedColorRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFixedColorRow(Writer: TWriter);
begin
  WriteColorColRow(Writer, RowCount-1, FFColorRow);
  end;
(*@\\\*)

{ All the ReadCol, ReadRow are so similar, so these to routines are there
  to avoid code-copy }
(*@/// function TStringAlignGrid.ReadColorColRow(Reader:TReader; list:TList):boolean; *)
function TStringAlignGrid.ReadColorColRow(Reader:TReader; list:TList):boolean;
var
  AColRow: word;
  v: ^TColor;
begin
  result:=false;
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    AColRow:=Reader.ReadInteger;
    new(v);
    v^:=Reader.ReadInteger;
    v:=SetItemCol(AColRow, list, v);
    result:=true;
    if v<>NIL then
      dispose(v);
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteColorColRow(Writer:TWriter; count:integer; list:TList); *)
procedure TStringAlignGrid.WriteColorColRow(Writer:TWriter; count:integer; list:TList);
var
  AColRow: word;
  v: ^TColor;
begin
  Writer.WriteListBegin;
  for AColRow:=0 to Count do begin
    v:=GetItemCol(AColRow,List);
    if (v<>NIL) then begin
      Writer.WriteInteger(AColRow);
      Writer.WriteInteger(v^);
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)
(*@\\\0000000801*)
(*@\\\0000000A01*)

{ The real action procedure - the draw of a cell, is called from the Paint
  Method of TCustomGrid }
(*@/// procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; *)
procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
(*@/// procedure DrawCellText; *)
procedure DrawCellText;
var
  Text: array[0..255] of char;
  l: integer;
  Left: integer;
  AlignValue: TMyAlign;
begin
  self.canvas.font:=GetFontCellComplete(ACol,ARow);

  if gdSelected in AState then begin
    self.canvas.brush.color:=f_SelCellColor;
    self.canvas.font.color:=f_SelFontColor;
    end
{   else if (gdFixed in AState) or is_fixed(ACol,ARow) then }
{     self.canvas.brush.color:=FixedColor }
  else
    self.canvas.brush.color:=ColorCell[ACol,ARow];
  self.canvas.fillrect(ARect);

  StrPCopy(Text, Cells[ACol, ARow]);
  l:=Canvas.TextWidth(Cells[ACol, ARow]);

{ if nothing is set use left bounding }
  Left:=ARect.Left;

  { AlignCell follows the logic: 1. Cell, 2. Col, 3. Row, 4. Global }
  AlignValue:=AlignCell[ACol,ARow];

  if AlignValue in [alCenter] then begin
    l:=( (Arect.Right-ARect.Left)-l ) div 2;
    Left:=ARect.Left+l-1;
    end;
  if AlignValue in [alRight] then
    Left:=ARect.Right-l-4;
  ExtTextOut(Canvas.Handle, Left+2, Arect.Top+2,  ETO_CLIPPED or
    ETO_OPAQUE, @Arect, Text, StrLen(Text), nil);
  end;
(*@\\\0000000B18*)
begin
  if DefaultDrawing then
    DrawCellText
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
  end;
(*@\\\0000000301*)

(*@/// procedure TStringAlignGrid.ClearSelection; *)
procedure TStringAlignGrid.ClearSelection;
var
  t: TGridRect;
begin
  t.left:=-1;
  t.right:=-1;
  t.top:=-1;
  t.bottom:=-1;
  self.selection:=t;
  end;
(*@\\\0000000901*)
(*@/// function TStringAlignGrid.is_fixed(ACol,ARow: integer):boolean; *)
function TStringAlignGrid.is_fixed(ACol,ARow: integer):boolean;
begin
  result:= (ACol<FixedCols) or (ARow<FixedRows) or
           (ACol<f_FixedCols) or (ARow<f_FixedRows);
  end;
(*@\\\0000000301*)

{ A function to get the contents of the grid into a HTML table }
(*@/// function TStringAlignGrid.Contents2HTML:TMemorystream; *)
function TStringAlignGrid.Contents2HTML:TMemorystream;
var
  ACol,ARow: integer;
  font: TFont;
  c: TColor;
(*@/// procedure WriteString(stream:TMemorystream; const s:string); *)
procedure WriteString(stream:TMemorystream; const s:string);
begin
  stream.write(s[1],length(s));
  end;
(*@\\\*)
(*@/// function color2rgb(c:TColor):longint;        // bgr -> rgb *)
function color2rgb(c:TColor):longint;
var
  temp:longint;
begin
  temp:=colortorgb(c);
  result:=((temp and $ff) shl 16) or (temp and $ff00) or ((temp and $ff0000) shr 16);
  end;
(*@\\\*)
(*@/// function text2html(const s:string):string; *)
function text2html(const s:string):string;
var
  i: integer;
  t: string;
begin
  result:='';
  for i:=1 to length(s) do begin
    case s[i] of
      '&' : t:='&amp;';
      '<' : t:='&lt;';
      '>' : t:='&gt;';
      #160: t:='&nbsp;';
      '¡' : t:='&iexcl;';
      '¢' : t:='&cent;';
      '£' : t:='&pound;';
      '¤' : t:='&curren;';
      '¥' : t:='&yen;';
      '¦' : t:='&brvbar;';
      '§' : t:='&sect;';
      '¨' : t:='&uml;';
      '©' : t:='&copy;';
      'ª' : t:='&ordf;';
      '«' : t:='&laquo;';
      '¬' : t:='&not;';
      '­' : t:='&shy;';
      '®' : t:='&reg;';
      '¯' : t:='&macr;';
      '°' : t:='&deg;';
      '±' : t:='&plusmn;';
      '²' : t:='&sup2;';
      '³' : t:='&sup3;';
      '´' : t:='&acute;';
      'µ' : t:='&micro;';
      '¶' : t:='&para;';
      '·' : t:='&middot;';
      '¸' : t:='&cedille;';
      '¹' : t:='&sup1;';
      'º' : t:='&ordm;';
      '»' : t:='&raquo;';
      '¼' : t:='&frac14;';
      '½' : t:='&frac12;';
      '¾' : t:='&frac34;';
      '¿' : t:='&iquest;';
      'À' : t:='&Agrave;';
      'Á' : t:='&Aacute;';
      'Â' : t:='&Acirc;';
      'Ã' : t:='&Atilde;';
      'Ä' : t:='&Auml;';
      'Å' : t:='&Aring;';
      'Æ' : t:='&AElig;';
      'Ç' : t:='&Ccedil;';
      'È' : t:='&Egrave;';
      'É' : t:='&Eacute;';
      'Ê' : t:='&Ecirc;';
      'Ë' : t:='&Euml;';
      'Ì' : t:='&Igrave;';
      'Í' : t:='&Iacute;';
      'Î' : t:='&Icirc;';
      'Ï' : t:='&Iuml;';
      'Ð' : t:='&ETH;';
      'Ñ' : t:='&Ntilde;';
      'Ò' : t:='&Ograve;';
      'Ó' : t:='&Oacute;';
      'Ô' : t:='&Ocirc;';
      'Õ' : t:='&Otilde;';
      'Ö' : t:='&Ouml;';
      '×' : t:='&times;';
      'Ø' : t:='&Oslash;';
      'Ù' : t:='&Ugrave;';
      'Ú' : t:='&Uacute;';
      'Û' : t:='&Ucirc;';
      'Ü' : t:='&Uuml;';
      'Ý' : t:='&Yacute;';
      'Þ' : t:='&THORN;';
      'ß' : t:='&szlig;';
      'à' : t:='&agrave;';
      'á' : t:='&aacute;';
      'â' : t:='&acirc;';
      'ã' : t:='&atilde;';
      'ä' : t:='&auml;';
      'å' : t:='&aring;';
      'æ' : t:='&aelig;';
      'ç' : t:='&ccedil;';
      'è' : t:='&egrave;';
      'é' : t:='&eacute;';
      'ê' : t:='&ecirc;';
      'ë' : t:='&euml;';
      'ì' : t:='&igrave;';
      'í' : t:='&iacute;';
      'î' : t:='&icirc;';
      'ï' : t:='&iuml;';
      'ð' : t:='&eth;';
      'ñ' : t:='&ntilde;';
      'ò' : t:='&ograve;';
      'ó' : t:='&oacute;';
      'ô' : t:='&ocirc;';
      'õ' : t:='&otilde;';
      'ö' : t:='&ouml;';
      '÷' : t:='&divide;';
      'ø' : t:='&oslash;';
      'ù' : t:='&ugrave;';
      'ú' : t:='&uacute;';
      'û' : t:='&ucirc;';
      'ü' : t:='&uuml;';
      'ý' : t:='&yacute;';
      'þ' : t:='&thorn;';
      #255: t:='&yuml;';
      else  t:=s[i];
      end;
    result:=result+t;
    end;
  end;
(*@\\\*)
(*@/// function point2size(v:integer):integer; *)
function point2size(v:integer):integer;
begin
  case v of
    0..5: result:=1;
    6..9: result:=2;
    10  : result:=3;
    11..13: result:=4;
    14..17: result:=5;
    18..21: result:=6;
    else    result:=7;
    end;
  end;
(*@\\\*)
begin
  result:=TMemorystream.Create;
  writestring(result,'<table bgcolor=#'+inttohex(color2rgb(color),6)+'>'#13#10);
  for ARow:=0 to RowCount do begin
    writestring(result,' <tr>'#13#10);
    for ACol:=0 to ColCount do begin
      if (ACol<FixedCols) or (ARow<FixedRows) then
        writestring(result,'  <th')
      else
        writestring(result,'  <td');
      case AlignCell[ACol,ARow] of
        alLeft  :  writestring(result,' align=left');
        alRight :  writestring(result,' align=right');
        alCenter:  writestring(result,' align=center');
        end;
      c:=ColorCell[ACol,ARow];
      if c<>color then
        writestring(result,' bgcolor=#'+inttohex(color2rgb(c),6));
      writestring(result,'>'#13#10);
      if cells[ACol,ARow]<>'' then begin
        font:=GetFontCellComplete(ACol,ARow);
(*@///         if font.haschanged then write font data tags *)
if TMyFont(font).haschanged then begin
  writestring(result,'   <font color=#'+inttohex(color2rgb(font.color),6)
                    +' size='+inttostr(point2size(font.size))+'>');
  if fsBold in font.style then
    writestring(result,'<b>');
  if fsItalic in font.style then
    writestring(result,'<i>');
  if fsStrikeOut in font.style then
    writestring(result,'<strike>');
  if fsUnderline in font.style then
    writestring(result,'<u>');
  end;
(*@\\\0000000229*)
        writestring(result,text2html(cells[ACol,ARow]));
(*@///         if font.haschanged then close font data tags *)
if TMyFont(font).haschanged then begin
  if fsUnderline in font.style then
    writestring(result,'</u>');
  if fsStrikeOut in font.style then
    writestring(result,'</strike>');
  if fsItalic in font.style then
    writestring(result,'</i>');
  if fsBold in font.style then
    writestring(result,'</b>');
  writestring(result,'</font>');
  end;
(*@\\\*)
        end;
      if (ACol<FixedCols) or (ARow<FixedRows) then
        writestring(result,'  </th>')
      else
        writestring(result,'  </td>');
      end;
    writestring(result,' /<tr>'#13#10);
    end;
  writestring(result,'/<table>'#13#10);
  end;
(*@\\\0000001F1B*)
(*@\\\0000001E01*)

{ The component editor - more or less the grid itself }
(*@/// TGridComponentEditor = class(TComponentEditor) *)
{ Some internal help routines for copying the internal lists }
(*@/// function CopyAlignCell(Source,Target:TList; ColCount,RowCount:integer):boolean; *)
function CopyAlignCell(Source,Target:TList; ColCount,RowCount:integer):boolean;
var
  v,w:^tmyalign;
  ACol,ARow: integer;
begin
  result:=false;
  for ACol:=0 to Colcount-1 do
    for ARow:=0 to Rowcount-1 do begin
      v:=GetItemCell(ACol,ARow,Source);
      if v<>NIL then begin
        result:=true;
        New(w);
        w^:=v^;
        end
      else
        w:=NIL;
      w:=SetItemCell(ACol,ARow, Target, w);
      if w<>NIL then
        dispose(w);
      end;
  end;
(*@\\\*)
(*@/// function CopyAlignCol(Source,Target:TList; Count:integer):boolean; *)
function CopyAlignCol(Source,Target:TList; Count:integer):boolean;
var
  v,w:^tmyalign;
  ACol: integer;
begin
  result:=false;
  for ACol:=0 to Count-1 do begin
    v:=GetItemCol(ACol,Source);
    if v<>NIL then begin
      result:=true;
      New(w);
      w^:=v^;
      end
    else
      w:=NIL;
    w:=SetItemCol(ACol, Target, w);
    if w<>NIL then
      dispose(w);
    end;
  end;
(*@\\\*)
(*@/// function CopyColorCell(Source,Target:TList; ColCount,RowCount:integer):boolean; *)
function CopyColorCell(Source,Target:TList; ColCount,RowCount:integer):boolean;
var
  v,w:^TColor;
  ACol,ARow: integer;
begin
  result:=false;
  for ACol:=0 to Colcount-1 do
    for ARow:=0 to Rowcount-1 do begin
      v:=GetItemCell(ACol,ARow,Source);
      if v<>NIL then begin
        result:=true;
        New(w);
        w^:=v^;
        end
      else
        w:=NIL;
      w:=SetItemCell(ACol,ARow, Target, w);
      if w<>NIL then
        dispose(w);
      end;
  end;
(*@\\\*)
(*@/// function CopyColorCol(Source,Target:TList; Count:integer):boolean; *)
function CopyColorCol(Source,Target:TList; Count:integer):boolean;
var
  v,w:^TColor;
  ACol: integer;
begin
  result:=false;
  for ACol:=0 to Count-1 do begin
    v:=GetItemCol(ACol,Source);
    if v<>NIL then begin
      result:=true;
      New(w);
      w^:=v^;
      end
    else
      w:=NIL;
    w:=SetItemCol(ACol, Target, w);
    if w<>NIL then
      dispose(w);
    end;
  end;
(*@\\\0000000A01*)
(*@/// function CopyStringCell(Source,Target:TList; ColCount,RowCount:integer):boolean; *)
function CopyStringCell(Source,Target:TList; ColCount,RowCount:integer):boolean;
var
  v,w:pstring;
  ACol,ARow: integer;
begin
  result:=false;
  for ACol:=0 to Colcount-1 do
    for ARow:=0 to Rowcount-1 do begin
      v:=GetItemCell(ACol,ARow,Source);
      if v<>NIL then begin
        result:=true;
        w:=NewStr(v^);
        end
      else
        w:=NIL;
      w:=SetItemCell(ACol,ARow, Target, w);
      if w<>NIL then
        DisposeStr(w);
      end;
  end;
(*@\\\*)
(*@/// function CopyFontCell(Source,Target:TList; ColCount,RowCount:integer):boolean; *)
function CopyFontCell(Source,Target:TList; ColCount,RowCount:integer):boolean;
var
  v,w:pointer;
  ACol,ARow: integer;
begin
  result:=false;
  for ACol:=0 to Colcount-1 do
    for ARow:=0 to Rowcount-1 do begin
      v:=GetItemCell(ACol,ARow,Source);
      if (v<>NIL) and TMyFont(v).HasChanged then begin
        result:=true;
        w:=TMyFont.Create;
        TFont(w).assign(TFont(v));
        TMyFont(w).HasChanged:=true;
        end
      else
        w:=NIL;
      w:=SetItemCell(ACol,ARow, Target, w);
      if w<>NIL then
        TFont(w).Free;
      end;
  end;
(*@\\\*)
(*@/// function CopyFontCol(Source,Target:TList; Count:integer):boolean; *)
function CopyFontCol(Source,Target:TList; Count:integer):boolean;
var
  v,w:pointer;
  ACol: integer;
begin
  result:=false;
  for ACol:=0 to Count-1 do begin
    v:=GetItemCol(ACol,Source);
    if (v<>NIL) and TMyFont(v).HasChanged then begin
      result:=true;
      w:=TMyFont.Create;
      TFont(w).assign(TFont(v));
      TMyFont(w).HasChanged:=true;
      end
    else
      w:=NIL;
    w:=SetItemCol(ACol, Target, w);
    if w<>NIL then
      TFont(w).Free;
    end;
  end;
(*@\\\*)

(*@/// procedure TGridComponentEditor.Edit;                          // OnCreate *)
procedure TGridComponentEditor.Edit;
{ If you want to internationalize the component editor here are the constants }
{ you'd have to change }
const
  align_str : array[0..3] of string = ('Default','Right','Left','Center');
  align_cap : array[0..4] of string = ('Cell','Column','Fixed Column','Row','Fixed Row');
  font_str : array[0..1] of string = ('Default','Custom');
  cap_showcell = 'Edit Cells';
  cap_showhint = 'Edit Hints';
  cap_alignment = 'Alignment';
  cap_color = 'Color';
  cap_font = 'Font';
var
  i,j: integer;
  edit_form: TForm;
  button: TButton;
  source: TStringAlignGrid;
  sub_item,ShowFont,ShowAlign,ShowColor: TMenuItem;
  main_item: array[0..4] of tmenuitem;
  font_item: array[0..4] of tmenuitem;
  color_item: array[0..4] of tmenuitem;
begin
  source:=component as TStringAlignGrid;
(*@///   create edit_form and set data *)
edit_form:=TForm.Create(NIL);
WITH edit_form do begin
  width:=406;
  height:=208;
  borderstyle:=bsSingle;
  bordericons:=[biSystemMenu];
  Caption:='StringAlignGrid editor';
  end;
(*@\\\*)
(*@///   create grid and set data *)
grid:=TStringAlignGrid.Create(edit_form);
WITH grid do begin
  left:=2;
  top:=2;
  width:=305;
  height:=177;
  options:=[goVertLine,goHorzLine,goEditing];   {goRowSizing,goColSizing}
  fixedrows:=0;
  fixedcols:=0;
  colcount:=source.colcount;
  rowcount:=source.rowcount;
  color:=source.color;
  font:=source.font;
  if newstylecontrols then
    DefaultRowHeight:=18;
  OnMouseDown:=self.MouseDown;
  Parent:=edit_form;
  end;
(*@\\\0000001205*)
(*@///   create ok-button *)
button:=TButton.Create(edit_form);
WITH button do begin
  left:=312;
  top:=16;
  caption:='OK';
  Modalresult:=mrOk;
  parent:=edit_form;
  end;
(*@\\\*)
(*@///   create cancel-button *)
button:=TButton.Create(edit_form);
WITH button do begin
  left:=312;
  if NewStyleControls then
    top:=48
  else
    top:=58;
  caption:='Cancel';
  Modalresult:=mrCancel;
  parent:=edit_form;
  end;
(*@\\\*)
(*@///   create popup menu *)
(*@/// alignments *)
for j:=0 to 4 do begin
  for i:=0 to 3 do begin
    sub_item:=NewItem(align_str[i],0,false,true,self.AlignItem,0,'');
    self.align_Items[j,i]:=sub_item;
    end;
  sub_item:=NewSubMenu(align_cap[j],0,'',[
    align_Items[j,0],
    align_Items[j,1],
    align_Items[j,2],
    align_Items[j,3]
    ]);
  main_item[j]:=sub_item;
  end;
(*@\\\*)
(*@/// fonts *)
for j:=0 to 4 do begin
  for i:=0 to 1 do begin
    sub_item:=NewItem(font_str[i],0,false,true,self.FontItem,0,'');
    self.font_Items[j,i]:=sub_item;
    end;
  sub_item:=NewSubMenu(align_cap[j],0,'',[
    font_Items[j,0],
    font_Items[j,1]
    ]);
  font_item[j]:=sub_item;
  end;
(*@\\\*)
(*@/// colors *)
for j:=0 to 4 do begin
  for i:=0 to 1 do begin
    sub_item:=NewItem(font_str[i],0,false,true,self.ColorItem,0,'');
    self.color_Items[j,i]:=sub_item;
    end;
  sub_item:=NewSubMenu(align_cap[j],0,'',[
    color_Items[j,0],
    color_Items[j,1]
    ]);
  color_item[j]:=sub_item;
  end;
(*@\\\*)
ShowCells:=NewItem(cap_showcell,0,true,true,self.AlignItem,0,'');
ShowHints:=NewItem(cap_showhint,0,false,true,self.AlignItem,0,'');
ShowAlign:=NewSubMenu(cap_alignment,0,'',[
  main_item[0],main_item[1],main_item[2],main_item[3],main_item[4]]);
ShowFont:=NewSubMenu(cap_font,0,'',[
  font_item[0],font_item[1],font_item[2],font_item[3],font_item[4]]);
ShowColor:=NewSubMenu(cap_color,0,'',[
  Color_item[0],Color_item[1],Color_item[2],Color_item[3],Color_item[4]]);

popup_menu:=NewPopupMenu(edit_form,'Popup',paleft,false,
   [ShowAlign,ShowFont,ShowColor,
   ShowCells,ShowHints]
  );
(*@\\\*)
(*@///   Data source -> grid *)
CopyAlignCell (source.FAlignCell,grid.FAlignCell,source.colcount,source.rowcount);
CopyAlignCol  (source.FAlignCol ,grid.FAlignCol,source.colcount);
CopyAlignCol  (source.FFAlignCol,grid.FFAlignCol,source.colcount);
CopyAlignCol  (source.FAlignRow ,grid.FAlignRow,source.rowcount);
CopyAlignCol  (source.FFAlignRow,grid.FFAlignRow,source.rowcount);
CopyStringCell(source.FHintCell ,grid.FHintCell,source.colcount,source.rowcount);
CopyStringCell(source.FCell     ,grid.FCell,source.colcount,source.rowcount);
CopyFontCell  (source.FFontCell ,grid.FFontCell,source.colcount,source.rowcount);
CopyFontCol   (source.FFontCol  ,grid.FFontCol,source.colcount);
CopyFontCol   (source.FFFontCol ,grid.FFFontCol,source.colcount);
CopyFontCol   (source.FFontRow  ,grid.FFontRow,source.rowcount);
CopyFontCol   (source.FFFontRow ,grid.FFFontRow,source.rowcount);
CopyColorCell (source.FColorCell ,grid.FColorCell,source.colcount,source.rowcount);
CopyColorCol  (source.FColorCol  ,grid.FColorCol,source.colcount);
CopyColorCol  (source.FFColorCol ,grid.FFColorCol,source.colcount);
CopyColorCol  (source.FColorRow  ,grid.FColorRow,source.rowcount);
CopyColorCol  (source.FFColorRow ,grid.FFColorRow,source.rowcount);
(*@\\\*)
  grid.ListToCells(grid.FCell);
  grid.f_fixedcols:=source.fixedcols;
  grid.f_fixedrows:=source.fixedrows;
  if edit_form.ShowModal=mrOK then begin
    if showcells.checked then
      grid.CellsToList(grid.FCell)
    else
      grid.CellsToList(grid.FHintCell);
(*@///     Data grid -> source *)
source.FSaveAlignCell     :=CopyAlignCell (grid.FAlignCell,source.FAlignCell,source.colcount,source.rowcount);
source.FSaveAlignCol      :=CopyAlignCol  (grid.FAlignCol ,source.FAlignCol ,source.colcount);
source.FSaveFixedAlignCol :=CopyAlignCol  (grid.FFAlignCol,source.FFAlignCol,source.colcount);
source.FSaveAlignRow      :=CopyAlignCol  (grid.FAlignRow ,source.FAlignRow ,source.rowcount);
source.FSaveFixedAlignRow :=CopyAlignCol  (grid.FFAlignRow,source.FFAlignRow,source.rowcount);
source.FSaveHint          :=CopyStringCell(grid.FHintCell ,source.FHintCell,source.colcount,source.rowcount);
source.FSaveCells         :=CopyStringCell(grid.FCell     ,source.FCell,source.colcount,source.rowcount);
source.FSaveFontCell      :=CopyFontCell  (grid.FFontCell ,source.FFontCell,source.colcount,source.rowcount);
source.FSaveFontCol       :=CopyFontCol   (grid.FFontCol  ,source.FFontCol,source.colcount);
source.FSaveFixedFontCol  :=CopyFontCol   (grid.FFFontCol ,source.FFFontCol,source.colcount);
source.FSaveFontRow       :=CopyFontCol   (grid.FFontRow  ,source.FFontRow,source.rowcount);
source.FSaveFixedFontRow  :=CopyFontCol   (grid.FFFontRow ,source.FFFontRow,source.rowcount);
source.FSaveColorCell     :=CopyColorCell (grid.FColorCell,source.FColorCell,source.colcount,source.rowcount);
source.FSaveColorCol      :=CopyColorCol  (grid.FColorCol ,source.FColorCol,source.colcount);
source.FSaveFixedColorCol :=CopyColorCol  (grid.FFColorCol,source.FFColorCol,source.colcount);
source.FSaveColorRow      :=CopyColorCol  (grid.FColorRow ,source.FColorRow,source.rowcount);
source.FSaveFixedColorRow :=CopyColorCol  (grid.FFColorRow,source.FFColorRow,source.rowcount);
(*@\\\0000000901*)
    source.ListToCells(source.FCell);
    end;
  edit_form.Free;
  end;
(*@\\\0000002601*)
(*@/// procedure TGridComponentEditor.AlignItem(Sender: TObject);    // MenuClick align *)
procedure TGridComponentEditor.AlignItem(Sender: TObject);
var
  i,j: integer;
  alignment: TMyAlign;
  ACol,ARow: integer;
begin
  ACol:=PopupCell.X;
  ARow:=PopupCell.Y;
  if false then
  else if sender=ShowCells then begin
    if ShowCells.checked then EXIT;
    ShowCells.Checked:=true;
    ShowHints.Checked:=false;
    grid.CellsToList(grid.FHintCell);
    grid.ListToCells(grid.FCell);
    end
  else if sender=ShowHints then begin
    if ShowHints.checked then EXIT;
    ShowCells.Checked:=false;
    ShowHints.Checked:=true;
    grid.CellsToList(grid.FCell);
    grid.ListToCells(grid.FHintCell);
    end
  else begin
    for i:=0 to 4 do
      for j:=0 to 3 do begin
        if sender=align_Items[i,j] then begin
          if align_Items[i,j].checked then EXIT;
          if j=0 then  (* reset it *)
            case i of
              0: grid.ResetAlignCell(ACol,ARow);
              1: grid.ResetAlignCol(ACol);
              2: grid.ResetAlignFixedCol(ACol);
              3: grid.ResetAlignRow(ARow);
              4: grid.ResetAlignFixedRow(ARow);
              end
          else begin
            alignment:=TMyAlign(j-1);
            case i of
              0: grid.AlignCell[ACol,ARow]:=Alignment;
              1: grid.AlignCol[ACol]:=Alignment;
              2: grid.FixAlignCol[ACol]:=Alignment;
              3: grid.AlignRow[ARow]:=Alignment;
              4: grid.FixAlignRow[ARow]:=Alignment;
              end;
            end;
          end;
        end;
    end;
  end;
(*@\\\0000001D01*)
(*@/// procedure TGridComponentEditor.FontItem(Sender: TObject);     // MenuClick font *)
procedure TGridComponentEditor.FontItem(Sender: TObject);
var
  i,j: integer;
  ACol,ARow: integer;
  fontdialog: TFontDialog;
begin
  ACol:=PopupCell.X;
  ARow:=PopupCell.Y;
  for i:=0 to 4 do
    for j:=0 to 1 do begin
      if sender=font_Items[i,j] then begin
        if j=0 then  (* reset it *)
          case i of
            0: grid.ResetFontCell(ACol,ARow);
            1: grid.ResetFontCol(ACol);
            2: grid.ResetFontFixedCol(ACol);
            3: grid.ResetFontRow(ARow);
            4: grid.ResetFontFixedRow(ARow);
            end
        else begin
          fontdialog:=TFontDialog.Create(NIL);
          case i of
            0: fontdialog.font.assign(grid.GetFontCell(ACol,ARow));
            1: fontdialog.font.assign(grid.GetFontCol(ACol));
            2: fontdialog.font.assign(grid.GetFontFixedCol(ACol));
            3: fontdialog.font.assign(grid.GetFontRow(ARow));
            4: fontdialog.font.assign(grid.GetFontFixedRow(ARow));
            end;
          if fontdialog.execute then
            case i of
              0: grid.SetFontCell(ACol,ARow,fontdialog.font);
              1: grid.SetFontCol(ACol,fontdialog.font);
              2: grid.SetFontFixedCol(ACol,fontdialog.font);
              3: grid.SetFontRow(ARow,fontdialog.font);
              4: grid.SetFontFixedRow(ARow,fontdialog.font);
              end;
          fontdialog.free;
          end;
        end;
      end;
  end;
(*@\\\0000002101*)
(*@/// procedure TGridComponentEditor.ColorItem(Sender: TObject);    // MenuClick color *)
procedure TGridComponentEditor.ColorItem(Sender: TObject);
var
  i,j: integer;
  ACol,ARow: integer;
  Colordialog: TColorDialog;
begin
  ACol:=PopupCell.X;
  ARow:=PopupCell.Y;
  for i:=0 to 4 do
    for j:=0 to 1 do begin
      if sender=color_Items[i,j] then begin
        if j=0 then  (* reset it *)
          case i of
            0: grid.ResetColorCell(ACol,ARow);
            1: grid.ResetColorCol(ACol);
            2: grid.ResetColorFixedCol(ACol);
            3: grid.ResetColorRow(ARow);
            4: grid.ResetColorFixedRow(ARow);
            end
        else begin
          Colordialog:=TColorDialog.Create(NIL);
          case i of
            0: Colordialog.Color:=grid.GetColorCell(ACol,ARow);
            1: Colordialog.Color:=grid.GetColorCol(ACol);
            2: Colordialog.Color:=grid.GetFixColorCol(ACol);
            3: Colordialog.Color:=grid.GetColorRow(ARow);
            4: Colordialog.Color:=grid.GetFixColorRow(ARow);
            end;
          if Colordialog.execute then
            case i of
              0: grid.SetColorCell(ACol,ARow,Colordialog.Color);
              1: grid.SetColorCol(ACol,Colordialog.Color);
              2: grid.SetFixColorCol(ACol,Colordialog.Color);
              3: grid.SetColorRow(ARow,Colordialog.Color);
              4: grid.SetFixColorRow(ARow,Colordialog.Color);
              end;
          Colordialog.free;
          end;
        end;
      end;
  end;
(*@\\\*)
(*@/// procedure TGridComponentEditor.MouseDown(Sender:TObject;..);  // OnPopup *)
procedure TGridComponentEditor.MouseDown(Sender:TObject; Button:TMouseButton; Shift: TSHiftstate; X,Y:Integer);
(*@/// function same_font(v:pointer):boolean; *)
function same_font(v:pointer):boolean;
begin
  if v=NIL then
    result:=true
  else
    result:=not TMyFont(v).HasChanged;
  end;
(*@\\\*)
var
  ACol,ARow: longint;
  AColRow: longint;
  i,j: integer;
  same: boolean;
  Alignment: ^TMyAlign;
  font: pointer;
  List: TList;
  temp_Point: TPoint;
begin
(*$ifndef ver80 *)
  list:=NIL;  {Delphi 2 shut up ! :-) }
  AColRow:=0; { dito }
(*$endif *)
  if button=mbRight then begin
    grid.MouseToCell(x,y,ACol,ARow);
    for i:=0 to 4 do begin
      for j:=0 to 3 do
        align_Items[i,j].checked:=false;
      for j:=0 to 1 do
        font_Items[i,j].checked:=false;
      end;
    if (ACol>=0) or (ARow>=0) then begin
      PopupCell.X:=ACol;
      PopupCell.Y:=ARow;
(*@///       Set alignment checks *)
(*@/// AlignCell *)
alignment:=GetItemCell(ACol,ARow,grid.FAlignCell);
align_Items[0,0].checked:=alignment=NIL;
if alignment<>NIL then
  case alignment^ of
    alRight : align_Items[0,1].checked:=true;
    alLeft  : align_Items[0,2].checked:=true;
    alCenter: align_Items[0,3].checked:=true;
    end;
(*@\\\*)
for i:=1 to 4 do begin
  case i of
    1: begin
      list:=grid.FAlignCol;
      AColRow:=ACol;
      end;
    2: begin
      list:=grid.FFAlignCol;
      AColRow:=ACol;
      end;
    3: begin
      list:=grid.FAlignRow;
      AColRow:=ARow;
      end;
    4: begin
      list:=grid.FFAlignRow;
      AColRow:=ARow;
      end;
    end;
(*@///   AlignCol *)
alignment:=GetItemCol(AColRow,List);
align_Items[i,0].checked:=alignment=NIL;
if alignment<>NIL then
  case alignment^ of
    alRight : align_Items[i,1].checked:=true;
    alLeft  : align_Items[i,2].checked:=true;
    alCenter: align_Items[i,3].checked:=true;
    end;
(*@\\\*)
  end;
(*@\\\*)
(*@///       Set font checks *)
font:=GetItemCell(ACol,ARow,grid.FFontCell);
same:=(font=NIL) or not TMyFont(font).Haschanged;
font_Items[0,0].checked:=same;
font_Items[0,1].checked:=not same;
font:=GetItemCol(ACol,grid.FFontCol);
same:=(font=NIL) or not TMyFont(font).Haschanged;
font_Items[1,0].checked:=same;
font_Items[1,1].checked:=not same;
font:=GetItemCol(ACol,grid.FFFontCol);
same:=(font=NIL) or not TMyFont(font).Haschanged;
font_Items[2,0].checked:=same;
font_Items[2,1].checked:=not same;
font:=GetItemCol(ARow,grid.FFontRow);
same:=(font=NIL) or not TMyFont(font).Haschanged;
font_Items[3,0].checked:=same;
font_Items[3,1].checked:=not same;
font:=GetItemCol(ARow,grid.FFFontRow);
same:=(font=NIL) or not TMyFont(font).Haschanged;
font_Items[4,0].checked:=same;
font_Items[4,1].checked:=not same;
(*@\\\*)
(*@///       Set color checks *)
same:=GetItemCell(ACol,ARow,grid.FcolorCell)=NIL;
color_Items[0,0].checked:=same;
color_Items[0,1].checked:=not same;
same:=GetItemCol(ACol,grid.FcolorCol)=NIL;
color_Items[1,0].checked:=same;
color_Items[1,1].checked:=not same;
same:=GetItemCol(ACol,grid.FFcolorCol)=NIL;
color_Items[2,0].checked:=same;
color_Items[2,1].checked:=not same;
same:=GetItemCol(ARow,grid.FcolorRow)=NIL;
color_Items[3,0].checked:=same;
color_Items[3,1].checked:=not same;
same:=GetItemCol(ARow,grid.FFcolorRow)=NIL;
color_Items[4,0].checked:=same;
color_Items[4,1].checked:=not same;
(*@\\\*)
      temp_point:=grid.clienttoscreen(point(x,y));
      popup_menu.popup(temp_point.x,temp_point.y);
      end;
    end;
  end;
(*@\\\0000000D13*)
(*@\\\0000000E49*)

{ The rest are just a few help tools for the Application.OnShowHint and }
{ Application.OnIdle methods - Borland didn't thought of the need to }
{ put more than one method in these places, so I had to do it myself. }
{ Some nice internals how to work with method pointer are presented here. }

{ First a TList which contains TObjects and free's them itself }
(*@/// TObjectList = class(TList)       // A list which frees it's objects *)
type
  TObjectList = class(TList)
  public
    destructor Destroy; override;

  { Why hasn't Borland made the delete method virtual??? Now I must create }
  { a new virtual slot with all the problems this may cause just because }
  { of a missing word... - first cause is the remove method which is absolutely }
  { the same as in TList, but as Delete isn't virtual I need it here again. }

  { I you want to use this component anywhere else be VERY careful, any call }
  { as a TList may cause problems }

    procedure Delete(Index:Integer);  virtual;
    function Remove(Item:Pointer):Integer; virtual;
    end;

(*@/// destructor TObjectList.Destroy; *)
destructor TObjectList.Destroy;
var
  i: integer;
begin
  for i:=count-1 downto 0 do
    TObject(items[i]).Free;
  inherited destroy;
  Clear;
end;
(*@\\\*)
(*@/// procedure TObjectList.Delete(Index:Integer); *)
procedure TObjectList.Delete(Index:Integer);
begin
  TObject(items[index]).Free;
  inherited delete(index);
  end;
(*@\\\*)
(*@/// function TObjectList.Remove(Item:Pointer):Integer; *)
function TObjectList.Remove(Item:Pointer):Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
  end;
(*@\\\*)
(*@\\\0000000801*)

type
  TMethodPointer = procedure of object;
(*@///   TMethod = class(TObject)       // Object with just one methodpointer *)
TMethod = class(TObject)
public
  methodpointer: TMethodPointer;
  end;
(*@\\\*)


var
  ShowHintProcs: TObjectList;
  IdleProcs: TObjectList;

{ A little dummy object which provides the methods to be put in the
{ application's method pointers; if you use this you shouldn't access
{ Application.OnIdle and Application.OnShowHint directly but always use
{ the Add/RemoveXXXProc routines }
{ You can add any other Application.OnXXX method here if you need it }
(*@/// TDummyObject = class(TObject) *)
type
  TDummyObject=class(TObject)
  procedure ShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  procedure DoIdle(sender: TObject; var done:Boolean);
  end;
(*@/// procedure TDummyObject.ShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo); *)
procedure TDummyObject.ShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
  i:integer;
begin
  for i:=ShowHintProcs.Count-1 downto 0 do
    if ShowHintProcs.Items[i]<>NIL then begin
      TShowHintEvent(TMethod(ShowHintProcs.Items[i]).methodpointer)(HintStr,CanShow,HintInfo);
      end;
  end;
(*@\\\*)
(*@/// procedure TDummyObject.DoIdle(sender: TObject; var done:Boolean); *)
procedure TDummyObject.DoIdle(sender: TObject; var done:Boolean);
var
  i:integer;
  temp_done: boolean;
begin
  done:=false;
  for i:=IdleProcs.Count-1 downto 0 do
    if IdleProcs.Items[i]<>NIL then begin
      TIdleEvent(TMethod(IdleProcs.Items[i]).methodpointer)(sender, temp_done);
      done:=done and temp_done;   (* done when all idle procs say done *)
      end;
  end;
(*@\\\*)
(*@\\\*)

var
  Dummy: TDummyObject;

{ Compare two method pointers }
(*@/// function compare_method(proc1,proc2:TMethodpointer):boolean; *)
function compare_method(proc1,proc2:TMethodpointer):boolean;
{ A method pointer are just two pointers, one the procedure pointer }
{ itself, then the self pointer. }
type
(*@///   T_Method=packed record *)
T_Method=packed record
  proc: Pointer;
  self: TObject;
  end;
(*@\\\*)
begin
  result:=(T_Method(proc1).proc=T_Method(proc2).proc) and
          (T_Method(proc1).self=T_Method(proc2).self);
  end;
(*@\\\*)

{ Include and remove the Methodpointer from the according lists }
(*@/// procedure AddShowHintProc(proc:TShowHintEvent); *)
procedure AddShowHintProc(proc:TShowHintEvent);
var
  method: TMethod;
begin
  method:=TMethod.Create;
  method.methodpointer:=TMethodPointer(proc);
  showhintprocs.add(method);
  Application.OnShowHint:=dummy.ShowHint;
  end;
(*@\\\*)
(*@/// procedure RemoveShowHintProc(proc:TShowHintEvent); *)
procedure RemoveShowHintProc(proc:TShowHintEvent);
var
  i: integer;
begin
  for i:=showhintprocs.count-1 downto 0 do
    if (showhintprocs.items[i]<>NIL) and
       compare_method(TMethod(showhintprocs.items[i]).methodpointer,
                      TMethodpointer(proc))  then
      showhintprocs.delete(i);
  end;
(*@\\\*)
(*@/// procedure AddIdleProc(proc:TIdleEvent); *)
procedure AddIdleProc(proc:TIdleEvent);
var
  method: TMethod;
begin
  method:=TMethod.Create;
  method.methodpointer:=TMethodPointer(proc);
  idleprocs.add(method);
  Application.OnIdle:=dummy.DoIdle;
  end;
(*@\\\*)
(*@/// procedure RemoveIdleProc(proc:TIdleEvent); *)
procedure RemoveIdleProc(proc:TIdleEvent);
var
  i: integer;
begin
  for i:=idleprocs.count-1 downto 0 do
    if (idleprocs.items[i]<>NIL) and
       compare_method(TMethod(idleprocs.items[i]).methodpointer,
                      TMethodpointer(proc))  then
      idleprocs.delete(i);
  end;
(*@\\\*)

{ The clean up of the two global lists and the dummy object }
(*@/// procedure DoneUnit; far; *)
procedure DoneUnit; far;                (* Delphi2: same as finalization *)
begin
  ShowHintProcs.Free;
  ShowHintProcs:=NIL;
  IdleProcs.Free;
  IdleProcs:=NIL;
  Dummy.Free;
  Dummy:=NIL;
  end;
(*@\\\*)

{ For the IDE to display my grid there and include the component editor }
(*@/// procedure Register; *)
procedure Register;
begin
  RegisterComponents('Custom', [TStringAlignGrid]);
  RegisterComponentEditor(TStringAlignGrid,TGridComponentEditor);
  end;
(*@\\\*)
(*@\\\0000000F14*)
(*@/// initialization *)
begin
  Dummy:=TDummyObject.Create;
  ShowHintProcs:=TObjectList.Create;
  IdleProcs:=TObjectList.Create;
  AddExitProc(DoneUnit);
(*@\\\*)
end.
(*@\\\0003000F05000011000F05*)
