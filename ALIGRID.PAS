unit Aligrid;

{ Copyright 1995/97 Andreas Hörstemeier            Version 1.4  1997-03-07   }
{ this component is public domain - please check the file readme.txt for     }
{ more detailed info on usage and distributing                               }

{ To do: - 32bit DCR file (my D2 complains and uses TStringGrid's...)
         - Fonts not yet editable in the component editor since I don't
           know how to save them yet
         - Strange behaviour in Delphi2 - the hints only appear for the cell
           in the upper left corner of the grid, maybe a change deep in the
           VCL.
         - More documentation - I started documenting the source, but
           there's still no help file nor a nive demo application
         - Providing a URL for the editor that creates all the strange
           comment lines - they contain the data how to fold the code }

(*@/// interface *)
interface

(*@/// uses *)
uses
  SysUtils,
  WinTypes,
  WinProcs,
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
(*@\\\*)

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
(*@\\\0000000201*)
(*@///   Internal routines and variables for the Read/write of the hints *)
private
  FSaveHint: Boolean;
  procedure ReadHint(Reader: TReader); virtual;
  procedure WriteHint(Writer: TWriter); virtual;
(*@\\\0000000203*)
(*@///   Internal routines and variables for the Read/write of the cells itself *)
private
  FSaveCells: Boolean;
  procedure ReadCells(Reader: TReader); virtual;
  procedure WriteCells(Writer: TWriter); virtual;
(*@\\\0000000203*)
protected
  procedure Loaded; override;
  procedure DefineProperties(Filer: TFiler); override;
private
  FShowCellHints: Boolean;
  FAlign: TMyAlign;
  FHintPos: TPoint;
(*@///   F... : TList; *)
FAlignCol: TList;
FAlignRow: TList;
FFAlignCol: TList;
FFAlignRow: TList;
FAlignCell: TList;

FHintCell: TList;
FCell: TList;        { Only for loading and saving the cells property }

FFontCol: TList;
FFontRow: TList;
FFFontCol: TList;
FFFontRow: TList;
FFontCell: TList;
(*@\\\*)

  procedure ListToCells(List:TList);
  procedure CellsToList(var List:TList);

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

  function GetHintCell(ACol,ARow: integer):string;
  procedure SetHintCell(ACol,ARow: integer; const Value: string);

  function GetFontCellComplete(ACol,ARow: integer):TFont;

  function GetFontCell(ACol,ARow: integer):TFont;
  function GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont;
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

  procedure Initialize;
protected
  procedure DrawCell(ACol,ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  procedure ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;

  { The Alignments for each cell or whole Columns (Fixed and normal) }
  property AlignCell[ACol,ARow:integer]: TMyAlign read GetAlignCell write SetAlignCell;
  property AlignCol[ACol:integer]: TMyAlign read GetAlignCol write SetAlignCol;
  property FixAlignCol[ACol:integer]: TMyAlign read GetFixAlignCol write SetFixAlignCol;
  property AlignRow[ARow:integer]: TMyAlign read GetAlignRow write SetAlignRow;
  property FixAlignRow[ARow:integer]: TMyAlign read GetFixAlignRow write SetFixAlignRow;

  { The font for each cell and for col and row }
  property CellFont[ACol,ARow:integer]: TFont read GetFontCell write SetFontCell;
  property ColFont[ACol:integer]: TFont read GetFontCol write SetFontCol;
  property FixedColFont[ACol:integer]: TFont read GetFontFixedCol write SetFontFixedCol;
  property FixedRowFont[ARow:integer]: TFont read GetFontFixedRow write SetFontFixedRow;

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
  procedure ResetFAlignCol(ACol:integer);
  procedure ResetAlignRow(ARow:integer);
  procedure ResetFAlignRow(ARow:integer);
  procedure ResetAlignment;
published
  { The Aligment can be set globally using this property }
  property Alignment: TMyAlign read GetAlign write SetAlign default alLeft;
  { To switch the Hints from cell-specific to grid-global }
  property ShowCellHints: boolean read FShowCellHints write FShowCellHints default true;
end;
(*@\\\0000002801*)
(*@/// TGridComponentEditor = class(TComponentEditor) *)
TGridComponentEditor = class(TComponentEditor)
private
  Align_Items: array[0..4,0..3] of TMenuItem;
  ShowHints, ShowCells: TMenuItem;
  Grid: TStringAlignGrid;
  PopupCell: TPoint;
  popup_menu: TPopupMenu;
public
  procedure Edit; override;
  procedure AlignItem(Sender: TObject);
  procedure MouseDown(Sender:TObject; Button:TMouseButton; Shift: TSHiftstate; X,Y:Integer);
  end;
(*@\\\0000000422*)

procedure AddShowHintProc(proc:TShowHintEvent);
procedure RemoveShowHintProc(proc:TShowHintEvent);
procedure AddIdleProc(proc:TIdleEvent);
procedure RemoveIdleProc(proc:TIdleEvent);

procedure Register;
(*@\\\*)
(*@/// implementation *)
implementation

{ The Grid itself }
(*@/// TStringAlignGrid     = class(TStringGrid) *)
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
(*@\\\0000000A01*)
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
(*@\\\0000000A01*)
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
(*@\\\0000000901*)

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
  FSaveHint:=false;
  FSaveCells:=false;
  Initialize;
  end;
(*@\\\0000000901*)
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
(*@\\\000000010D*)
(*@///   FAlignCell.Free; *)
if FAlignCell<>NIL then
  for i:=0 to FAlignCell.Count-1 do
    cleanlist(TList(FAlignCell.Items[i]),sizeof(TMyAlign));
FAlignCell.Free;
FAlignCell:=NIL;
(*@\\\000000010E*)
(*@///   FFAlignCol.Free; *)
if FFAlignCol<>NIL then
  cleanlist(FFAlignCol,sizeof(TMyAlign));
FFAlignCol.Free;
FFAlignCol:=NIL;
(*@\\\0000000105*)
(*@///   FFAlignRow.Free; *)
if FFAlignRow<>NIL then
  cleanlist(FFAlignRow,sizeof(TMyAlign));
FFAlignRow.Free;
FFAlignRow:=NIL;
(*@\\\0000000105*)
(*@///   FHintCell.Free; *)
if FHintCell<>NIL then
  for i:=0 to FHintCell.Count-1 do
    cleanlist_pstring(TList(FHintCell.Items[i]));
FHintCell.Free;
FHintCell:=NIL;
(*@\\\000000010D*)
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
(*@\\\000000010C*)
(*@///   FFFontCol.Free; *)
if FFFontCol<>NIL then
  cleanlist_object(FFFontCol);
FFFontCol.Free;
FFFontCol:=NIL;
(*@\\\0000000105*)
(*@///   FFFontRow.Free; *)
if FFFontRow<>NIL then
  cleanlist_object(FFFontRow);
FFFontRow.Free;
FFFontRow:=NIL;
(*@\\\0000000105*)
(*@///   FFontCell.Free; *)
if FFontCell<>NIL then
  for i:=0 to FFontCell.Count-1 do
    cleanlist_object(TList(FFontCell.Items[i]));
FFontCell.Free;
FFontCell:=NIL;
(*@\\\000000010D*)
(*@///   FCell.Free; *)
if FCell<>NIL then
  for i:=0 to FCell.Count-1 do
    cleanlist_pstring(TList(FCell.Items[i]));
FCell.Free;
FCell:=NIL;
(*@\\\0000000305*)
  RemoveShowHintProc(ShowHintCell);
  inherited Destroy;
  end;
(*@\\\0000000703*)
(*@/// procedure TStringAlignGrid.Initialize; *)
procedure TStringAlignGrid.Initialize;
begin
  FAlignCell:=TList.Create;
  FAlignCol:=TList.Create;
  FFAlignCol:=TList.Create;
  FAlignRow:=TList.Create;
  FFAlignRow:=TList.Create;
  FHintCell:=TList.Create;
  FCell:=TList.Create;
  FFontCell:=TList.Create;
  FFontCol:=TList.Create;
  FFFontCol:=TList.Create;
  FFontRow:=TList.Create;
  FFFontRow:=TList.Create;
  FAlign:=alLeft;
  FShowCellHints:=true;
  AddShowHintProc(ShowHintCell);
  end;
(*@\\\0000001001*)

{ Internal routines for saving any data pointer in a two-dimensional List }
(*@/// function GetItemCell(ACol,ARow: Integer; List:TList):Pointer; *)
function GetItemCell(ACol,ARow: Integer; List:TList):Pointer;
var
  sublist: TList;
begin
  if ACol+1 > List.Count then
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
(*@\\\000000010A*)
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
(*@\\\*)

{ Internal routines for saving any data pointer (or a longint) in a List }
(*@/// function GetItemCol(ACol: Integer; List:TList):Pointer; *)
function GetItemCol(ACol: Integer; List:TList):Pointer;
begin
  if ACol+1 > List.Count then
    GetItemCol:=NIL
  else
    if List.Items[ACol] = NIL then
      GetItemCol:=NIL
    else begin
      GetItemCol:=List.Items[ACol];
      end;
  end;
(*@\\\000000010A*)
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
(*@\\\000000010A*)

{ Property read and write for Alignment }
(*@/// function TStringAlignGrid.GetAlign: TMyAlign; *)
function TStringAlignGrid.GetAlign: TMyAlign;
begin
  GetAlign:=FAlign;
  end;
(*@\\\000000010B*)
(*@/// procedure TStringAlignGrid.SetAlign(const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlign(const Value: TMyAlign);
begin
  FAlign:=Value;
  Invalidate;
  end;
(*@\\\000000030B*)

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
(*@\\\0000000901*)
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
(*@\\\0000000501*)
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
(*@\\\0000000715*)
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
(*@\\\000000050D*)

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
(*@\\\0000000510*)
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
(*@\\\0000000515*)

{ Property read and write for AlignCell }
(*@/// function TStringAlignGrid.GetAlignCell(ACol,ARow:Integer):TMyAlign; *)
function TStringAlignGrid.GetAlignCell(ACol,ARow:Integer):TMyAlign;
var
  v:^tmyalign;
  fixed: boolean;
begin
  v:=GetItemCell(ACol,ARow,FAlignCell);
  fixed:=(ACol<FixedCols) or (ARow<FixedRows);
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
(*@\\\0000000701*)
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
(*@\\\0000000901*)

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
(*@\\\0000000401*)
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
(*@\\\0000000401*)
(*@/// procedure TStringAlignGrid.ResetFAlignCol(ACol:integer); *)
procedure TStringAlignGrid.ResetFAlignCol(ACol:integer);
var
  v:^tmyalign;
begin
  v:=SetItemCol(ACol, FFAlignCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000401*)
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
(*@/// procedure TStringAlignGrid.ResetFAlignRow(ARow:integer); *)
procedure TStringAlignGrid.ResetFAlignRow(ARow:integer);
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
(*@\\\0000000501*)

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
(*@\\\0000000901*)
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
(*@\\\0000000701*)

{ Property read and write for FontCell }
(*@/// function TStringAlignGrid.GetFontCell(ACol,ARow: integer):TFont; *)
function TStringAlignGrid.GetFontCell(ACol,ARow: integer):TFont;
begin
  GetFontCell:=GetFontCellInternal(ACol,ARow,true);
  end;
(*@\\\0000000301*)
(*@/// function TStringAlignGrid.GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont; *)
function TStringAlignGrid.GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont;
var
  v: Pointer;
begin
  v:=GetItemCell(ACol,ARow,FFontCell);
  if (v=NIL) then begin
    if create then begin
      v:=TFont.Create;
      TFont(v).Assign(self.font);
      SetItemCell(ACol,ARow, FFontCell, v);
      end
    else v:=self.Font;
    end;
  GetFontCellInternal:=TFont(v);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.SetFontCell(ACol,ARow: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontCell(ACol,ARow: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TFont.Create;
  TFont(v).Assign(value);
  v:=SetItemCell(ACol,ARow, FFontCell, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000901*)

{ A little utility method }
(*@/// function TStringAlignGrid.GetFontColRowInternal(AColRow: integer; create:boolean; List:TList):TFont; *)
function TStringAlignGrid.GetFontColRowInternal(AColRow: integer; create:boolean; List:TList):TFont;
var
  v: Pointer;
begin
  v:=GetItemCol(AColRow,List);
  if (v=NIL) then begin
    if create then begin
      v:=TFont.Create;
      TFont(v).Assign(self.font);
      SetItemCol(AColRow, List, v);
      end
    else v:=self.Font;
    end;
  GetFontColRowInternal:=TFont(v);
  end;
(*@\\\*)

{ Property read and write for FontCol/FixedFontCol }
(*@/// function TStringAlignGrid.GetFontCol(ACol: integer):TFont; *)
function TStringAlignGrid.GetFontCol(ACol: integer):TFont;
begin
  GetFontCol:=GetFontColRowInternal(ACol,true,FFontCol);
  end;
(*@\\\0000000329*)
(*@/// procedure TStringAlignGrid.SetFontCol(ACol: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontCol(ACol: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TFont.Create;
  TFont(v).Assign(value);
  v:=SetItemCol(ACol, FFontCol, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000901*)
(*@/// function TStringAlignGrid.GetFontFixedCol(ACol: integer):TFont; *)
function TStringAlignGrid.GetFontFixedCol(ACol: integer):TFont;
begin
  GetFontFixedCol:=GetFontColRowInternal(ACol,true,FFFontCol);
  end;
(*@\\\0000000312*)
(*@/// procedure TStringAlignGrid.SetFontFixedCol(ACol: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontFixedCol(ACol: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TFont.Create;
  TFont(v).Assign(value);
  v:=SetItemCol(ACol, FFFontCol, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\0000000701*)

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
  v:=TFont.Create;
  TFont(v).Assign(value);
  v:=SetItemCol(ARow, FFontRow, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFontFixedRow(ARow: integer):TFont; *)
function TStringAlignGrid.GetFontFixedRow(ARow: integer):TFont;
begin
  GetFontFixedRow:=GetFontColRowInternal(ARow,true,FFFontRow);
  end;
(*@\\\0000000312*)
(*@/// procedure TStringAlignGrid.SetFontFixedRow(ARow: integer; const Value: TFont); *)
procedure TStringAlignGrid.SetFontFixedRow(ARow: integer; const Value: TFont);
var
  v: pointer;
begin
  v:=TFont.Create;
  TFont(v).Assign(value);
  v:=SetItemCol(ARow, FFFontRow, v);
  if v<>NIL then
    TFont(v).Free;
  Invalidate;
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
  fixed:=(ACol<FixedCols) or (ARow<FixedRows);
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
(*@\\\0000001701*)

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
(*@\\\0000000518*)
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
(*@\\\0000000701*)

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
(*@\\\0000000801*)
begin
  if DefaultDrawing then
    DrawCellText
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
  end;
(*@\\\0000000301*)

{ The utility methods for the cell-specific hints }
(*@/// procedure TStringAlignGrid.ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo); *)
procedure TStringAlignGrid.ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
  col,row:longint;
  HintPos:TRect;
begin
  if (hintinfo.hintcontrol=self) and FShowCellHints then begin
    fhintpos:=hintinfo.cursorpos;
    self.mousetocell(hintinfo.cursorpos.x,hintinfo.cursorpos.y,col,row);
    hintpos:=self.Cellrect(col,row);
    hintinfo.hintpos.x:=hintpos.left;
    hintinfo.hintpos.y:=hintpos.bottom+6;
    hintinfo.hintpos:=self.clienttoscreen(hintinfo.hintpos);
    hintstr:=HintCell[col,row];
    end;
  end;
(*@\\\0000000E01*)
(*@/// procedure TStringAlignGrid.MouseMove(Shift: TShiftState; X, Y: Integer); *)
procedure TStringAlignGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  col1,col2,row1,row2: longint;
begin
  self.mousetocell(fhintpos.x,fhintpos.y,col1,row1);
  self.mousetocell(x,y,col2,row2);
  if (col1<>col2) or (row1<>row2) then
    Application.CancelHint;
  inherited MouseMove(Shift, X, Y);
  end;
(*@\\\0000000727*)

{ The stuff for reading and writing the data from/to the DFM file }
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
(*@\\\0000000901*)

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
  end;
(*@\\\0000000B01*)
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
(*@\\\0000000301*)
    end;
  end;
(*@\\\0000000B01*)

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
(*@\\\000000071E*)

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
(*@\\\0000000C01*)
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
(*@\\\0000000713*)

(*@/// procedure TStringAlignGrid.ReadAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.ReadAlignCol(Stream: TStream);
begin
  FSaveAlignCol:=ReadAlignColRow(Stream,FAlignCol);
  end;
(*@\\\0000000303*)
(*@/// procedure TStringAlignGrid.WriteAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.WriteAlignCol(Stream: TStream);
begin
  WriteAlignColRow(Stream, ColCount-1, FAlignCol);
  end;
(*@\\\0000000324*)
(*@/// procedure TStringAlignGrid.ReadFixedAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.ReadFixedAlignCol(Stream: TStream);
begin
  FSaveFixedAlignCol:=ReadAlignColRow(Stream,FFAlignCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedAlignCol(Stream: TStream); *)
procedure TStringAlignGrid.WriteFixedAlignCol(Stream: TStream);
begin
  WriteAlignColRow(Stream, ColCount-1, FFAlignCol);
  end;
(*@\\\0000000326*)
(*@/// procedure TStringAlignGrid.ReadAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.ReadAlignRow(Stream: TStream);
begin
  FSaveAlignRow:=ReadAlignColRow(Stream,FAlignRow);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.WriteAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.WriteAlignRow(Stream: TStream);
begin
  WriteAlignColRow(Stream, RowCount-1, FAlignRow);
  end;
(*@\\\0000000326*)
(*@/// procedure TStringAlignGrid.ReadFixedAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.ReadFixedAlignRow(Stream: TStream);
begin
  FSaveFixedAlignRow:=ReadAlignColRow(Stream,FFAlignRow);
  end;
(*@\\\0000000315*)
(*@/// procedure TStringAlignGrid.WriteFixedAlignRow(Stream: TStream); *)
procedure TStringAlignGrid.WriteFixedAlignRow(Stream: TStream);
begin
  WriteAlignColRow(Stream, RowCount-1, FFAlignRow);
  end;
(*@\\\0000000326*)

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
(*@\\\0000000B01*)
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
(*@\\\000000081E*)

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
(*@\\\0000000C01*)
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
(*@\\\0000000801*)
(*@\\\0000000B01*)

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
(*@\\\0000000D0A*)
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
(*@\\\0000000D01*)

(*@/// procedure TGridComponentEditor.Edit;                          // OnCreate *)
procedure TGridComponentEditor.Edit;
{ If you want to internationalize the component editor here are the constants }
{ you'd have to change }
const
  align_str : array[0..3] of string = ('Default','Left','Right','Center');
  align_cap : array[0..4] of string = ('Cell','Column','Fixed Column','Row','Fixed Row');
  cap_showcell = 'Edit Cells';
  cap_showhint = 'Edit Hints';
var
  i,j: integer;
  edit_form: TForm;
  button: TButton;
  source: TStringAlignGrid;
  sub_item: TMenuItem;
  main_item: array[0..4] of tmenuitem;
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
  if newstylecontrols then
    DefaultRowHeight:=18;
  OnMouseDown:=self.MouseDown;
  Parent:=edit_form;
  end;
(*@\\\0000000201*)
(*@///   create ok-button *)
button:=TButton.Create(edit_form);
WITH button do begin
  left:=312;
  top:=16;
  caption:='OK';
  Modalresult:=mrOk;
  parent:=edit_form;
  end;
(*@\\\0000000612*)
(*@///   create ok-button *)
button:=TButton.Create(edit_form);
WITH button do begin
  left:=312;
  top:=48;
  caption:='Cancel';
  Modalresult:=mrCancel;
  parent:=edit_form;
  end;
(*@\\\0000000614*)
(*@///   create popup menu *)
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
ShowCells:=NewItem(cap_showcell,0,true,true,self.AlignItem,0,'');
ShowHints:=NewItem(cap_showhint,0,false,true,self.AlignItem,0,'');

popup_menu:=NewPopupMenu(edit_form,'Popup',paleft,false,
  [main_item[0],main_item[1],main_item[2],main_item[3],main_item[4],
   NewLine,ShowCells,ShowHints]
  );
(*@\\\0000001101*)
(*@///   Data source -> grid *)
  CopyAlignCell (source.FAlignCell,grid.FAlignCell,source.colcount,source.rowcount);
  CopyAlignCol  (source.FAlignCol ,grid.FAlignCol,source.colcount);
  CopyAlignCol  (source.FFAlignCol,grid.FFAlignCol,source.colcount);
  CopyAlignCol  (source.FAlignRow ,grid.FAlignRow,source.rowcount);
  CopyAlignCol  (source.FFAlignRow,grid.FFAlignRow,source.rowcount);
  CopyStringCell(source.FHintCell ,grid.FHintCell,source.colcount,source.rowcount);
  CopyStringCell(source.FCell     ,grid.FCell,source.colcount,source.rowcount);
{   CopyFontCell(source.FFontCell ,grid.FFontCell,source.colcount,source.rowcount); }
{   CopyFontCol (source.FFontCol  ,grid.FFontCol,source.colcount); }
{   CopyFontCol (source.FFFontCol ,grid.FFFontCol,source.colcount); }
{   CopyFontCol (source.FFontRow  ,grid.FFontRow,source.rowcount); }
{   CopyFontCol (source.FFFontRow ,grid.FFFontRow,source.rowcount); }
(*@\\\*)
  grid.ListToCells(grid.FCell);
  if edit_form.ShowModal=mrOK then begin
    if showcells.checked then
      grid.CellsToList(grid.FCell)
    else
      grid.CellsToList(grid.FHintCell);
(*@///     Data grid -> source *)
source.FSaveAlignCell    :=CopyAlignCell (grid.FAlignCell,source.FAlignCell,source.colcount,source.rowcount);
source.FSaveAlignCol     :=CopyAlignCol  (grid.FAlignCol ,source.FAlignCol ,source.colcount);
source.FSaveFixedAlignCol:=CopyAlignCol  (grid.FFAlignCol,source.FFAlignCol,source.colcount);
source.FSaveAlignRow     :=CopyAlignCol  (grid.FAlignRow ,source.FAlignRow ,source.rowcount);
source.FSaveFixedAlignRow:=CopyAlignCol  (grid.FFAlignRow,source.FFAlignRow,source.rowcount);
source.FSaveHint         :=CopyStringCell(grid.FHintCell ,source.FHintCell,source.colcount,source.rowcount);
source.FSaveCells        :=CopyStringCell(grid.FCell     ,source.FCell,source.colcount,source.rowcount);
{   CopyFontCell(grid.FFontCell ,source.FFontCell,source.colcount,source.rowcount); }
{   CopyFontCol (grid.FFontCol  ,source.FFontCol,source.colcount); }
{   CopyFontCol (grid.FFFontCol ,source.FFFontCol,source.colcount); }
{   CopyFontCol (grid.FFontRow  ,source.FFontRow,source.rowcount); }
{   CopyFontCol (grid.FFFontRow ,source.FFFontRow,source.rowcount); }
(*@\\\0000000701*)
    source.ListToCells(source.FCell);
    end;
  edit_form.Free;
  end;
(*@\\\*)
(*@/// procedure TGridComponentEditor.AlignItem(Sender: TObject);    // MenuClick *)
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
              2: grid.ResetFAlignCol(ACol);
              3: grid.ResetAlignRow(ARow);
              4: grid.ResetFAlignRow(ARow);
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
(*@\\\*)
(*@/// procedure TGridComponentEditor.MouseDown(Sender:TObject;..);  // OnPopup *)
procedure TGridComponentEditor.MouseDown(Sender:TObject; Button:TMouseButton; Shift: TSHiftstate; X,Y:Integer);
var
  ACol,ARow: longint;
  i,j: integer;
  Alignment: ^TMyAlign;
  List: TList;
  temp_Point: TPoint;
begin
(*$ifdef ver90 *)
  list:=NIL;  {Delphi 2 shut up ! :-) }
(*$endif *)
  if button=mbRight then begin
    grid.MouseToCell(x,y,ACol,ARow);
    for i:=0 to 4 do
      for j:=0 to 3 do
        align_Items[i,j].checked:=false;
    if (ACol>=0) or (ARow>=0) then begin
      PopupCell.X:=ACol;
      PopupCell.Y:=ARow;
(*@///       AlignCell *)
alignment:=GetItemCell(ACol,ARow,grid.FAlignCell);
align_Items[0,0].checked:=alignment=NIL;
if alignment<>NIL then
  case alignment^ of
    alRight : align_Items[0,1].checked:=true;
    alLeft  : align_Items[0,2].checked:=true;
    alCenter: align_Items[0,3].checked:=true;
    end;
(*@\\\0000000201*)
      for i:=1 to 2 do begin
        case i of
          1: list:=grid.FAlignCol;
          2: list:=grid.FFAlignCol;
          end;
(*@///         AlignCol *)
alignment:=GetItemCol(ACol,List);
align_Items[i,0].checked:=alignment=NIL;
if alignment<>NIL then
  case alignment^ of
    alRight : align_Items[i,1].checked:=true;
    alLeft  : align_Items[i,2].checked:=true;
    alCenter: align_Items[i,3].checked:=true;
    end;
(*@\\\0000000801*)
        end;
      for i:=3 to 4 do begin
        case i of
          3: list:=grid.FAlignRow;
          4: list:=grid.FFAlignRow;
          end;
(*@///         AlignCol *)
alignment:=GetItemCol(ARow,List);
align_Items[i,0].checked:=alignment=NIL;
if alignment<>NIL then
  case alignment^ of
    alRight : align_Items[i,1].checked:=true;
    alLeft  : align_Items[i,2].checked:=true;
    alCenter: align_Items[i,3].checked:=true;
    end;
(*@\\\0000000801*)
        end;
      temp_point:=grid.clienttoscreen(point(x,y));
      popup_menu.popup(temp_point.x,temp_point.y);
      end;
    end;
  end;
(*@\\\*)
(*@\\\0000000601*)

{ The rest are just a few help tools for the Application.OnShowHint and }
{ Application.OnIdle methods - Borland didn't thought of the need to }
{ put more than one method in these places, so I had to do it myself. }
{ Some nice internals how to work with method pointer are presented here. }

{ First a TList which contains TObjects and free's them itself }
type
(*@///   TObjectList = class(TList)              A list which frees it's objects *)
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
(*@\\\0000000B01*)
  TMethodPointer = procedure of object;
(*@///   TMethod = class(TObject)                Object with just one methodpointer *)
TMethod = class(TObject)
public
  methodpointer: TMethodPointer;
  end;
(*@\\\*)

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
(*@\\\0000000318*)
(*@/// function TObjectList.Remove(Item:Pointer):Integer; *)
function TObjectList.Remove(Item:Pointer):Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
  end;
(*@\\\0000000116*)

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
(*@\\\0000000701*)
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
(*@\\\0000000801*)
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
(*@\\\0000000301*)

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
(*@\\\0000000801*)
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
(*@\\\0000000133*)
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
(*@\\\0000000901*)
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
(*@\\\0000000701*)

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
(*@\\\0000000401*)
(*@\\\*)
(*@/// initialization *)
begin
  Dummy:=TDummyObject.Create;
  ShowHintProcs:=TObjectList.Create;
  IdleProcs:=TObjectList.Create;
  AddExitProc(DoneUnit);
(*@\\\000C000519000519000501*)
  end.
(*@\\\0032000101000101000801000801*)
