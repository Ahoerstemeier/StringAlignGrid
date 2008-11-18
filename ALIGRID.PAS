unit Aligrid;
(*$p+t+ *) { These are needed, especially the p must be the same as in forms }

{ Copyright 1995/97 Andreas Hörstemeier            Version 1.6 1997-09-10    }
{ this component is public domain - please check the file readme.txt for     }
{ more detailed info on usage and distributing                               }

{ To do: - More documentation - I started documenting the source, but
           there's still no help file nor a nice demo application
         - Fix the strange drawing of the focus rect when RowSelect is set
           (no bug from me but from Borland themselves :-)
                                                                             }
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

const
  cn_edit_cancel= wm_user+2000;  (* edit finished with ESC *)
  cn_edit_return= wm_user+2001;  (* edit finished with return *)
  cn_edit_exit  = wm_user+2002;  (* edit finished otherwise (cursor) *)
  cn_edit_show  = wm_user+2003;  (* edit is about to be shown *)

type
  TMyAlign=(alRight,alLeft,alCenter);
  TCellEvent = procedure (Sender:TObject; col,row:integer) of object;
(*@///   TNewInplaceEdit = class(TInplaceEdit) *)
TNewInplaceEdit = class(TInplaceEdit)
private
  FAlignment: TMyAlign;
protected
  procedure CreateParams(var Params: TCreateParams); override;
  procedure SetAlignment(Value:TMyAlign);
  procedure KeyPress(var Key: Char); override;
public
  col, row: integer;  (* col and row of the cell *)
  event: boolean;     (* Before edit event already started? *)
  oldtext: string;    (* The text BEFORE the edit started *)
(*$ifdef ver80 *)
  { In Delphi 1's VCL the override is missing in TInplaceEdit }
  constructor Create(AOwner:TComponent);
(*$else *)
  constructor Create(AOwner:TComponent); override;
(*$endif *)
  property Alignment: TMyAlign read FAlignment write SetAlignment;
  property Passwordchar;
end;
(*@\\\*)
(*@///   TStringAlignGrid=class(TStringGrid) *)
TStringAlignGrid = class(TStringGrid)
(*@///   The object creation, destroying and initalizing *)
protected
  procedure Initialize;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
(*@\\\000000041E*)
(*@///   Routines and variables for the alignments *)
protected
  FAlign: TMyAlign;
(*@///   The lists *)
FAlignCol: TList;
FAlignRow: TList;
FFAlignCol: TList;
FFAlignRow: TList;
FAlignCell: TList;
(*@\\\*)
(*@///   The save flags *)
FSaveAlignCell: Boolean;
FSaveAlignCol: Boolean;
FSaveAlignRow: Boolean;
FSaveFixedAlignCol: Boolean;
FSaveFixedAlignRow: Boolean;
(*@\\\*)
(*@///   The DFM read/write procedures *)
procedure ReadAlignCell(Stream: TStream);
procedure WriteAlignCell(Stream: TStream);
procedure ReadAlignCol(Stream: TStream);
procedure WriteAlignCol(Stream: TStream);
procedure ReadAlignRow(Stream: TStream);
procedure WriteAlignRow(Stream: TStream);
procedure ReadFixedAlignCol(Stream: TStream);
procedure WriteFixedAlignCol(Stream: TStream);
procedure ReadFixedAlignRow(Stream: TStream);
procedure WriteFixedAlignRow(Stream: TStream);
(*@\\\0000000925*)
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
(*@\\\0000000201*)
  function ReadAlignColRow(Stream: TStream; list:TList):boolean;
  procedure WriteAlignColRow(Stream: TStream; count: integer; list:TList);
public
(*@///   property AlignCell/AlignCol/FixAlignCol/AlignRow/FixAlignRow *)
property AlignCell[ACol,ARow:integer]: TMyAlign read GetAlignCell write SetAlignCell;
property AlignCol[ACol:integer]: TMyAlign read GetAlignCol write SetAlignCol;
property FixAlignCol[ACol:integer]: TMyAlign read GetFixAlignCol write SetFixAlignCol;
property AlignRow[ARow:integer]: TMyAlign read GetAlignRow write SetAlignRow;
property FixAlignRow[ARow:integer]: TMyAlign read GetFixAlignRow write SetFixAlignRow;
(*@\\\*)
(*@///   procedure ResetAlign...; *)
procedure ResetAlignment;
procedure ResetAlignCell(ACol,ARow:integer);
procedure ResetAlignCol(ACol:integer);
procedure ResetAlignFixedCol(ACol:integer);
procedure ResetAlignRow(ARow:integer);
procedure ResetAlignFixedRow(ARow:integer);
(*@\\\*)
published
  property Alignment: TMyAlign read GetAlign write SetAlign default alLeft;
(*@\\\0000000201*)
(*@///   Routines and variables for the edit-enabled *)
protected
  FEditable: boolean;   { allow switching on editing for single objects only }
  FAlwaysEdit: boolean; { for the component editor to have all cell editable }
(*@///   The lists *)
FEditCol: TList;
FEditRow: TList;
FEditCell: TList;
(*@\\\*)
(*@///   The save flags *)
FSaveEditCell: Boolean;
FSaveEditCol: Boolean;
FSaveEditRow: Boolean;
(*@\\\*)
(*@///   The DFM read/write procedures *)
procedure ReadEditCell(Stream: TStream);
procedure WriteEditCell(Stream: TStream);
procedure ReadEditCol(Stream: TStream);
procedure WriteEditCol(Stream: TStream);
procedure ReadEditRow(Stream: TStream);
procedure WriteEditRow(Stream: TStream);

{ Utility functions }
function ReadEditColRow(Stream: TStream; list:TList):boolean;
procedure WriteEditColRow(Stream: TStream; count: integer; list:TList);
(*@\\\000000062A*)
(*@///   property read/write for the edit-enabled *)
function GetEditCol(ACol: integer):Boolean;
procedure SetEditCol(ACol: integer; const Value: Boolean);

function GetEditRow(ARow:Integer):Boolean;
procedure SetEditRow(ARow:integer; const Value: Boolean);

function GetEditCell(ACol,ARow: integer):Boolean;
procedure SetEditCell(ACol,ARow: integer; const Value: Boolean);
(*@\\\*)
public
(*@///   property EditCell/EditCol/EditRow *)
property EditCell[ACol,ARow:integer]: Boolean read GetEditCell write SetEditCell;
property EditCol[ACol:integer]: Boolean read GetEditCol write SetEditCol;
property EditRow[ARow:integer]: Boolean read GetEditRow write SetEditRow;
(*@\\\*)
(*@///   procedure ResetEdit...; *)
procedure ResetEditCell(ACol,ARow:integer);
procedure ResetEditCol(ACol:integer);
procedure ResetEditRow(ARow:integer);
(*@\\\*)
published
  property Editable:boolean read FEditable write FEditable default true;
(*@\\\0000000303*)
(*@///   Routines and variables for the colors *)
protected
(*@///   The DFM read/write procedures *)
procedure ReadColorCell(Reader: TReader);
procedure ReadColorCol(Reader: TReader);
procedure ReadColorRow(Reader: TReader);
procedure ReadFixedColorCol(Reader: TReader);
procedure ReadFixedColorRow(Reader: TReader);

procedure ReadColorColRow(Reader: TReader; kind:byte);
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

procedure SetFixedColor(const Value: TColor);
(*@\\\*)
public
(*@///   property ColorCell/ColorCol/FixColorCol/ColorRow/FixColorRow *)
property ColorCell[ACol,ARow:integer]: TColor read GetColorCell write SetColorCell;
property ColorCol[ACol:integer]: TColor read GetColorCol write SetColorCol;
property FixColorCol[ACol:integer]: TColor read GetFixColorCol write SetFixColorCol;
property ColorRow[ARow:integer]: TColor read GetColorRow write SetColorRow;
property FixColorRow[ARow:integer]: TColor read GetFixColorRow write SetFixColorRow;
(*@\\\*)
(*@///   procedure ResetColor...; *)
procedure ResetColorCell(ACol,ARow:integer);
procedure ResetColorCol(ACol:integer);
procedure ResetColorFixedCol(ACol:integer);
procedure ResetColorRow(ARow:integer);
procedure ResetColorFixedRow(ARow:integer);
(*@\\\*)
published
  property FixedColor write SetFixedColor;
(*@\\\*)
(*@///   Routines and variables for the selected colors *)
protected
(*@///   The lists *)
FSelColorCol: TList;
FSelColorRow: TList;
FSelColorCell: TList;
(*@\\\*)
(*@///   The save flags *)
FSaveSelColorCell: Boolean;
FSaveSelColorCol: Boolean;
FSaveSelColorRow: Boolean;
(*@\\\0000000106*)
(*@///   The DFM read/write procedures *)
procedure ReadSelColorCell(Reader: TReader);
procedure ReadSelColorCol(Reader: TReader);
procedure ReadSelColorRow(Reader: TReader);
procedure WriteSelColorCell(Writer: TWriter);
procedure WriteSelColorCol(Writer: TWriter);
procedure WriteSelColorRow(Writer: TWriter);

function ReadSelColorColRow(Reader: TReader; list:TList):boolean;
procedure WriteSelColorColRow(Writer: TWriter; count:integer; list:TList);
(*@\\\0000000841*)
(*@///   property read/write for the colors *)
function GetSelColorCol(ACol: integer):TColor;
procedure SetSelColorCol(ACol: integer; const Value: TColor);

function GetSelColorRow(ARow:Integer):TColor;
procedure SetSelColorRow(ARow:integer; const Value: TColor);

function GetSelColorCell(ACol,ARow: integer):TColor;
procedure SetSelColorCell(ACol,ARow: integer; const Value: TColor);
(*@\\\000000012E*)
public
(*@///   property ColorCell/ColorCol/FixColorCol/ColorRow/FixColorRow *)
property SelectedColorCell[ACol,ARow:integer]: TColor read GetSelColorCell write SetSelColorCell;
property SelectedColorCol[ACol:integer]: TColor read GetSelColorCol write SetSelColorCol;
property SelectedColorRow[ARow:integer]: TColor read GetSelColorRow write SetSelColorRow;
(*@\\\0000000301*)
(*@///   procedure ResetColor...; *)
procedure ResetSelectedColorCell(ACol,ARow:integer);
procedure ResetSelectedColorCol(ACol:integer);
procedure ResetSelectedColorRow(ARow:integer);
(*@\\\0000000301*)
(*@\\\0000000201*)
(*@///   Routines and variables for the selected font colors *)
protected
(*@///   The lists *)
FSelFontColorCol: TList;
FSelFontColorRow: TList;
FSelFontColorCell: TList;
(*@\\\0000000105*)
(*@///   The save flags *)
FSaveSelFontColorCell: Boolean;
FSaveSelFontColorCol: Boolean;
FSaveSelFontColorRow: Boolean;
(*@\\\0000000109*)
(*@///   The DFM read/write procedures *)
procedure ReadSelFontColorCell(Reader: TReader);
procedure ReadSelFontColorCol(Reader: TReader);
procedure ReadSelFontColorRow(Reader: TReader);
procedure WriteSelFontColorCell(Writer: TWriter);
procedure WriteSelFontColorCol(Writer: TWriter);
procedure WriteSelFontColorRow(Writer: TWriter);
(*@\\\0000000631*)
(*@///   property read/write for the colors *)
function GetSelFontColorCol(ACol: integer):TColor;
procedure SetSelFontColorCol(ACol: integer; const Value: TColor);

function GetSelFontColorRow(ARow:Integer):TColor;
procedure SetSelFontColorRow(ARow:integer; const Value: TColor);

function GetSelFontColorCell(ACol,ARow: integer):TColor;
procedure SetSelFontColorCell(ACol,ARow: integer; const Value: TColor);
(*@\\\0000000848*)
public
(*@///   property ColorCell/ColorCol/FixColorCol/ColorRow/FixColorRow *)
property SelectedFontColorCell[ACol,ARow:integer]: TColor read GetSelFontColorCell write SetSelFontColorCell;
property SelectedFontColorCol[ACol:integer]: TColor read GetSelFontColorCol write SetSelFontColorCol;
property SelectedFontColorRow[ARow:integer]: TColor read GetSelFontColorRow write SetSelFontColorRow;
(*@\\\0000000301*)
(*@///   procedure ResetColor...; *)
procedure ResetSelectedFontColorCell(ACol,ARow:integer);
procedure ResetSelectedFontColorCol(ACol:integer);
procedure ResetSelectedFontColorRow(ARow:integer);
(*@\\\*)
(*@\\\0000000201*)
(*@///   Routines and variables for the hints *)
protected
  FHintCellLast: TPoint;
  FShowCellHints: Boolean;
  FHintCell: TList;
  FSaveHint: Boolean;
  procedure ReadHint(Reader: TReader);
  procedure WriteHint(Writer: TWriter);
  function GetHintCell(ACol,ARow: integer):string;
  procedure SetHintCell(ACol,ARow: integer; const Value: string);
  procedure ShowHintCell(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
public
  property HintCell[ACol,ARow:integer]:string read GetHintCell write SetHintCell;
published
  property ShowCellHints: boolean read FShowCellHints write FShowCellHints default true;
(*@\\\0000000B01*)
(*@///   Routines and variables for the cells itself *)
protected
  FCell: TList;        { Only for loading and saving the cells property }
  FSaveCells: Boolean;
  procedure ReadCells(Reader: TReader);
  procedure WriteCells(Writer: TWriter);
  procedure ListToCells(List:TList);
  procedure CellsToList(var List:TList);
(*@\\\*)
(*@///   Routines and variables for the fonts *)
protected
(*@///   The lists *)
FFontCol: TList;
FFontRow: TList;
FFFontCol: TList;
FFFontRow: TList;
FFontCell: TList;
(*@\\\*)
(*@///   The save flags *)
FSaveFontCell: Boolean;
FSaveFontCol: Boolean;
FSaveFontRow: Boolean;
FSaveFixedFontCol: Boolean;
FSaveFixedFontRow: Boolean;
(*@\\\*)
(*@///   The DFM read/write procedures *)
procedure ReadFontCell(Reader: TReader);
procedure WriteFontCell(Writer: TWriter);
procedure ReadFontCol(Reader: TReader);
procedure WriteFontCol(Writer: TWriter);
procedure ReadFontRow(Reader: TReader);
procedure WriteFontRow(Writer: TWriter);
procedure ReadFixedFontCol(Reader: TReader);
procedure WriteFixedFontCol(Writer: TWriter);
procedure ReadFixedFontRow(Reader: TReader);
procedure WriteFixedFontRow(Writer: TWriter);

function ReadFontCellInt(Reader: TReader; list:TList):boolean;
procedure WriteFontCellInt(Writer: TWriter; x,y:integer; list:TList);
function ReadFontColRow(Reader: TReader; list:TList):boolean;
procedure WriteFontColRow(Writer: TWriter; count: integer; list:TList);

procedure WriteFont(Writer: TWriter; v:TFont);
function ReadFont(Reader: TReader):TFont;
(*@\\\*)
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
(*@///   utility functions *)
function GetFontCellComplete(ACol,ARow: integer):TFont;
function GetFontCellInternal(ACol,ARow: integer; create:boolean):TFont;
procedure FontChanged(AFont: TObject);
(*@\\\*)
public
(*@///   property CellFont/ColFont/FixedColFont/RowFont/FixedRowFont *)
property CellFont[ACol,ARow:integer]: TFont read GetFontCell write SetFontCell;
property ColFont[ACol:integer]: TFont read GetFontCol write SetFontCol;
property RowFont[ARow:integer]: TFont read GetFontRow write SetFontRow;
property FixedColFont[ACol:integer]: TFont read GetFontFixedCol write SetFontFixedCol;
property FixedRowFont[ARow:integer]: TFont read GetFontFixedRow write SetFontFixedRow;
(*@\\\*)
(*@///   procedure Reset...; *)
procedure ResetFontCell(ACol,ARow:integer);
procedure ResetFontCol(ACol:integer);
procedure ResetFontFixedCol(ACol:integer);
procedure ResetFontRow(ARow:integer);
procedure ResetFontFixedRow(ARow:integer);
(*@\\\*)
(*@\\\0000000401*)
(*@///   Routines and variables for the brushs *)
protected
(*@///   The lists *)
FBrushCol: TList;
FBrushRow: TList;
FFBrushCol: TList;
FFBrushRow: TList;
FBrushCell: TList;
FFixedBrush: TBrush;
(*@\\\0000000601*)
(*@///   The save flags *)
FSaveBrushCell: Boolean;
FSaveBrushCol: Boolean;
FSaveBrushRow: Boolean;
FSaveFixedBrushCol: Boolean;
FSaveFixedBrushRow: Boolean;
(*@\\\*)
(*@///   The DFM read/write procedures *)
procedure ReadBrushCell(Reader: TReader);
procedure WriteBrushCell(Writer: TWriter);
procedure ReadBrushCol(Reader: TReader);
procedure WriteBrushCol(Writer: TWriter);
procedure ReadBrushRow(Reader: TReader);
procedure WriteBrushRow(Writer: TWriter);
procedure ReadFixedBrushCol(Reader: TReader);
procedure WriteFixedBrushCol(Writer: TWriter);
procedure ReadFixedBrushRow(Reader: TReader);
procedure WriteFixedBrushRow(Writer: TWriter);

function ReadBrushColRow(Reader: TReader; list:TList):boolean;
procedure WriteBrushColRow(Writer: TWriter; count: integer; list:TList);
function ReadBrushCellInt(Reader: TReader; list:TList):boolean;
procedure WriteBrushCellInt(Writer: TWriter; x,y:integer; list:TList);

procedure WriteBrush(Writer: TWriter; v:TBrush);
function ReadBrush(Reader: TReader):TBrush;
(*@\\\*)
(*@///   property read/write for the brushs *)
function GetBrushCell(ACol,ARow: integer):TBrush;
procedure SetBrushCell(ACol,ARow: integer; const Value: TBrush);

function GetBrushCol(ACol: integer):TBrush;
procedure SetBrushCol(ACol: integer; const Value: TBrush);
function GetBrushFixedCol(ACol: integer):TBrush;
procedure SetBrushFixedCol(ACol: integer; const Value: TBrush);
function GetBrushRow(ARow: integer):TBrush;
procedure SetBrushRow(ARow: integer; const Value: TBrush);
function GetBrushFixedRow(ARow: integer):TBrush;
procedure SetBrushFixedRow(ARow: integer; const Value: TBrush);
function GetBrushColRowInternal(AColRow: integer; create:boolean; List:TList):TBrush;
(*@\\\0000000C01*)
(*@///   utility functions *)
function GetBrushCellComplete(ACol,ARow: integer):TBrush;
function GetBrushCellInternal(ACol,ARow: integer; create:boolean):TBrush;
procedure BrushChanged(AFont: TObject);
(*@\\\*)
public
(*@///   property CellBrush/ColBrush/FixedColBrush/RowBrush/FixedRowBrush *)
{ The Brush for each cell and for col and row }
property CellBrush[ACol,ARow:integer]: TBrush read GetBrushCell write SetBrushCell;
property ColBrush[ACol:integer]: TBrush read GetBrushCol write SetBrushCol;
property RowBrush[ARow:integer]: TBrush read GetBrushRow write SetBrushRow;
property FixedColBrush[ACol:integer]: TBrush read GetBrushFixedCol write SetBrushFixedCol;
property FixedRowBrush[ARow:integer]: TBrush read GetBrushFixedRow write SetBrushFixedRow;
(*@\\\*)
(*@///   procedure ResetBrush...; *)
procedure ResetBrushCell(ACol,ARow:integer);
procedure ResetBrushCol(ACol:integer);
procedure ResetBrushFixedCol(ACol:integer);
procedure ResetBrushRow(ARow:integer);
procedure ResetBrushFixedRow(ARow:integer);
(*@\\\*)
(*@\\\0000000201*)
(*@///   The Inplace-Edit and it's events sent to the grid *)
protected
  edit_visible: boolean;
  f_on_after_edit: TCellEvent;
  f_on_cancel_edit: TCellEvent;
  f_on_before_edit: TCellEvent;
  function CreateEditor: TInplaceEdit; override;
  function CanEditShow: Boolean; override;
  procedure mcn_edit_return(var msg:TMessage); message cn_edit_return;
  procedure mcn_edit_cancel(var msg:TMessage); message cn_edit_cancel;
  procedure mcn_edit_exit(var msg:TMessage); message cn_edit_exit;
  procedure mcn_edit_show(var msg:TMessage); message cn_edit_show;
  procedure doExit; override;
public
  procedure ShowEdit;
  procedure HideEdit(cancel:boolean);
published
  property OnAfterEdit: TCellEvent read f_on_after_edit write f_on_after_edit;
  property OnCancelEdit: TCellEvent read f_on_cancel_edit write f_on_cancel_edit;
  property OnBeforeEdit: TCellEvent read f_on_before_edit write f_on_before_edit;
(*@\\\*)
(*@///   Insertion and removing and moving of columns and rows *)
protected
  procedure RowMoved(FromIndex, ToIndex: Longint); override;
  procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
public
  procedure RemoveCol(ACol:Integer);
  procedure RemoveRow(ARow:Integer);
  procedure InsertCol(ACol:Integer);
  procedure InsertRow(ARow:Integer);
(*@\\\000000010A*)
(*@///   Import and export functions *)
public
  function Contents2HTML(data:TMemorystream):TMemorystream;
  function Contents2CSV(data:TMemorystream; csv:char; range:TGridRect):TMemorystream;
  procedure CSV2Contents(data:TStream; csv:char; range:TGridRect);
  procedure SaveToFile(const filename:string);
  procedure LoadFromFile(const filename:string);
(*@\\\0000000631*)
(*@///   Miscellaneous stuff *)
protected
  function is_fixed(ACol,ARow: integer):boolean;
public
  procedure ClearSelection;
  procedure NextEditableCell(var ACol,ARow:integer);
(*@\\\0000000201*)
(*@///   For the DFM read/write *)
protected
  procedure Loaded; override;
  procedure DefineProperties(Filer: TFiler); override;
(*@\\\000000010A*)
(*@///   The other properties *)
protected
  f_SelFontColor: TColor;
  f_SelCellColor: TColor;
  procedure SetSelCellColor(Value: TColor);
  procedure SetSelFontColor(Value: TColor);
protected
  f_nextcell: Boolean;
  f_fixedcols, f_fixedrows: integer;
published
  property SelectedCellColor:TColor read f_SelCellColor write SetSelCellColor default clActiveCaption;
  property SelectedFontColor:TColor read f_SelFontColor write SetSelFontColor default clWhite;
  property AutoEditNextCell: boolean read f_nextcell write f_nextcell default false;
(*@\\\0000000201*)
(*@///   The main procedure DrawCell *)
protected
  procedure DrawCell(ACol,ARow:Longint; ARect:TRect; AState:TGridDrawState); override;
(*@\\\0000000201*)
  end;
(*@\\\0000001101*)
(*@///   TGridComponentEditor = class(TComponentEditor) *)
TGridComponentEditor = class(TComponentEditor)
private
  Align_Items: array[0..4,0..3] of TMenuItem;
  Edit_Items: array[0..2,0..2] of TMenuItem;
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
  procedure EditItem(Sender: TObject);
  procedure MouseDown(Sender:TObject; Button:TMouseButton; Shift: TSHiftstate; X,Y:Integer);
  end;
(*@\\\*)

procedure AddShowHintProc(proc:TShowHintEvent);
procedure RemoveShowHintProc(proc:TShowHintEvent);
procedure AddIdleProc(proc:TIdleEvent);
procedure RemoveIdleProc(proc:TIdleEvent);

procedure Register;
(*@\\\0030000E01000F01000E01*)
(*@/// implementation *)
implementation

(*@/// Some internal utility procedures *)
{ Clean my internal lists for the three kinds of data }

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

{ Write a string into a stream }
(*@/// procedure String2Stream(stream:TMemorystream; const s:string); *)
procedure String2Stream(stream:TMemorystream; const s:string);
begin
  stream.write(s[1],length(s));
  end;
(*@\\\*)
(*@\\\0000000701*)

(*@/// TMyFont              = class(TFont)            // To remember if changed *)
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
(*@\\\*)
(*@/// TMyBrush             = class(TBrush)           // To remember if changed *)
type
  TMyBrush = class(TBrush)
  protected
    procedure Changed; override;
  public
    HasChanged: boolean;
    end;

(*@/// procedure TMyBrush.Changed; *)
procedure TMyBrush.Changed;
begin
  HasChanged:=true;
  inherited changed;
  end;
(*@\\\*)
(*@\\\000000091C*)
(*@/// TNewInplaceEdit      = class(TInplaceEdit)     // The internal cell editor *)
(*@/// procedure TNewInplaceEdit.CreateParams(var Params: TCreateParams); *)
procedure TNewInplaceEdit.CreateParams(var Params: TCreateParams);
const
  Alignments : array[TMyAlign] of Longint = (ES_RIGHT,ES_LEFT,ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style
{     and (not ES_MULTILINE)    (* otherwise the passwordchar won't work *) }
                                (* but makes it behave erratically *)
    or Alignments[FAlignment];
  end;
(*@\\\0000000901*)
(*@/// procedure TNewInplaceEdit.SetAlignment(Value: TMyAlign); *)
procedure TNewInplaceEdit.SetAlignment(Value: TMyAlign);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    RecreateWnd;
    SetSel(0,-1);
    end;
  end;
(*@\\\0000000701*)
(*@/// constructor TNewInplaceEdit.Create(AOwner:TComponent); *)
constructor TNewInplaceEdit.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FAlignment := alLeft;
  end;
(*@\\\0000000401*)
(*@/// procedure TNewInplaceEdit.KeyPress(var Key: Char); *)
procedure TNewInplaceEdit.KeyPress(var Key: Char);
begin
  if (col=-1) or (row=-1) then key:=#0;
  if key=#13 then
    postmessage(TStringAlignGrid(self.owner).handle,cn_edit_return,col,row);
  if key=#27 then begin
    self.text:=oldtext;
    postmessage(TStringAlignGrid(self.owner).handle,cn_edit_cancel,col,row);
    key:=#13;
    end;
  inherited KeyPress(Key);
  end;
(*@\\\0000000501*)
(*@\\\000C000101000101*)
(*@/// TStringAlignGrid     = class(TStringGrid)      // The grid itself *)
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

  FSaveEditCell:=false;
  FSaveEditCol:=false;
  FSaveEditRow:=false;

  FSaveSelColorCell:=false;
  FSaveSelColorCol:=false;
  FSaveSelColorRow:=false;

  FSaveSelFontColorCell:=false;
  FSaveSelFontColorCol:=false;
  FSaveSelFontColorRow:=false;

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
(*@\\\0000000301*)
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

(*@///   FEditCol.Free; *)
if FEditCol<>NIL then
  cleanlist(FEditCol,sizeof(boolean));
FEditCol.Free;
FEditCol:=NIL;
(*@\\\0000000224*)
(*@///   FEditRow.Free; *)
if FEditRow<>NIL then
  cleanlist(FEditRow,sizeof(boolean));
FEditRow.Free;
FEditRow:=NIL;
(*@\\\0000000224*)
(*@///   FEditCell.Free; *)
if FEditCell<>NIL then
  for i:=0 to FEditCell.Count-1 do
    cleanlist(TList(FEditCell.Items[i]),sizeof(boolean));
FEditCell.Free;
FEditCell:=NIL;
(*@\\\0000000337*)

(*@///   FSelColorCol.Free; *)
if FSelColorCol<>NIL then
  cleanlist(FSelColorCol,sizeof(TColor));
FSelColorCol.Free;
FSelColorCol:=NIL;
(*@\\\0000000413*)
(*@///   FSelColorRow.Free; *)
if FSelColorRow<>NIL then
  cleanlist(FSelColorRow,sizeof(TColor));
FSelColorRow.Free;
FSelColorRow:=NIL;
(*@\\\0000000413*)
(*@///   FSelColorCell.Free; *)
if FSelColorCell<>NIL then
  for i:=0 to FSelColorCell.Count-1 do
    cleanlist(TList(FSelColorCell.Items[i]),sizeof(TColor));
FSelColorCell.Free;
FSelColorCell:=NIL;
(*@\\\0000000514*)

(*@///   FSelFontColorCol.Free; *)
if FSelFontColorCol<>NIL then
  cleanlist(FSelFontColorCol,sizeof(TColor));
FSelFontColorCol.Free;
FSelFontColorCol:=NIL;
(*@\\\0000000417*)
(*@///   FSelFontColorRow.Free; *)
if FSelFontColorRow<>NIL then
  cleanlist(FSelFontColorRow,sizeof(TColor));
FSelFontColorRow.Free;
FSelFontColorRow:=NIL;
(*@\\\0000000417*)
(*@///   FSelFontColorCell.Free; *)
if FSelFontColorCell<>NIL then
  for i:=0 to FSelFontColorCell.Count-1 do
    cleanlist(TList(FSelFontColorCell.Items[i]),sizeof(TColor));
FSelFontColorCell.Free;
FSelFontColorCell:=NIL;
(*@\\\0000000518*)

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

(*@///   FBrushCol.Free; *)
if FBrushCol<>NIL then
  cleanlist_object(FBrushCol);
FBrushCol.Free;
FBrushCol:=NIL;
(*@\\\*)
(*@///   FBrushRow.Free; *)
if FBrushRow<>NIL then
  cleanlist_object(FBrushRow);
FBrushRow.Free;
FBrushRow:=NIL;
(*@\\\*)
(*@///   FFBrushCol.Free; *)
if FFBrushCol<>NIL then
  cleanlist_object(FFBrushCol);
FFBrushCol.Free;
FFBrushCol:=NIL;
(*@\\\*)
(*@///   FFBrushRow.Free; *)
if FFBrushRow<>NIL then
  cleanlist_object(FFBrushRow);
FFBrushRow.Free;
FFBrushRow:=NIL;
(*@\\\*)
(*@///   FBrushCell.Free; *)
if FBrushCell<>NIL then
  for i:=0 to FBrushCell.Count-1 do
    cleanlist_object(TList(FBrushCell.Items[i]));
FBrushCell.Free;
FBrushCell:=NIL;
(*@\\\*)

(*@///   FHintCell.Free; *)
if FHintCell<>NIL then
  for i:=0 to FHintCell.Count-1 do
    cleanlist_pstring(TList(FHintCell.Items[i]));
FHintCell.Free;
FHintCell:=NIL;
(*@\\\*)
(*@///   FCell.Free; *)
if FCell<>NIL then
  for i:=0 to FCell.Count-1 do
    cleanlist_pstring(TList(FCell.Items[i]));
FCell.Free;
FCell:=NIL;
(*@\\\*)
  FFixedBrush.free;
  RemoveShowHintProc(ShowHintCell);
  inherited Destroy;
  end;
(*@\\\0000001504*)
(*@/// procedure TStringAlignGrid.Initialize; *)
procedure TStringAlignGrid.Initialize;
begin
  FAlignCell:=TList.Create;
  FAlignCol:=TList.Create;
  FFAlignCol:=TList.Create;
  FAlignRow:=TList.Create;
  FFAlignRow:=TList.Create;
  FEditCell:=TList.Create;
  FEditCol:=TList.Create;
  FEditRow:=TList.Create;
  FSelColorCol:=TList.Create;
  FSelColorRow:=TList.Create;
  FSelColorCell:=TList.Create;
  FSelFontColorCol:=TList.Create;
  FSelFontColorRow:=TList.Create;
  FSelFontColorCell:=TList.Create;
  FHintCell:=TList.Create;
  FCell:=TList.Create;
  FFontCell:=TList.Create;
  FFontCol:=TList.Create;
  FFFontCol:=TList.Create;
  FFontRow:=TList.Create;
  FFFontRow:=TList.Create;
  FBrushCell:=TList.Create;
  FBrushCol:=TList.Create;
  FFBrushCol:=TList.Create;
  FBrushRow:=TList.Create;
  FFBrushRow:=TList.Create;
  FAlign:=alLeft;
  FShowCellHints:=true;
  FHintCellLast:=point(-1,-1);
  f_SelCellColor:=clActiveCaption;
  f_SelFontColor:=clWhite;
  f_fixedcols:=0;
  f_fixedrows:=0;
  f_nextcell:=false;
  FAlwaysEdit:=false;
  FFixedBrush:=TMyBrush.Create;
  FFixedBrush.Color:=FixedColor;
  FFixedBrush.OnChange:=BrushChanged;
  AddShowHintProc(ShowHintCell);
  end;
(*@\\\0000002A07*)
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
(*@\\\*)
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
(*@\\\0000000C01*)
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
(*@\\\0000000301*)

(*@/// Property read and write and reset for the Alignments *)
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

(*@/// Reset alignment and use the one defined a level above *)
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
(*@\\\*)
(*@\\\0000000601*)
(*@/// Property read and write and reset for the edit-enabled *)
(*@/// Property read and write for EditCell *)
{ Property read and write for EditCell }
(*@/// function TStringAlignGrid.GetEditCell(ACol,ARow:Integer):boolean; *)
function TStringAlignGrid.GetEditCell(ACol,ARow:Integer):boolean;
var
  v:^boolean;
begin
  v:=GetItemCell(ACol,ARow,FEditCell);
  if v=NIL then begin
    v:=GetItemCol(ACol,FEditCol);
    if v=NIL then begin
      v:=GetItemCol(ARow,FEditRow);
      if v=NIL then
        result:=FEditable
      else
        result:=v^;
      end
    else
      result:=v^;
    end
  else
    result:=v^;
  end;
(*@\\\0000000B01*)
(*@/// procedure TStringAlignGrid.SetEditCell(ACol,ARow:integer; const Value: boolean); *)
procedure TStringAlignGrid.SetEditCell(ACol,ARow:integer; const Value: boolean);
var
  v:^boolean;
begin
  FSaveEditCell:=true;
  New(v);
  v^:=value;
  v:=SetItemCell(ACol,ARow, FEditCell, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\0000000201*)
(*@/// Property read and write for EditCol *)
{ Property read and write for EditCol  }
(*@/// function TStringAlignGrid.GetEditCol(ACol:Integer):boolean; *)
function TStringAlignGrid.GetEditCol(ACol:Integer):boolean;
var
  v:^boolean;
begin
  v:=GetItemCol(ACol, FEditCol);
  if v=NIL then
    GetEditCol:=true
  else
    GetEditCol:=v^;
  end;
(*@\\\0000000707*)
(*@/// procedure TStringAlignGrid.SetEditCol(ACol:integer; const Value: boolean); *)
procedure TStringAlignGrid.SetEditCol(ACol:integer; const Value: boolean);
var
  v:^boolean;
begin
  FSaveEditCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FEditCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000C07*)
(*@\\\0000000201*)
(*@/// Property read and write for EditRow *)
{ Property read and write for EditRow  }
(*@/// function TStringAlignGrid.GetAlignRow(ARow:Integer):boolean; *)
function TStringAlignGrid.GetEditRow(ARow:Integer):boolean;
var
  v:^boolean;
begin
  v:=GetItemCol(ARow, FEditRow);
  if v=NIL then
    GetEditRow:=true
  else
    GetEditRow:=v^;
  end;
(*@\\\0000000A07*)
(*@/// procedure TStringAlignGrid.SetEditRow(ARow:integer; const Value: boolean); *)
procedure TStringAlignGrid.SetEditRow(ARow:integer; const Value: boolean);
var
  v:^boolean;
begin
  FSaveEditRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FEditRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000C07*)
(*@\\\0000000301*)

(*@/// Reset edit-enabled and use the one defined a level above *)
(*@/// procedure TStringAlignGrid.ResetEditCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetEditCell(ACol,ARow:integer);
var
  v:^boolean;
begin
  v:=SetItemCell(ACol,ARow, FEditCell, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000907*)
(*@/// procedure TStringAlignGrid.ResetEditCol(ACol:integer); *)
procedure TStringAlignGrid.ResetEditCol(ACol:integer);
var
  v:^boolean;
begin
  v:=SetItemCol(ACol, FEditCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\000000030D*)
(*@/// procedure TStringAlignGrid.ResetEditRow(ARow:integer); *)
procedure TStringAlignGrid.ResetEditRow(ARow:integer);
var
  v:^boolean;
begin
  v:=SetItemCol(ARow, FEditRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\000000030A*)
(*@\\\*)
(*@\\\0000000301*)
(*@/// Property read and write and reset for Fonts *)
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
(*@\\\0000000701*)
(*@\\\0000000301*)
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
(*@\\\0000000501*)
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
(*@\\\0000000401*)

(*@/// Reset font and use the one defined a level above *)
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
(*@\\\0000000501*)
(*@/// Property read and write and reset for Brushs *)
(*@/// Property read and write for BrushCell *)
{ Property read and write for BrushCell }
(*@/// function TStringAlignGrid.GetBrushCell(ACol,ARow: integer):TBrush; *)
function TStringAlignGrid.GetBrushCell(ACol,ARow: integer):TBrush;
begin
  GetBrushCell:=GetBrushCellInternal(ACol,ARow,true);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.SetBrushCell(ACol,ARow: integer; const Value: TBrush); *)
procedure TStringAlignGrid.SetBrushCell(ACol,ARow: integer; const Value: TBrush);
var
  v: pointer;
begin
  v:=TMyBrush.Create;
  TBrush(v).Assign(value);
  TBrush(v).OnChange:=BrushChanged;
  TMyBrush(v).HasChanged:=true;
  v:=SetItemCell(ACol,ARow, FBrushCell, v);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\000000070D*)
(*@\\\0000000301*)
(*@/// Property read and write for BrushCol/FixedBrushCol *)
{ Property read and write for BrushCol/FixedBrushCol }
(*@/// function TStringAlignGrid.GetBrushCol(ACol: integer):TBrush; *)
function TStringAlignGrid.GetBrushCol(ACol: integer):TBrush;
begin
  GetBrushCol:=GetBrushColRowInternal(ACol,true,FBrushCol);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.SetBrushCol(ACol: integer; const Value: TBrush); *)
procedure TStringAlignGrid.SetBrushCol(ACol: integer; const Value: TBrush);
var
  v: pointer;
begin
  v:=TMyBrush.Create;
  TMyBrush(v).Assign(value);
  TMyBrush(v).OnChange:=BrushChanged;
  TMyBrush(v).HasChanged:=true;
  v:=SetItemCol(ACol, FBrushCol, v);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetBrushFixedCol(ACol: integer):TBrush; *)
function TStringAlignGrid.GetBrushFixedCol(ACol: integer):TBrush;
begin
  GetBrushFixedCol:=GetBrushColRowInternal(ACol,true,FFBrushCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetBrushFixedCol(ACol: integer; const Value: TBrush); *)
procedure TStringAlignGrid.SetBrushFixedCol(ACol: integer; const Value: TBrush);
var
  v: pointer;
begin
  v:=TMyBrush.Create;
  TMyBrush(v).Assign(value);
  TMyBrush(v).OnChange:=BrushChanged;
  TMyBrush(v).HasChanged:=true;
  v:=SetItemCol(ACol, FFBrushCol, v);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@\\\0000000301*)
(*@/// Property read and write for BrushRow/FixedBrushRow *)
{ Property read and write for BrushRow }
(*@/// function TStringAlignGrid.GetBrushRow(ARow: integer):TBrush; *)
function TStringAlignGrid.GetBrushRow(ARow: integer):TBrush;
begin
  GetBrushRow:=GetBrushColRowInternal(ARow,true,FBrushRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetBrushRow(ARow: integer; const Value: TBrush); *)
procedure TStringAlignGrid.SetBrushRow(ARow: integer; const Value: TBrush);
var
  v: pointer;
begin
  v:=TMyBrush.Create;
  TMyBrush(v).Assign(value);
  TMyBrush(v).OnChange:=BrushChanged;
  TMyBrush(v).HasChanged:=true;
  v:=SetItemCol(ARow, FBrushRow, v);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetBrushFixedRow(ARow: integer):TBrush; *)
function TStringAlignGrid.GetBrushFixedRow(ARow: integer):TBrush;
begin
  GetBrushFixedRow:=GetBrushColRowInternal(ARow,true,FFBrushRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetBrushFixedRow(ARow: integer; const Value: TBrush); *)
procedure TStringAlignGrid.SetBrushFixedRow(ARow: integer; const Value: TBrush);
var
  v: pointer;
begin
  v:=TMyBrush.Create;
  TMyBrush(v).Assign(value);
  TMyBrush(v).OnChange:=BrushChanged;
  TMyBrush(v).HasChanged:=true;
  v:=SetItemCol(ARow, FFBrushRow, v);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)

(*@/// Reset brush and use the one defined a level above *)
(*@/// procedure TStringAlignGrid.ResetBrushCol(ACol:integer); *)
procedure TStringAlignGrid.ResetBrushCol(ACol:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ACol, FBrushCol, NIL);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetBrushFixedCol(ACol:integer); *)
procedure TStringAlignGrid.ResetBrushFixedCol(ACol:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ACol, FFBrushCol, NIL);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetBrushRow(ARow:integer); *)
procedure TStringAlignGrid.ResetBrushRow(ARow:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ARow, FBrushRow, NIL);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetBrushFixedRow(ARow:integer); *)
procedure TStringAlignGrid.ResetBrushFixedRow(ARow:integer);
var
  v:pointer;
begin
  v:=SetItemCol(ARow, FFBrushRow, NIL);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetBrushCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetBrushCell(ACol,ARow:integer);
var
  v:pointer;
begin
  v:=SetItemCell(ACol,ARow, FBrushCell, NIL);
  if v<>NIL then
    TBrush(v).Free;
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@\\\*)
(*@/// Property read and write and reset for Colors (done via Brushes!) *)
(*@/// Property read and write for ColorCell *)
{ Property read and write for ColorCell }
(*@/// function TStringAlignGrid.GetColorCell(ACol,ARow:Integer):TColor; *)
function TStringAlignGrid.GetColorCell(ACol,ARow:Integer):TColor;
begin
  result:=GetBrushCellComplete(ACol,ARow).color;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetColorCell(ACol,ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetColorCell(ACol,ARow:integer; const Value: TColor);
begin
  CellBrush[ACol,ARow].Color:=value;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for ColorCol and FixedColorCol *)
{ Property read and write for ColorCol and FixedColorCol }
(*@/// function TStringAlignGrid.GetColorCol(ACol:Integer):TColor; *)
function TStringAlignGrid.GetColorCol(ACol:Integer):TColor;
var
  h: TBrush;
begin
  h:=GetBrushColRowInternal(ACol,false,FBrushCol);
  if h<>NIL then
    result:=h.color
  else
    result:=self.color;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetColorCol(ACol:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetColorCol(ACol:integer; const Value: TColor);
begin
  ColBrush[Acol].color:=value;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFixColorCol(ACol:Integer):TColor; *)
function TStringAlignGrid.GetFixColorCol(ACol:Integer):TColor;
var
  h: TBrush;
begin
  h:=GetBrushColRowInternal(ACol,false,FFBrushCol);
  if h<>NIL then
    result:=h.color
  else
    result:=self.color;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFixColorCol(ACol:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetFixColorCol(ACol:integer; const Value: TColor);
begin
  FixedColBrush[Acol].color:=value;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for ColorRow and FixedColorRow *)
{ Property read and write for ColorRow and FixedColorRow }
(*@/// function TStringAlignGrid.GetColorRow(ARow:Integer):TColor; *)
function TStringAlignGrid.GetColorRow(ARow:Integer):TColor;
var
  h: TBrush;
begin
  h:=GetBrushColRowInternal(ARow,false,FBrushRow);
  if h<>NIL then
    result:=h.color
  else
    result:=self.color;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetColorRow(ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetColorRow(ARow:integer; const Value: TColor);
begin
  RowBrush[ARow].color:=value;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetFixColorRow(ARow:Integer):TColor; *)
function TStringAlignGrid.GetFixColorRow(ARow:Integer):TColor;
var
  h: TBrush;
begin
  h:=GetBrushColRowInternal(ARow,false,FBrushRow);
  if h<>NIL then
    result:=h.color
  else
    result:=self.color;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetFixColorRow(ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetFixColorRow(ARow:integer; const Value: TColor);
begin
  FixedRowBrush[ARow].color:=value;
  end;
(*@\\\*)
(*@\\\*)

(*@/// Reset color and use the one defined a level above *)
(*@/// procedure TStringAlignGrid.ResetColorCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetColorCell(ACol,ARow:integer);
begin
  ResetBrushCell(ACol,ARow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorCol(ACol:integer); *)
procedure TStringAlignGrid.ResetColorCol(ACol:integer);
begin
  ResetBrushCol(ACol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorFixedCol(ACol:integer); *)
procedure TStringAlignGrid.ResetColorFixedCol(ACol:integer);
begin
  ResetBrushFixedCol(ACol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorRow(ARow:integer); *)
procedure TStringAlignGrid.ResetColorRow(ARow:integer);
begin
  ResetBrushRow(ARow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetColorFixedRow(ARow:integer); *)
procedure TStringAlignGrid.ResetColorFixedRow(ARow:integer);
begin
  ResetBrushFixedRow(ARow);
  end;
(*@\\\*)
(*@\\\*)

(*@/// procedure TStringAlignGrid.SetFixedColor(const Value: TColor); *)
procedure TStringAlignGrid.SetFixedColor(const Value: TColor);
begin
  inherited FixedColor:=value;
  FFixedBrush.color:=value;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetSelCellColor(Value: TColor); *)
procedure TStringAlignGrid.SetSelCellColor(Value: TColor);
begin
  f_SelCellColor:=value;
  invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetSelFontColor(Value: TColor); *)
procedure TStringAlignGrid.SetSelFontColor(Value: TColor);
begin
  f_SelFontColor:=value;
  invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write and reset for Selected Colors *)
(*@/// Property read and write for SelColorCell *)
(*@/// function TStringAlignGrid.GetSelColorCell(ACol,ARow:Integer):TColor; *)
function TStringAlignGrid.GetSelColorCell(ACol,ARow:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCell(ACol,ARow,FSelColorCell);
  if v=NIL then begin
    v:=GetItemCol(ACol,FSelColorCol);
    if v=NIL then begin
      v:=GetItemCol(ARow,FSelColorRow);
      if v=NIL then
        result:=f_SelCellColor
      else
        result:=v^;
      end
    else
      result:=v^;
    end
  else
    result:=v^;
  end;
(*@\\\0000000401*)
(*@/// procedure TStringAlignGrid.SetSelColorCell(ACol,ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetSelColorCell(ACol,ARow:integer; const Value: TColor);
var
  v:^tColor;
begin
  FSaveSelColorCell:=true;
  New(v);
  v^:=value;
  v:=SetItemCell(ACol,ARow, FSelColorCell, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for SelColorCol *)
(*@/// function TStringAlignGrid.GetSelColorCol(ACol:Integer):TColor; *)
function TStringAlignGrid.GetSelColorCol(ACol:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ACol, FSelColorCol);
  if v=NIL then
    GetSelColorCol:=Color
  else
    GetSelColorCol:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetSelColorCol(ACol:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetSelColorCol(ACol:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveSelColorCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FSelColorCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000307*)
(*@\\\0000000201*)
(*@/// Property read and write for SelColorRow *)
(*@/// function TStringAlignGrid.GetSelColorRow(ARow:Integer):TColor; *)
function TStringAlignGrid.GetSelColorRow(ARow:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ARow, FSelColorRow);
  if v=NIL then
    GetSelColorRow:=Color
  else
    GetSelColorRow:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetSelColorRow(ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetSelColorRow(ARow:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveSelColorRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FSelColorRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)

(*@/// procedure TStringAlignGrid.ResetSelectedColorCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetSelectedColorCell(ACol,ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCell(ACol,ARow, FSelColorCell, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\0000000129*)
(*@/// procedure TStringAlignGrid.ResetSelectedColorCol(ACol:integer); *)
procedure TStringAlignGrid.ResetSelectedColorCol(ACol:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ACol, FSelColorCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetSelectedColorRow(ARow:integer); *)
procedure TStringAlignGrid.ResetSelectedColorRow(ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ARow, FSelColorRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write and reset for Selected Font Colors *)
(*@/// Property read and write for SelFontColorCell *)
(*@/// function TStringAlignGrid.GetSelFontColorCell(ACol,ARow:Integer):TColor; *)
function TStringAlignGrid.GetSelFontColorCell(ACol,ARow:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCell(ACol,ARow,FSelFontColorCell);
  if v=NIL then begin
    v:=GetItemCol(ACol,FSelFontColorCol);
    if v=NIL then begin
      v:=GetItemCol(ARow,FSelFontColorRow);
      if v=NIL then
        result:=f_SelFontColor
      else
        result:=v^;
      end
    else
      result:=v^;
    end
  else
    result:=v^;
  end;
(*@\\\0000000B1F*)
(*@/// procedure TStringAlignGrid.SetSelFontColorCell(ACol,ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetSelFontColorCell(ACol,ARow:integer; const Value: TColor);
var
  v:^tColor;
begin
  FSaveSelFontColorCell:=true;
  New(v);
  v^:=value;
  v:=SetItemCell(ACol,ARow, FSelFontColorCell, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for SelFontColorCol *)
(*@/// function TStringAlignGrid.GetSelFontColorCol(ACol:Integer):TColor; *)
function TStringAlignGrid.GetSelFontColorCol(ACol:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ACol, FSelFontColorCol);
  if v=NIL then
    GetSelFontColorCol:=Color
  else
    GetSelFontColorCol:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetSelFontColorCol(ACol:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetSelFontColorCol(ACol:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveSelFontColorCol:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ACol, FSelFontColorCol, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Property read and write for SelFontColorRow *)
(*@/// function TStringAlignGrid.GetSelFontColorRow(ARow:Integer):TColor; *)
function TStringAlignGrid.GetSelFontColorRow(ARow:Integer):TColor;
var
  v:^TColor;
begin
  v:=GetItemCol(ARow, FSelFontColorRow);
  if v=NIL then
    GetSelFontColorRow:=Color
  else
    GetSelFontColorRow:=v^;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.SetSelFontColorRow(ARow:integer; const Value: TColor); *)
procedure TStringAlignGrid.SetSelFontColorRow(ARow:integer; const Value: TColor);
var
  v:^TColor;
begin
  FSaveSelFontColorRow:=true;
  New(v);
  v^:=value;
  v:=SetItemCol(ARow, FSelFontColorRow, v);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\*)

(*@/// procedure TStringAlignGrid.ResetSelectedFontColorCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetSelectedFontColorCell(ACol,ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCell(ACol,ARow, FSelFontColorCell, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetSelectedFontColorCol(ACol:integer); *)
procedure TStringAlignGrid.ResetSelectedFontColorCol(ACol:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ACol, FSelFontColorCol, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ResetSelectedFontColorRow(ARow:integer); *)
procedure TStringAlignGrid.ResetSelectedFontColorRow(ARow:integer);
var
  v:^TColor;
begin
  v:=SetItemCol(ARow, FSelFontColorRow, NIL);
  if v<>NIL then
    dispose(v);
  Invalidate;
  end;
(*@\\\*)
(*@\\\0000000744*)
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

(*@/// Insertion, removing and moving of Rows and Columns *)
{ Cols.Delete[i] isn't implemented in any Delphi version I know of, it
  is abstract in D1/D2, in D3 at least an exception InvalidOp is raised.
  Same hold for Rows.Delete, Rows.Insert and Cols.Insert.
  Therefore all must be done by moving the Column/Row to be deleted or
  newly created from/to the place it should have }

(*@/// procedure TStringAlignGrid.RemoveCol(ACol:Integer); *)
procedure TStringAlignGrid.RemoveCol(ACol:Integer);
var
  v:^tmyalign;
  w:^TColor;
  x:pointer;
  z:^boolean;
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
if FAlignCell.Count>ACol then begin
  cleanlist(TList(FAlignCell.Items[ACol]),sizeof(TMyAlign));
  FAlignCell.Delete(ACol);
  end;
(*@\\\0000001001*)
(*@///   EditCol/Cell *)
if FEditCol.Count>=ACol then begin
  z:=SetItemCol(ACol,FEditCol,NIL);
  if z<>NIL then
    dispose(z);
  FEditCol.Delete(ACol);
  end;
if FEditCell.Count>ACol then begin
  cleanlist(TList(FEditCell.Items[ACol]),sizeof(boolean));
  FEditCell.Delete(ACol);
  end;
(*@\\\0000000714*)
(*@///   SelColorCol/Cell *)
if FSelColorCol.Count>=ACol then begin
  w:=SetItemCol(ACol,FSelColorCol,NIL);
  if w<>NIL then
    dispose(w);
  FSelColorCol.Delete(ACol);
  end;
if FSelColorCell.Count>ACol then begin
  cleanlist(TList(FSelColorCell.Items[ACol]),sizeof(TColor));
  FSelColorCell.Delete(ACol);
  end;
(*@\\\*)
(*@///   SelFontColorCol/Cell *)
if FSelFontColorCol.Count>=ACol then begin
  w:=SetItemCol(ACol,FSelFontColorCol,NIL);
  if w<>NIL then
    dispose(w);
  FSelFontColorCol.Delete(ACol);
  end;
if FSelFontColorCell.Count>ACol then begin
  cleanlist(TList(FSelFontColorCell.Items[ACol]),sizeof(TColor));
  FSelFontColorCell.Delete(ACol);
  end;
(*@\\\*)
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
(*@///   BrushCol/Cell *)
if FBrushCol.Count>=ACol then begin
  x:=SetItemCol(ACol,FBrushCol,NIL);
  if x<>NIL then
    TMyBrush(x).free;
  FBrushCol.Delete(ACol);
  end;
if FFBrushCol.Count>=ACol then begin
  x:=SetItemCol(ACol,FFBrushCol,NIL);
  if x<>NIL then
    TMyBrush(x).free;
  FFBrushCol.Delete(ACol);
  end;
if FBrushCell.Count>=ACol then begin
  cleanlist_object(TList(FBrushCell.Items[ACol]));
  FBrushCell.Delete(ACol);
  end;
(*@\\\0000001007*)
(*@///   HintCell *)
if FHintCell.Count>=ACol then begin
  cleanlist_pstring(TList(FHintCell.Items[ACol]));
  FHintCell.Delete(ACol);
  end;
(*@\\\*)
(*@///   Cell *)
for i:=ACol to ColCount-2 do
  inherited ColumnMoved(i,i+1);
Cols[Colcount-1].clear;
(*@\\\*)
  colcount:=colcount-1;
  invalidate;
  end;
(*@\\\0000001507*)
(*@/// procedure TStringAlignGrid.RemoveRow(ARow:Integer); *)
procedure TStringAlignGrid.RemoveRow(ARow:Integer);
var
  v:^tmyalign;
  w:^TColor;
  x:pointer;
  y:pstring;
  z:^boolean;
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
  if l<>NIL then begin
    if l.Count>=ARow then begin
      v:=SetItemCol(ARow,l,NIL);
      if v<>NIL then
        dispose(v);
      l.Delete(ARow);
      end;
    end;
  end;
(*@\\\*)
(*@///   EditRow/Cell *)
if FEditRow.Count>=ARow then begin
  z:=SetItemCol(ARow,FEditRow,NIL);
  if z<>NIL then
    dispose(z);
  FEditRow.Delete(ARow);
  end;
for i:=0 to FEditCell.Count-1 do begin
  l:=TList(FEditCell.Items[i]);
  if l<>NIL then begin
    if l.Count>=ARow then begin
      z:=SetItemCol(ARow,l,NIL);
      if z<>NIL then
        dispose(z);
      l.Delete(ARow);
      end;
    end;
  end;
(*@\\\0000001107*)
(*@///   SelColorRow/Cell *)
if FSelColorRow.Count>=ARow then begin
  w:=SetItemCol(ARow,FSelColorRow,NIL);
  if w<>NIL then
    dispose(w);
  FSelColorRow.Delete(ARow);
  end;
for i:=0 to FSelColorCell.Count-1 do begin
  l:=TList(FSelColorCell.Items[i]);
  if l<>NIL then begin
    if l.Count>=ARow then begin
      w:=SetItemCol(ARow,l,NIL);
      if w<>NIL then
        dispose(w);
      l.Delete(ARow);
      end;
    end;
  end;
(*@\\\*)
(*@///   SelFontColorRow/Cell *)
if FSelFontColorRow.Count>=ARow then begin
  w:=SetItemCol(ARow,FSelFontColorRow,NIL);
  if w<>NIL then
    dispose(w);
  FSelFontColorRow.Delete(ARow);
  end;
for i:=0 to FSelFontColorCell.Count-1 do begin
  l:=TList(FSelFontColorCell.Items[i]);
  if l<>NIL then begin
    if l.Count>=ARow then begin
      w:=SetItemCol(ARow,l,NIL);
      if w<>NIL then
        dispose(w);
      l.Delete(ARow);
      end;
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
  if l<>NIL then begin
    if l.Count>=ARow then begin
      x:=SetItemCol(ARow,l,NIL);
      if x<>NIL then
        TMyFont(x).free;
      l.Delete(ARow);
      end;
    end;
  end;
(*@\\\0000001609*)
(*@///   BrushRow/Cell *)
if FBrushRow.Count>=ARow then begin
  x:=SetItemCol(ARow,FBrushRow,NIL);
  if x<>NIL then
    TMyBrush(x).free;
  FBrushRow.Delete(ARow);
  end;
if FFBrushRow.Count>=ARow then begin
  x:=SetItemCol(ARow,FFBrushRow,NIL);
  if x<>NIL then
    TMyBrush(x).free;
  FFBrushRow.Delete(ARow);
  end;
for i:=0 to FBrushCell.Count-1 do begin
  l:=TList(FBrushCell.Items[i]);
  if l<>NIL then begin
    if l.Count>=ARow then begin
      x:=SetItemCol(ARow,l,NIL);
      if x<>NIL then
        TMyBrush(x).free;
      l.Delete(ARow);
      end;
    end;
  end;
(*@\\\0000001707*)
(*@///   HintCell *)
for i:=0 to FHintCell.Count-1 do begin
  l:=TList(FHintCell.Items[i]);
  if l<>NIL then begin
    if l.Count>=ARow then begin
      y:=SetItemCol(ARow,l,NIL);
      if y<>NIL then
        DisposeStr(y);
      l.Delete(ARow);
      end;
    end;
  end;
(*@\\\0000000A09*)
(*@///   Cell *)
for i:=ARow to RowCount-2 do
  inherited RowMoved(i,i+1);
Rows[Rowcount-1].clear;
(*@\\\0000000301*)
  rowcount:=rowcount-1;
  invalidate;
  end;
(*@\\\0000001707*)

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
(*@///   EditCol/Cell *)
if FEditCol.Count>=ACol then
  FEditCol.Insert(ACol,NIL);
if FEditCell.Count>=ACol then
  FEditCell.Insert(ACol,NIL);
(*@\\\000000041E*)
(*@///   SelColorCol/Cell *)
if FSelColorCol.Count>=ACol then
  FSelColorCol.Insert(ACol,NIL);
if FSelColorCell.Count>=ACol then
  FSelColorCell.Insert(ACol,NIL);
(*@\\\0000000301*)
(*@///   SelFontColorCol/Cell *)
if FSelFontColorCol.Count>=ACol then
  FSelFontColorCol.Insert(ACol,NIL);
if FSelFontColorCell.Count>=ACol then
  FSelFontColorCell.Insert(ACol,NIL);
(*@\\\*)
(*@///   FontCol/Cell *)
if FFontCol.Count>=ACol then
  FFontCol.Insert(ACol,NIL);
if FFFontCol.Count>=ACol then
  FFFontCol.Insert(ACol,NIL);
if FFontCell.Count>=ACol then
  FFontCell.Insert(ACol,NIL);
(*@\\\0000000501*)
(*@///   BrushCol/Cell *)
if FBrushCol.Count>=ACol then
  FBrushCol.Insert(ACol,NIL);
if FFBrushCol.Count>=ACol then
  FFBrushCol.Insert(ACol,NIL);
if FBrushCell.Count>=ACol then
  FBrushCell.Insert(ACol,NIL);
(*@\\\000000061F*)
(*@///   HintCell *)
if FHintCell.Count>=ACol then
  FHintCell.Insert(ACol,NIL);
(*@\\\*)
(*@///   Cell *)
Cols[ColCount-1].clear;
for i:=ColCount-1 downto ACol+1 do
  inherited ColumnMoved(i,i-1);      { maybe faster than doing it myself as
                                       this utilizes the internal sparselist }
(*@\\\*)
  invalidate;
  end;
(*@\\\0000001007*)
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
(*@///   EditRow/Cell *)
if FEditRow.Count>=ARow then
  FEditRow.Insert(ARow,NIL);
for i:=0 to FEditCell.Count-1 do begin
  l:=TList(FEditCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\0000000807*)
(*@///   SelColorRow/Cell *)
if FSelColorRow.Count>=ARow then
  FSelColorRow.Insert(ARow,NIL);
for i:=0 to FSelColorCell.Count-1 do begin
  l:=TList(FSelColorCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\0000000301*)
(*@///   SelFontColorRow/Cell *)
if FSelFontColorRow.Count>=ARow then
  FSelFontColorRow.Insert(ARow,NIL);
for i:=0 to FSelFontColorCell.Count-1 do begin
  l:=TList(FSelFontColorCell.Items[i]);
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
(*@///   BrushRow/Cell *)
if FBrushRow.Count>=ARow then
  FBrushRow.Insert(ARow,NIL);
if FFBrushRow.Count>=ARow then
  FFBrushRow.Insert(ARow,NIL);
for i:=0 to FBrushCell.Count-1 do begin
  l:=TList(FBrushCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\0000000A07*)
(*@///   HintCell *)
for i:=0 to FHintCell.Count-1 do begin
  l:=TList(FHintCell.Items[i]);
  if l.Count>=ARow then begin
    l.Insert(ARow,NIL);
    end;
  end;
(*@\\\000000040D*)
(*@///   Cell *)
Rows[RowCount-1].clear;
for i:=RowCount-1 downto ARow+1 do
  inherited RowMoved(i,i-1);
(*@\\\*)
  invalidate;
  end;
(*@\\\0000001107*)

(*@/// procedure TStringAlignGrid.RowMoved(FromIndex, ToIndex: Longint); *)
procedure TStringAlignGrid.RowMoved(FromIndex, ToIndex: Longint);
begin
(*@///   AlignRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FAlignRow);
MoveItemCol(FromIndex,ToIndex,FFAlignRow);
MoveItemColRow(FromIndex,ToIndex,FAlignCell);
(*@\\\*)
(*@///   EditRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FEditRow);
MoveItemColRow(FromIndex,ToIndex,FEditCell);
(*@\\\000000022D*)
(*@///   SelColorRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FSelColorRow);
MoveItemColRow(FromIndex,ToIndex,FSelColorCell);
(*@\\\0000000226*)
(*@///   SelFontColorRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FSelFontColorRow);
MoveItemColRow(FromIndex,ToIndex,FSelFontColorCell);
(*@\\\*)
(*@///   FontRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FFontRow);
MoveItemCol(FromIndex,ToIndex,FFFontRow);
MoveItemColRow(FromIndex,ToIndex,FFontCell);
(*@\\\*)
(*@///   BrushRow/Cell *)
MoveItemCol(FromIndex,ToIndex,FBrushRow);
MoveItemCol(FromIndex,ToIndex,FFBrushRow);
MoveItemColRow(FromIndex,ToIndex,FBrushCell);
(*@\\\000000032E*)
(*@///   HintCell *)
MoveItemColRow(FromIndex,ToIndex,FHintCell);
(*@\\\*)
(*@///   Cells *)
inherited RowMoved(FromIndex, ToIndex);
(*@\\\*)
  end;
(*@\\\0000000B07*)
(*@/// procedure TStringAlignGrid.ColumnMoved(FromIndex, ToIndex: Longint); *)
procedure TStringAlignGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
(*@///   AlignCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FAlignCol);
MoveItemCol(FromIndex,ToIndex,FFAlignCol);
MoveItemCol(FromIndex,ToIndex,FAlignCell);
(*@\\\*)
(*@///   EditCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FEditCol);
MoveItemCol(FromIndex,ToIndex,FEditCell);
(*@\\\0000000201*)
(*@///   SelColorCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FSelColorCol);
MoveItemCol(FromIndex,ToIndex,FSelColorCell);
(*@\\\0000000201*)
(*@///   SelFontColorCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FSelFontColorCol);
MoveItemCol(FromIndex,ToIndex,FSelFontColorCell);
(*@\\\*)
(*@///   FontCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FFontCol);
MoveItemCol(FromIndex,ToIndex,FFFontCol);
MoveItemCol(FromIndex,ToIndex,FFontCell);
(*@\\\*)
(*@///   BrushCol/Cell *)
MoveItemCol(FromIndex,ToIndex,FBrushCol);
MoveItemCol(FromIndex,ToIndex,FFBrushCol);
MoveItemCol(FromIndex,ToIndex,FBrushCell);
(*@\\\000000032B*)
(*@///   HintCell *)
MoveItemCol(FromIndex,ToIndex,FHintCell);
(*@\\\*)
(*@///   Cells *)
inherited ColumnMoved(FromIndex, ToIndex);
(*@\\\*)
  end;
(*@\\\0000000B07*)
(*@\\\0000000E01*)

(*@/// Utility methods for the fonts/brushs *)
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
(*@\\\000000012E*)
(*@/// function TStringAlignGrid.GetBrushColRowInternal(AColRow: integer; create:boolean; List:TList):TBrush; *)
function TStringAlignGrid.GetBrushColRowInternal(AColRow: integer; create:boolean; List:TList):TBrush;
var
  v: Pointer;
begin
  v:=GetItemCol(AColRow,List);
  if (v=NIL) then begin
    if create then begin
      v:=TMyBrush.Create;
      TMyBrush(v).Assign(self.Brush);
      TMyBrush(v).OnChange:=BrushChanged;
      SetItemCol(AColRow, List, v);
      end
    else v:=self.Brush;
    end;
  GetBrushColRowInternal:=TBrush(v);
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetBrushCellInternal(ACol,ARow: integer; create:boolean):TBrush; *)
function TStringAlignGrid.GetBrushCellInternal(ACol,ARow: integer; create:boolean):TBrush;
var
  v: Pointer;
begin
  v:=GetItemCell(ACol,ARow,FBrushCell);
  if (v=NIL) then begin
    if create then begin
      v:=TMyBrush.Create;
      TMyBrush(v).Assign(self.Brush);
      TMyBrush(v).OnChange:=BrushChanged;
      SetItemCell(ACol,ARow, FBrushCell, v);
      end
    else v:=self.Brush;
    end;
  GetBrushCellInternal:=TBrush(v);
  end;
(*@\\\*)

{ The Font/Brush for the Cell through all levels (Cell, Col, Row, Grid) }
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
(*@/// function TStringAlignGrid.GetBrushCellComplete(ACol,ARow: integer):TBrush; *)
function TStringAlignGrid.GetBrushCellComplete(ACol,ARow: integer):TBrush;
var
  v: Pointer;
  fixed: boolean;
begin
  v:=GetItemCell(ACol,ARow,FBrushCell);
  fixed:=is_fixed(ACol,ARow);
  if (v=NIL) then begin
    if fixed then
      v:=GetItemCol(ACol,FFBrushCol)
    else
      v:=GetItemCol(ACol,FBrushCol);
    if v=NIL then begin
      if fixed then
        v:=GetItemCol(ARow,FFBrushRow)
      else
        v:=GetItemCol(ARow,FBrushRow);
      if v=NIL then begin
        if fixed then
          v:=FFixedBrush
        else
          v:=self.Brush;
        end;
      end;
    end;
  GetBrushCellComplete:=TBrush(v);
  end;
(*@\\\0000001B01*)

{ A callback to be sure the displayed font/brush is the same as the internal }
(*@/// procedure TStringAlignGrid.FontChanged(AFont: TObject); *)
procedure TStringAlignGrid.FontChanged(AFont: TObject);
begin
  invalidate;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.BrushChanged(AFont: TObject); *)
procedure TStringAlignGrid.BrushChanged(AFont: TObject);
begin
  invalidate;
  end;
(*@\\\*)
(*@\\\*)
(*@/// Utility methods for the cell-specific hints *)
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
(*@\\\0000000201*)
(*@/// The Inplace-Editor which also gets the alignment, font and color *)
{ The Inplace-Editor which also gets the alignment, font and color -
  got the idea from James Sager's (jsager@ao.net) TIEAlignStringGrid -
  see UNDU #19 (http://www.informant.com/undu) }

(*@/// function TStringAlignGrid.CreateEditor: TInplaceEdit; *)
function TStringAlignGrid.CreateEditor: TInplaceEdit;
begin
  Result := TNewInplaceEdit.Create(Self);
  TNewInplaceEdit(Result).Col:=-1;
  TNewInplaceEdit(Result).Row:=-1;
  end;
(*@\\\0000000401*)
(*@/// function TStringAlignGrid.CanEditShow: Boolean; *)
function TStringAlignGrid.CanEditShow: Boolean;
begin
  Result := inherited CanEditShow;
  if (InplaceEditor <> nil) and
     (InplaceEditor is TNewInplaceEdit) then begin
    if (TNewInplaceEdit(InplaceEditor).Col<>Col) or
       (TNewInplaceEdit(InplaceEditor).Row<>Row) then begin
      postmessage(self.handle,cn_edit_exit,
        TNewInplaceEdit(InplaceEditor).Col,
        TNewInplaceEdit(InplaceEditor).Row);
      TNewInplaceEdit(InplaceEditor).event:=false;
      end;
    if not (csDesigning in ComponentState) then
      result:=result and (EditCell[Col,Row] or FAlwaysEdit);
    if Result then begin
      TNewInplaceEdit(InplaceEditor).Alignment:=GetAlignCell(Col,Row);
      TNewInplaceEdit(InplaceEditor).Font:=GetFontCellComplete(Col,Row);
      TNewInplaceEdit(InplaceEditor).Color:=ColorCell[Col,Row];
      TNewInplaceEdit(InplaceEditor).Col:=self.Col;
      TNewInplaceEdit(InplaceEditor).Row:=self.Row;
      if not TNewInplaceEdit(InplaceEditor).event then begin
        self.perform(cn_edit_show,self.col,self.row);
{         if assigned(f_on_before_edit) and }
{           (self.col>0) and (self.row>0) then }
{           f_on_before_edit(self,self.col,self.row); }
        TNewInplaceEdit(InplaceEditor).event:=true;
        TNewInplaceEdit(InplaceEditor).oldtext:=cells[col,row];
        end;
      end
    else begin
      TNewInplaceEdit(InplaceEditor).Col:=-1;
      TNewInplaceEdit(InplaceEditor).Row:=-1;
      end;
    end;
  end;
(*@\\\0000001201*)

(*@/// procedure TStringAlignGrid.ShowEdit; *)
procedure TStringAlignGrid.ShowEdit;
begin
  ShowEditor;
  edit_visible:=true;
  end;
(*@\\\0000000416*)
(*@/// procedure TStringAlignGrid.HideEdit(cancel:boolean); *)
procedure TStringAlignGrid.HideEdit(cancel:boolean);
var
  msg: TMessage;
begin
  edit_visible:=false;
  if (InplaceEditor<>NIL) and InplaceEditor.visible then begin
    if cancel then
      SendMessage(InplaceEditor.handle,wm_char,vk_escape,0)
    else begin
      self.HideEditor;
      msg.wparam:=col;
      msg.lparam:=row;
      self.mcn_edit_exit(msg);
      end;
    end;
  end;
(*@\\\0000000517*)

{ The stuff to get the editor's events right }

(*@/// procedure TStringAlignGrid.doExit; *)
procedure TStringAlignGrid.doExit;
begin
  if (InplaceEditor<>NIL) and (InplaceEditor.visible) then
    hideedit(false);
(*   if the edit is still visible the contents of the cell   *)
(*   seems to be invalid, so just take back the focus        *)
  if self.edit_visible then
    self.setfocus
  else
    inherited doexit;
  end;
(*@\\\000000020C*)
(*@/// procedure TStringAlignGrid.mcn_edit_return(var msg:TMessage); *)
procedure TStringAlignGrid.mcn_edit_return(var msg:TMessage);
var
  ACol,ARow: integer;
begin
  edit_visible:=false;
  if assigned(f_on_after_edit) and
    (msg.wparam>0) and (msg.lparam>0) then
    f_on_after_edit(self,msg.wparam,msg.lparam);
  if f_nextcell and
    (msg.wparam>0) and (msg.lparam>0) then begin
    ACol:=self.col;
    ARow:=self.row;
    self.NextEditableCell(ACol,ARow);
    if (ACol>0) and (ARow>0) then begin
      if InplaceEditor<>NIL then begin
        TNewInplaceEdit(InplaceEditor).Col:=-1;
        TNewInplaceEdit(InplaceEditor).Row:=-1;
        end;
      self.col:=ACol;
      self.row:=ARow;
      ShowEdit;
      end;
    end;
  end;
(*@\\\0000000201*)
(*@/// procedure TStringAlignGrid.mcn_edit_cancel(var msg:TMessage); *)
procedure TStringAlignGrid.mcn_edit_cancel(var msg:TMessage);
begin
  edit_visible:=false;
  if assigned(f_on_cancel_edit) and
    (msg.wparam>0) and (msg.lparam>0) then
    f_on_cancel_edit(self,msg.wparam,msg.lparam);
  end;
(*@\\\0000000401*)
(*@/// procedure TStringAlignGrid.mcn_edit_exit(var msg:TMessage); *)
procedure TStringAlignGrid.mcn_edit_exit(var msg:TMessage);
begin
  edit_visible:=false;
  if assigned(f_on_after_edit) and
    (msg.wparam>0) and (msg.lparam>0) then
    f_on_after_edit(self,msg.wparam,msg.lparam);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.mcn_edit_show(var msg:TMessage); *)
procedure TStringAlignGrid.mcn_edit_show(var msg:TMessage);
begin
  if assigned(f_on_before_edit) and
    (msg.wparam>0) and (msg.lparam>0) then
    f_on_before_edit(self,msg.wparam,msg.lparam);
  edit_visible:=true;
  end;
(*@\\\0000000601*)
(*@\\\*)
(*@/// The stuff for reading and writing the data from/to the DFM file *)
(*@/// procedure TStringAlignGrid.DefineProperties(Filer: TFiler); *)
procedure TStringAlignGrid.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('AlignCell', ReadAlignCell, WriteAlignCell, FSaveAlignCell);
  Filer.DefineBinaryProperty('AlignCol', ReadAlignCol, WriteAlignCol, FSaveAlignCol);
  Filer.DefineBinaryProperty('FixedAlignCol', ReadFixedAlignCol, WriteFixedAlignCol, FSaveFixedAlignCol);
  Filer.DefineBinaryProperty('AlignRow', ReadAlignRow, WriteAlignRow, FSaveAlignRow);
  Filer.DefineBinaryProperty('FixedAlignRow', ReadFixedAlignRow, WriteFixedAlignRow, FSaveFixedAlignRow);
  Filer.DefineBinaryProperty('EditCell', ReadEditCell, WriteEditCell, FSaveEditCell);
  Filer.DefineBinaryProperty('EditCol', ReadEditCol, WriteEditCol, FSaveEditCol);
  Filer.DefineBinaryProperty('EditRow', ReadEditRow, WriteEditRow, FSaveEditRow);
  Filer.DefineProperty('HintCell', ReadHint, WriteHint, FSaveHint);
  Filer.DefineProperty('Cells', ReadCells, WriteCells, FSaveCells);
  Filer.DefineProperty('FontCell', ReadFontCell, WriteFontCell, FSaveFontCell);
  Filer.DefineProperty('FontCol', ReadFontCol, WriteFontCol, FSaveFontCol);
  Filer.DefineProperty('FontFixedCol', ReadFixedFontCol, WriteFixedFontCol, FSaveFixedFontCol);
  Filer.DefineProperty('FontRow', ReadFontRow, WriteFontRow, FSaveFontRow);
  Filer.DefineProperty('FontFixedRow', ReadFixedFontRow, WriteFixedFontRow, FSaveFixedFontRow);
  Filer.DefineProperty('BrushCell', ReadBrushCell, WriteBrushCell, FSaveBrushCell);
  Filer.DefineProperty('BrushCol', ReadBrushCol, WriteBrushCol, FSaveBrushCol);
  Filer.DefineProperty('BrushFixedCol', ReadFixedBrushCol, WriteFixedBrushCol, FSaveFixedBrushCol);
  Filer.DefineProperty('BrushRow', ReadBrushRow, WriteBrushRow, FSaveBrushRow);
  Filer.DefineProperty('BrushFixedRow', ReadFixedBrushRow, WriteFixedBrushRow, FSaveFixedBrushRow);
  Filer.DefineProperty('ColorCell', ReadColorCell, NIL, false);
  Filer.DefineProperty('ColorCol', ReadColorCol, NIL, false);
  Filer.DefineProperty('ColorFixedCol', ReadFixedColorCol, NIL, false);
  Filer.DefineProperty('ColorRow', ReadColorRow, NIL, false);
  Filer.DefineProperty('ColorFixedRow', ReadFixedColorRow, NIL, false);
  Filer.DefineProperty('SelectedColorCell', ReadSelColorCell, WriteSelColorCell, FSaveSelColorCell);
  Filer.DefineProperty('SelectedColorCol', ReadSelColorCol, WriteSelColorCol, FSaveSelColorCol);
  Filer.DefineProperty('SelectedColorRow', ReadSelColorRow, WriteSelColorRow, FSaveSelColorRow);
  end;
(*@\\\0000001D01*)
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
(*@\\\0000000A0A*)

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
(*@\\\0000000301*)
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
(*@\\\0000000A01*)
(*@/// Read and write several edit-enabled lists to the DFM *)
{ All the routines for the several edit-enabled lists }
(*@/// procedure TStringAlignGrid.ReadEditCell(Stream: TStream); *)
procedure TStringAlignGrid.ReadEditCell(Stream: TStream);
var
  ACol,ARow: word;
  p:^boolean;
begin
  Stream.Seek(0,0);
  while Stream.Position<Stream.Size do begin
    New(p);
    Stream.Read(ACol,sizeof(word));
    Stream.Read(ARow,sizeof(word));
    Stream.Read(p^,sizeof(boolean));
    p:=SetItemCell(ACol,ARow,FEditCell,p);
    FSaveEditCell:=true;
    if p<>NIL then
      dispose(p);
    end;
  end;
(*@\\\0000001107*)
(*@/// procedure TStringAlignGrid.WriteEditCell(Stream: TStream); *)
procedure TStringAlignGrid.WriteEditCell(Stream: TStream);
var
  ACol,ARow: word;
  p:^boolean;
begin
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      p:=GetItemCell(ACol,ARow,FEditCell);
      if p<>NIL then begin
        Stream.Write(ACol,sizeof(word));
        Stream.Write(ARow,sizeof(word));
        Stream.Write(p^,sizeof(boolean));
        end;
      end;
    end;
  end;
(*@\\\0000000C27*)
(*@/// procedure TStringAlignGrid.ReadEditCol(Stream: TStream); *)
procedure TStringAlignGrid.ReadEditCol(Stream: TStream);
begin
  FSaveEditCol:=ReadEditColRow(Stream,FEditCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadEditRow(Stream: TStream); *)
procedure TStringAlignGrid.ReadEditRow(Stream: TStream);
begin
  FSaveEditRow:=ReadEditColRow(Stream,FEditRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteEditCol(Stream: TStream); *)
procedure TStringAlignGrid.WriteEditCol(Stream: TStream);
begin
  WriteEditColRow(Stream, ColCount-1, FEditCol);
  end;
(*@\\\0000000401*)
(*@/// procedure TStringAlignGrid.WriteEditRow(Stream: TStream); *)
procedure TStringAlignGrid.WriteEditRow(Stream: TStream);
begin
  WriteEditColRow(Stream, RowCount-1, FEditRow);
  end;
(*@\\\0000000301*)

{ All the ReadCol, ReadRow are so similar, so these to routines are there
  to avoid code-copy }
(*@/// function TStringAlignGrid.ReadEditColRow(Stream: TStream; list:TList):boolean; *)
function TStringAlignGrid.ReadEditColRow(Stream: TStream; List:TList):boolean;
var
  AColRow: word;
  p:^boolean;
begin
  result:=false;
  Stream.Seek(0,0);
  while Stream.Position<Stream.Size do begin
    New(p);
    Stream.Read(AColRow,sizeof(word));
    Stream.Read(p^,sizeof(boolean));
    p:=SetItemCol(AColRow,List,p);
    result:=true;
    if p<>NIL then
      dispose(p);
    end;
  end;
(*@\\\0000001107*)
(*@/// procedure TStringAlignGrid.WriteEditColRow(Stream: TStream; count: integer; list:TList); *)
procedure TStringAlignGrid.WriteEditColRow(Stream: TStream; count: integer; list:TList);
var
  AColRow: word;
  p:^boolean;
begin
  for AColRow:=0 to Count do begin
    p:=GetItemCol(AColRow,List);
    if p<>NIL then begin
      Stream.Write(AColRow,sizeof(word));
      Stream.Write(p^,sizeof(boolean));
      end;
    end;
  end;
(*@\\\0000000A25*)
(*@\\\0000000128*)
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
(*@\\\0000000D01*)
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
(*@\\\0000000D1B*)

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
begin
  FSaveFontCell:=ReadFontCellInt(Reader,FFontCell);
  end;
(*@\\\0000000407*)
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
begin
  WriteFontCellInt(Writer,ColCount-1,RowCount-1,FFontCell);
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
(*@/// function TStringAlignGrid.ReadFontCellInt(Reader: TReader; list:TList):boolean; *)
function TStringAlignGrid.ReadFontCellInt(Reader: TReader; list:TList):boolean;
var
  ACol,ARow: word;
  v:pointer;
begin
  result:=false;
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    v:=ReadFont(Reader);
    v:=SetItemCell(ACol,ARow,list,v);
    result:=true;
    if v<>NIL then
      TFont(v).free;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\0000000901*)
(*@/// procedure TStringAlignGrid.WriteFontCellInt(Writer: TWriter; x,y:integer; list:TList); *)
procedure TStringAlignGrid.WriteFontCellInt(Writer: TWriter; x,y:integer; list:TList);
var
  v:pointer;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to x do begin
    for ARow:=0 to y do begin
      v:=GetItemCell(ACol,ARow,list);
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
{ I HATE Borland - here a simple Writer.WriteProperties() would do, but these }
{ idiots have made this method private and only the trivial ones are public.  }
{ They invent such powerfull mechanisms to access properties at design time   }
{ and then they destroy any way to use these for advanced components :-(      }
{ So I have to write every property and not only those that are changed       }
{ from the default, and I have to do the assumption that they won't change    }
{ the TFontStyles and TFontPitch types as that would run this into great      }
{ problems. And of course what to do with a beast like a TButton instead of   }
{ a TFont - then the mechanism below won't be enough.                         }
{ So anyone knowing a better way to do it is greatly welcome!                 }

procedure TStringAlignGrid.WriteFont(Writer: TWriter; v:TFont);
var
  t: TFontStyles;
begin
  Writer.WriteInteger(v.Color);
  Writer.WriteInteger(v.height);
  Writer.WriteString(v.name);
{ WriteEnum is missing, have to write as an integer }
  Writer.WriteInteger(cardinal(v.Pitch));
{ The WriteSet is also missing, again only savable as an integer }
  t:=v.Style;
{ and why can't I cast a set to an integer directly ? }
  Writer.WriteInteger(cardinal(pointer(@t)^));
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.ReadFont(Reader: TReader):TFont; *)
function TStringAlignGrid.ReadFont(Reader: TReader):TFont;
var
  t: integer;
begin
{ The same work-around as in WriteFont }
  result:=TMyFont.Create;
  result.Color:=Reader.ReadInteger;
  result.height:=Reader.ReadInteger;
  result.name:=Reader.ReadString;
  result.pitch:=TFontPitch(Reader.ReadInteger);
  t:=reader.readinteger;
  result.style:=TFontStyles(pointer(@t)^);
  result.OnChange:=FontChanged;
  end;
(*@\\\0000000601*)
(*@\\\0000000201*)
(*@/// Read and write several brush lists to the DFM *)
{ All the routines for the different Brush lists }
(*@/// procedure TStringAlignGrid.ReadBrushCell(Reader: TReader); *)
procedure TStringAlignGrid.ReadBrushCell(Reader: TReader);
begin
  FSaveBrushCell:=ReadBrushCellInt(Reader,FBrushCell);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.ReadBrushCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadBrushCol(Reader: TReader);
begin
  FSaveBrushCol:=ReadBrushColRow(Reader,FBrushCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadBrushRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadBrushRow(Reader: TReader);
begin
  FSaveBrushRow:=ReadBrushColRow(Reader,FBrushRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedBrushCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedBrushCol(Reader: TReader);
begin
  FSaveFixedBrushCol:=ReadBrushColRow(Reader,FFBrushCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadFixedBrushRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedBrushRow(Reader: TReader);
begin
  FSaveFixedBrushRow:=ReadBrushColRow(Reader,FFBrushRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteBrushCell(Writer: TWriter); *)
procedure TStringAlignGrid.WriteBrushCell(Writer: TWriter);
begin
  WriteBrushCellInt(Writer,ColCount-1,RowCount-1,FBrushCell);
  end;
(*@\\\0000000201*)
(*@/// procedure TStringAlignGrid.WriteBrushCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteBrushCol(Writer: TWriter);
begin
  WriteBrushColRow(Writer, ColCount-1, FBrushCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteBrushRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteBrushRow(Writer: TWriter);
begin
  WriteBrushColRow(Writer, RowCount-1, FBrushRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedBrushCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFixedBrushCol(Writer: TWriter);
begin
  WriteBrushColRow(Writer, ColCount-1, FFBrushCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteFixedBrushRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteFixedBrushRow(Writer: TWriter);
begin
  WriteBrushColRow(Writer, RowCount-1, FFBrushRow);
  end;
(*@\\\*)

{ All the ReadCol, ReadRow are so similar, so these to routines are there
  to avoid code-copy }
(*@/// function TStringAlignGrid.ReadBrushCellInt(Reader: TReader; list:TList):boolean; *)
function TStringAlignGrid.ReadBrushCellInt(Reader: TReader; list:TList):boolean;
var
  ACol,ARow: word;
  v:pointer;
begin
  result:=false;
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    v:=ReadBrush(Reader);
    v:=SetItemCell(ACol,ARow, list, v);
    result:=true;
    if v<>NIL then
      TBrush(v).free;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteBrushCellInt(Writer: TWriter; x,y:integer; list:TList); *)
procedure TStringAlignGrid.WriteBrushCellInt(Writer: TWriter; x,y:integer; list:TList);
var
  v:pointer;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to x do begin
    for ARow:=0 to y do begin
      v:=GetItemCell(ACol,ARow,list);
      if (v<>NIL) and TMyBrush(v).HasChanged then begin
        Writer.WriteInteger(ACol);
        Writer.WriteInteger(ARow);
        WriteBrush(Writer,TBrush(v));
        end;
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.ReadBrushColRow(Reader:TReader; list:TList):boolean; *)
function TStringAlignGrid.ReadBrushColRow(Reader:TReader; list:TList):boolean;
var
  AColRow: word;
  v: pointer;
begin
  result:=false;
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    AColRow:=Reader.ReadInteger;
    v:=ReadBrush(Reader);
    v:=SetItemCol(AColRow, list, v);
    result:=true;
    if v<>NIL then
      TBrush(v).free;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteBrushColRow(Writer:TWriter; count:integer; list:TList); *)
procedure TStringAlignGrid.WriteBrushColRow(Writer:TWriter; count:integer; list:TList);
var
  AColRow: word;
  v: pointer;
begin
  Writer.WriteListBegin;
  for AColRow:=0 to Count do begin
    v:=GetItemCol(AColRow,List);
    if (v<>NIL) and TMyBrush(v).HasChanged then begin
      Writer.WriteInteger(AColRow);
      WriteBrush(Writer,TBrush(v));
      end;
    end;
  Writer.WriteListEnd;
  end;
(*@\\\*)

{ Writing and reading a single Brush entry }
(*@/// procedure TStringAlignGrid.WriteBrush(Writer: TWriter; v:TBrush); *)
{ The same comment as in WriteFont applies here }

procedure TStringAlignGrid.WriteBrush(Writer: TWriter; v:TBrush);
begin
  Writer.WriteInteger(v.Color);
{ WriteEnum is missing, have to write as an integer }
  Writer.WriteInteger(cardinal(v.Style));
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.ReadBrush(Reader: TReader):TBrush; *)
function TStringAlignGrid.ReadBrush(Reader: TReader):TBrush;
begin
  result:=TMyBrush.Create;
  result.Color:=Reader.ReadInteger;
  result.style:=TBrushStyle(Reader.ReadInteger);
  result.OnChange:=BrushChanged;
  end;
(*@\\\0000000619*)
(*@\\\0000000F01*)
(*@/// Read several color lists to the DFM *)
{ Only the read methods to read old DFM files correctly, all is now saved }
{ via the brushes }
(*@/// procedure TStringAlignGrid.ReadColorCell(Reader: TReader); *)
procedure TStringAlignGrid.ReadColorCell(Reader: TReader);
var
  ACol,ARow: word;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    ACol:=Reader.ReadInteger;
    ARow:=Reader.ReadInteger;
    CellBrush[ACol,ARow].color:=Reader.ReadInteger;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\0000000401*)
(*@/// procedure TStringAlignGrid.ReadColorCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadColorCol(Reader: TReader);
begin
  ReadColorColRow(Reader,0);
  end;
(*@\\\0000000312*)
(*@/// procedure TStringAlignGrid.ReadColorRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadColorRow(Reader: TReader);
begin
  ReadColorColRow(Reader,1);
  end;
(*@\\\000000031B*)
(*@/// procedure TStringAlignGrid.ReadFixedColorCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedColorCol(Reader: TReader);
begin
  ReadColorColRow(Reader,2);
  end;
(*@\\\0000000401*)
(*@/// procedure TStringAlignGrid.ReadFixedColorRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadFixedColorRow(Reader: TReader);
begin
  ReadColorColRow(Reader,3);
  end;
(*@\\\0000000401*)

(*@/// procedure TStringAlignGrid.ReadColorColRow(Reader:TReader; kind: byte); *)
procedure TStringAlignGrid.ReadColorColRow(Reader:TReader; kind: byte);
var
  AColRow: word;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    AColRow:=Reader.ReadInteger;
    case kind of
      0: ColBrush[AcolRow].color:=Reader.ReadInteger;
      1: RowBrush[AcolRow].color:=Reader.ReadInteger;
      2: FixedColBrush[AcolRow].color:=Reader.ReadInteger;
      3: FixedRowBrush[AcolRow].color:=Reader.ReadInteger;
      end;
    end;
  Reader.ReadListEnd;
  end;
(*@\\\0000000A2B*)
(*@\\\0000000301*)
(*@/// Read and write several selected color lists to the DFM *)
(*@/// procedure TStringAlignGrid.ReadSelColorCell(Reader: TReader); *)
procedure TStringAlignGrid.ReadSelColorCell(Reader: TReader);
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
    v:=SetItemCell(ACol,ARow, FSelColorCell, v);
    FSaveSelColorCell:=true;
    if v<>NIL then
      dispose(v);
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadSelColorCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadSelColorCol(Reader: TReader);
begin
  FSaveSelColorCol:=ReadSelColorColRow(Reader,FSelColorCol);
  end;
(*@\\\000000032F*)
(*@/// procedure TStringAlignGrid.ReadSelColorRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadSelColorRow(Reader: TReader);
begin
  FSaveSelColorRow:=ReadSelColorColRow(Reader,FSelColorRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteSelColorCell(Writer: TWriter); *)
procedure TStringAlignGrid.WriteSelColorCell(Writer: TWriter);
var
  v:^TColor;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      v:=GetItemCell(ACol,ARow,FSelColorCell);
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
(*@/// procedure TStringAlignGrid.WriteSelColorCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteSelColorCol(Writer: TWriter);
begin
  WriteSelColorColRow(Writer, ColCount-1, FSelColorCol);
  end;
(*@\\\0000000308*)
(*@/// procedure TStringAlignGrid.WriteSelColorRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteSelColorRow(Writer: TWriter);
begin
  WriteSelColorColRow(Writer, RowCount-1, FSelColorRow);
  end;
(*@\\\0000000301*)

{ All the ReadCol, ReadRow are so similar, so these to routines are there
  to avoid code-copy }
(*@/// function TStringAlignGrid.ReadSelColorColRow(Reader:TReader; list:TList):boolean; *)
function TStringAlignGrid.ReadSelColorColRow(Reader:TReader; list:TList):boolean;
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
(*@\\\000000012D*)
(*@/// procedure TStringAlignGrid.WriteSelColorColRow(Writer:TWriter; count:integer; list:TList); *)
procedure TStringAlignGrid.WriteSelColorColRow(Writer:TWriter; count:integer; list:TList);
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
(*@\\\0000000201*)
(*@\\\*)
(*@/// Read and write several selected font color lists to the DFM *)
(*@/// procedure TStringAlignGrid.ReadSelFontColorCell(Reader: TReader); *)
procedure TStringAlignGrid.ReadSelFontColorCell(Reader: TReader);
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
    v:=SetItemCell(ACol,ARow, FSelFontColorCell, v);
    FSaveSelFontColorCell:=true;
    if v<>NIL then
      dispose(v);
    end;
  Reader.ReadListEnd;
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadSelFontColorCol(Reader: TReader); *)
procedure TStringAlignGrid.ReadSelFontColorCol(Reader: TReader);
begin
  FSaveSelFontColorCol:=ReadSelColorColRow(Reader,FSelFontColorCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.ReadSelFontColorRow(Reader: TReader); *)
procedure TStringAlignGrid.ReadSelFontColorRow(Reader: TReader);
begin
  FSaveSelFontColorRow:=ReadSelColorColRow(Reader,FSelFontColorRow);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteSelFontColorCell(Writer: TWriter); *)
procedure TStringAlignGrid.WriteSelFontColorCell(Writer: TWriter);
var
  v:^TColor;
  ACol,ARow: word;
begin
  Writer.WriteListBegin;
  for ACol:=0 to ColCount-1 do begin
    for ARow:=0 to RowCount-1 do begin
      v:=GetItemCell(ACol,ARow,FSelFontColorCell);
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
(*@/// procedure TStringAlignGrid.WriteSelFontColorCol(Writer: TWriter); *)
procedure TStringAlignGrid.WriteSelFontColorCol(Writer: TWriter);
begin
  WriteSelColorColRow(Writer, ColCount-1, FSelFontColorCol);
  end;
(*@\\\*)
(*@/// procedure TStringAlignGrid.WriteSelFontColorRow(Writer: TWriter); *)
procedure TStringAlignGrid.WriteSelFontColorRow(Writer: TWriter);
begin
  WriteSelColorColRow(Writer, RowCount-1, FSelFontColorRow);
  end;
(*@\\\*)
(*@\\\*)
(*@\\\*)
(*@/// Import and Export functions *)
(*@/// function TStringAlignGrid.Contents2HTML(data:TMemorystream):TMemorystream; *)
function TStringAlignGrid.Contents2HTML(data:TMemorystream):TMemorystream;
var
  ACol,ARow: integer;
  font: TFont;
  c: TColor;
(*@/// function color2rgb(c:TColor):longint;        // bgr -> rgb *)
function color2rgb(c:TColor):longint;
var
  temp:longint;
begin
  temp:=colortorgb(c);
  result:=((temp and $ff) shl 16) or (temp and $ff00) or ((temp and $ff0000) shr 16);
  end;
(*@\\\0000000601*)
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
  if data<>NIL then
    result:=data
  else
    result:=TMemorystream.Create;
  String2Stream(result,'<table bgcolor=#'+inttohex(color2rgb(color),6)+'>'#13#10);
  for ARow:=0 to RowCount do begin
    String2Stream(result,' <tr>'#13#10);
    for ACol:=0 to ColCount do begin
      if (ACol<FixedCols) or (ARow<FixedRows) then
        String2Stream(result,'  <th')
      else
        String2Stream(result,'  <td');
      case AlignCell[ACol,ARow] of
        alLeft  :  String2Stream(result,' align=left');
        alRight :  String2Stream(result,' align=right');
        alCenter:  String2Stream(result,' align=center');
        end;
      c:=ColorCell[ACol,ARow];
      if c<>color then
        String2Stream(result,' bgcolor=#'+inttohex(color2rgb(c),6));
      String2Stream(result,'>'#13#10);
      if cells[ACol,ARow]<>'' then begin
        font:=GetFontCellComplete(ACol,ARow);
(*@///         if font.haschanged then write font data tags *)
if TMyFont(font).haschanged then begin
  String2Stream(result,'   <font color=#'+inttohex(color2rgb(font.color),6)
                    +' size='+inttostr(point2size(font.size))+'>');
  if fsBold in font.style then
    String2Stream(result,'<b>');
  if fsItalic in font.style then
    String2Stream(result,'<i>');
  if fsStrikeOut in font.style then
    String2Stream(result,'<strike>');
  if fsUnderline in font.style then
    String2Stream(result,'<u>');
  end;
(*@\\\0000000201*)
        String2Stream(result,text2html(cells[ACol,ARow]));
(*@///         if font.haschanged then close font data tags *)
if TMyFont(font).haschanged then begin
  if fsUnderline in font.style then
    String2Stream(result,'</u>');
  if fsStrikeOut in font.style then
    String2Stream(result,'</strike>');
  if fsItalic in font.style then
    String2Stream(result,'</i>');
  if fsBold in font.style then
    String2Stream(result,'</b>');
  String2Stream(result,'</font>');
  end;
(*@\\\*)
        end;
      if (ACol<FixedCols) or (ARow<FixedRows) then
        String2Stream(result,'  </th>')
      else
        String2Stream(result,'  </td>');
      end;
    String2Stream(result,' </tr>'#13#10);
    end;
  String2Stream(result,'</table>'#13#10);
  end;
(*@\\\0000002C1B*)
(*@/// function TStringAlignGrid.Contents2CSV(data:TMemorystream; csv:char; range:TGridRect):TMemorystream; *)
function TStringAlignGrid.Contents2CSV(data:TMemorystream; csv:char; range:TGridRect):TMemorystream;
var
  ACol,ARow: integer;
  s: string;
begin
  if data<>NIL then
    result:=data
  else
    result:=TMemorystream.Create;
  if (range.right<range.left) or (range.right<0) then range.right:=self.colcount-1;
  if range.left<0 then range.left:=0;
  if (range.bottom<range.top) or (range.bottom<0) then range.bottom:=self.rowcount-1;
  if range.top<0 then range.top:=0;
  for ARow:=range.top to range.bottom do begin
    s:='';
    for ACol:=range.left to range.right do
      s:=s+cells[ACol,ARow]+csv;
    String2Stream(result,s+#13#10);
    end;
  end;
(*@\\\0000001007*)
(*@/// procedure TStringAlignGrid.CSV2Contents(data:TStream; csv:char; range:TGridRect); *)
procedure TStringAlignGrid.CSV2Contents(data:TStream; csv:char; range:TGridRect);
var
  h: TStringlist;
  i,ACol,ARow: integer;
  s: string;
begin
  if data=NIL then EXIT;
  if Range.Top<0 then Range.top:=0;
  if Range.left<0 then Range.left:=0;
  if Range.Bottom<range.top then range.bottom:=maxint;
  if Range.right<range.left then range.right:=maxint;
  h:=NIL;
  try
    h:=TStringlist.Create;
    data.seek(0,0);
    h.loadfromstream(data);
    ARow:=range.top;
    i:=0;
    while (i<h.count) and (ARow<=Range.bottom) do begin
      if ARow>=RowCount then RowCount:=RowCount+1;
      ACol:=range.left;
      s:=h.strings[i]+csv;
      while (ACol<=range.right) and (length(s)>1) do begin
        if ACol>=ColCount then ColCount:=ColCount+1;
        cells[ACol,ARow]:=copy(s,1,pos(csv,s)-1);
        s:=copy(s,pos(csv,s)+1,length(s));
        inc(ACol);
        end;
      inc(ARow);
      inc(i);
      end;
  finally
    h.free;
    end;
  end;
(*@\\\0000000C0A*)
(*@/// procedure TStringAlignGrid.SaveToFile(const filename:string); *)
procedure TStringAlignGrid.SaveToFile(const filename:string);
var
  data: TMemoryStream;
  rect: TGridRect;
begin
  data:=NIL;
  rect.left:=-1;
  rect.right:=-1;
  rect.top:=-1;
  rect.bottom:=-1;
  try
    data:=Contents2CSV(data,#7,rect);
    data.savetofile(filename);
  finally
    data.free;
    end;
  end;
(*@\\\0000001107*)
(*@/// procedure TStringAlignGrid.LoadFromFile(const filename:string); *)
procedure TStringAlignGrid.LoadFromFile(const filename:string);
var
  data: TFileStream;
  rect: TGridRect;
begin
  data:=NIL;
  rect.left:=-1;
  rect.right:=-1;
  rect.top:=-1;
  rect.bottom:=-1;
  try
    data:=TFileStream.Create(filename,fmOpenRead);
    CSV2Contents(data,#7,rect);
  finally
    data.free;
    end;
  end;
(*@\\\0000001107*)
(*@\\\*)
(*@/// Miscellaneous stuff *)
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
(*@\\\*)
(*@/// function TStringAlignGrid.is_fixed(ACol,ARow: integer):boolean; *)
function TStringAlignGrid.is_fixed(ACol,ARow: integer):boolean;
begin
  result:= (ACol<FixedCols) or (ARow<FixedRows) or
           (ACol<f_FixedCols) or (ARow<f_FixedRows);
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.NextEditableCell(var ACol,ARow:integer); *)
procedure TStringAlignGrid.NextEditableCell(var ACol,ARow:integer);
begin
  repeat
    inc(ACol);
    if ACol>=ColCount then begin
      ACol:=FixedCols;
      inc(ARow);
      end;
    if ARow>=RowCount then begin
      ACol:=-1;
      ARow:=-1;
      BREAK;
      end;
  until EditCell[ACol,ARow];
  end;
(*@\\\*)
(*@\\\0000000201*)

(*@/// The real action - the draw of a cell *)
{ the draw of a cell, is called from the Paint Method of TCustomGrid }

(*@/// procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; *)
procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
(*@/// procedure DrawCellText; *)
procedure DrawCellText;
var
  l: integer;
  Left: integer;
  Top: integer;
  h: integer;
  AlignValue: TMyAlign;
  s,t: string;
begin
  self.canvas.font:=GetFontCellComplete(ACol,ARow);
  self.canvas.brush:=GetBrushCellComplete(ACol,ARow);
  Top:=Arect.Top+2;

  if (gdSelected in AState) and (not (gdFocused in AState) or
       ([goDrawFocusSelected, goRowSelect] * Options <> [])) then begin
    self.canvas.brush.color:=SelectedColorCell[Acol,ARow];
    self.canvas.font.color:=SelectedFontColorCell[Acol,ARow];
    end;
{   else if (gdFixed in AState) or is_fixed(ACol,ARow) then }
{     self.canvas.brush.color:=FixedColor; }
  self.canvas.fillrect(ARect);
  SetBkMode(Canvas.Handle,transparent);

  s:=Cells[ACol, ARow]+#13;
  while pos(#13,s)<>0 do begin
    t:=copy(s,1,pos(#13,s)-1);
    l:=Canvas.TextWidth(t);
    h:=Canvas.TextHeight(t);
    t:=t+#0;

  { AlignCell follows the logic: 1. Cell, 2. Col, 3. Row, 4. Global }
    AlignValue:=AlignCell[ACol,ARow];
    case AlignValue of
      alLeft: Left:=ARect.Left+2;
      alCenter: begin
        l:=( (Arect.Right-ARect.Left)-l ) div 2;
        Left:=ARect.Left+l;
        end;
      alRight: Left:=ARect.Right-l-2;
      else  Left:=ARect.Left+2;  { if nothing is set use left bounding -
                                   this shouldn't happen }
      end;

    ExtTextOut(Canvas.Handle, Left, Top,  ETO_CLIPPED,
      @ARect, PChar(@t[1]), length(t)-1, nil);
    s:=copy(s,pos(#13,s)+1,length(s));
    if (length(s)>0) and (s[1]=#10) then
      s:=copy(s,2,length(s));
    inc(top,h);
    end;
  end;
(*@\\\0000001101*)
var
  temp: TDrawCellEvent;
begin
  if DefaultDrawing then begin
    DrawCellText;
    { Delphi 1 doesn't understand a Assigned(OnDrawCell), but this way it
      works with all versions }
    temp:=OnDrawCell;
    if Assigned(temp) then OnDrawCell(Self, ACol, ARow, ARect, AState);
    end
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
  end;
(*@\\\0000000301*)
(*@\\\0000000301*)
(*@\\\*)
(*@/// TGridComponentEditor = class(TComponentEditor) // The component editor *)
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
(*@/// function CopyEditCell(Source,Target:TList; ColCount,RowCount:integer):boolean; *)
function CopyEditCell(Source,Target:TList; ColCount,RowCount:integer):boolean;
var
  v,w:^boolean;
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
(*@/// function CopyEditCol(Source,Target:TList; Count:integer):boolean; *)
function CopyEditCol(Source,Target:TList; Count:integer):boolean;
var
  v,w:^boolean;
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
(*@\\\0000000B01*)
(*@/// function CopyFontCell(Source,Target:TList; ColCount,RowCount:integer; ...):boolean; *)
function CopyFontCell(Source,Target:TList; ColCount,RowCount:integer;
  grid:TStringAlignGrid):boolean;
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
        TMyFont(w).OnChange:=grid.FontChanged;
        end
      else
        w:=NIL;
      w:=SetItemCell(ACol,ARow, Target, w);
      if w<>NIL then
        TFont(w).Free;
      end;
  end;
(*@\\\0000001001*)
(*@/// function CopyFontCol(Source,Target:TList; Count:integer; ...):boolean; *)
function CopyFontCol(Source,Target:TList; Count:integer; grid:TStringAlignGrid):boolean;
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
      TMyFont(w).OnChange:=grid.FontChanged;
      end
    else
      w:=NIL;
    w:=SetItemCol(ACol, Target, w);
    if w<>NIL then
      TFont(w).Free;
    end;
  end;
(*@\\\0000000E01*)
(*@/// function CopyBrushCell(Source,Target:TList; ColCount,RowCount:integer; ...):boolean; *)
function CopyBrushCell(Source,Target:TList; ColCount,RowCount:integer;
  grid:TStringAlignGrid):boolean;
var
  v,w:pointer;
  ACol,ARow: integer;
begin
  result:=false;
  for ACol:=0 to Colcount-1 do
    for ARow:=0 to Rowcount-1 do begin
      v:=GetItemCell(ACol,ARow,Source);
      if (v<>NIL) and TMyBrush(v).HasChanged then begin
        result:=true;
        w:=TMyBrush.Create;
        TBrush(w).assign(TBrush(v));
        TMyBrush(w).HasChanged:=true;
        TMyBrush(w).OnChange:=grid.Brushchanged;
        end
      else
        w:=NIL;
      w:=SetItemCell(ACol,ARow, Target, w);
      if w<>NIL then
        TBrush(w).Free;
      end;
  end;
(*@\\\0000001023*)
(*@/// function CopyBrushCol(Source,Target:TList; Count:integer; ...):boolean; *)
function CopyBrushCol(Source,Target:TList; Count:integer; grid:TStringAlignGrid):boolean;
var
  v,w:pointer;
  ACol: integer;
begin
  result:=false;
  for ACol:=0 to Count-1 do begin
    v:=GetItemCol(ACol,Source);
    if (v<>NIL) and TMyBrush(v).HasChanged then begin
      result:=true;
      w:=TMyBrush.Create;
      TBrush(w).assign(TBrush(v));
      TMyBrush(w).HasChanged:=true;
      TMyBrush(w).OnChange:=grid.Brushchanged;
      end
    else
      w:=NIL;
    w:=SetItemCol(ACol, Target, w);
    if w<>NIL then
      TBrush(w).Free;
    end;
  end;
(*@\\\0000000E21*)

(*@/// procedure TGridComponentEditor.Edit;                          // OnCreate *)
procedure TGridComponentEditor.Edit;
(*@/// The captions in the component edit - change here for internalization *)
const
  align_str : array[0..3] of string = ('Default','Right','Left','Center');
  edit_str : array[0..2] of string = ('Default','Read only','Editable');
  align_cap : array[0..4] of string = ('Cell','Column','Fixed Column','Row','Fixed Row');
  edit_cap : array[0..2] of string = ('Cell','Column','Row');
  font_str : array[0..1] of string = ('Default','Custom');
  cap_showcell = 'Edit Cells';
  cap_showhint = 'Edit Hints';
  cap_alignment = 'Alignment';
  cap_color = 'Color';
  cap_font = 'Font';
  cap_edit = 'Editable';
(*@\\\*)
var
  i,j: integer;
  edit_form: TForm;
  button: TButton;
  source: TStringAlignGrid;
  sub_item,ShowFont,ShowAlign,ShowEdit,ShowColor: TMenuItem;
  main_item: array[0..4] of tmenuitem;
  edit_item: array[0..2] of tmenuitem;
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
  fixedcolor:=source.fixedcolor;
  font:=source.font;
  if newstylecontrols then
    DefaultRowHeight:=18;
  OnMouseDown:=self.MouseDown;
  Parent:=edit_form;
  end;
(*@\\\0000000E01*)
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
(*@/// edits *)
for j:=0 to 2 do begin
  for i:=0 to 2 do begin
    sub_item:=NewItem(edit_str[i],0,false,true,self.EditItem,0,'');
    self.Edit_Items[j,i]:=sub_item;
    end;
  sub_item:=NewSubMenu(edit_cap[j],0,'',[
    edit_Items[j,0],
    edit_Items[j,1],
    edit_Items[j,2]
    ]);
  edit_item[j]:=sub_item;
  end;
(*@\\\0000000301*)
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
ShowEdit:=NewSubMenu(cap_edit,0,'',[
  edit_item[0],edit_item[1],edit_item[2]]);
ShowFont:=NewSubMenu(cap_font,0,'',[
  font_item[0],font_item[1],font_item[2],font_item[3],font_item[4]]);
ShowColor:=NewSubMenu(cap_color,0,'',[
  Color_item[0],Color_item[1],Color_item[2],Color_item[3],Color_item[4]]);

popup_menu:=NewPopupMenu(edit_form,'Popup',paleft,false,
   [ShowAlign,ShowFont,ShowColor,ShowEdit,
   ShowCells,ShowHints]
  );
(*@\\\0000001301*)
(*@///   Data source -> grid *)
CopyAlignCell (source.FAlignCell,grid.FAlignCell,source.colcount,source.rowcount);
CopyAlignCol  (source.FAlignCol ,grid.FAlignCol,source.colcount);
CopyAlignCol  (source.FFAlignCol,grid.FFAlignCol,source.colcount);
CopyAlignCol  (source.FAlignRow ,grid.FAlignRow,source.rowcount);
CopyAlignCol  (source.FFAlignRow,grid.FFAlignRow,source.rowcount);
CopyEditCell  (source.FEditCell ,grid.FEditCell,source.colcount,source.rowcount);
CopyEditCol   (source.FEditCol  ,grid.FEditCol,source.colcount);
CopyEditCol   (source.FEditRow  ,grid.FEditRow,source.rowcount);
CopyStringCell(source.FHintCell ,grid.FHintCell,source.colcount,source.rowcount);
CopyStringCell(source.FCell     ,grid.FCell,source.colcount,source.rowcount);
CopyFontCell  (source.FFontCell ,grid.FFontCell,source.colcount,source.rowcount,grid);
CopyFontCol   (source.FFontCol  ,grid.FFontCol,source.colcount,grid);
CopyFontCol   (source.FFFontCol ,grid.FFFontCol,source.colcount,grid);
CopyFontCol   (source.FFontRow  ,grid.FFontRow,source.rowcount,grid);
CopyFontCol   (source.FFFontRow ,grid.FFFontRow,source.rowcount,grid);
{ CopyColorCell (source.FColorCell ,grid.FColorCell,source.colcount,source.rowcount); }
{ CopyColorCol  (source.FColorCol  ,grid.FColorCol,source.colcount); }
{ CopyColorCol  (source.FFColorCol ,grid.FFColorCol,source.colcount); }
{ CopyColorCol  (source.FColorRow  ,grid.FColorRow,source.rowcount); }
{ CopyColorCol  (source.FFColorRow ,grid.FFColorRow,source.rowcount); }
CopyBrushCell (source.FBrushCell,grid.FBrushCell,source.colcount,source.rowcount,grid);
CopyBrushCol  (source.FBrushCol ,grid.FBrushCol,source.colcount,grid);
CopyBrushCol  (source.FFBrushCol,grid.FFBrushCol,source.colcount,grid);
CopyBrushCol  (source.FBrushRow ,grid.FBrushRow,source.rowcount,grid);
CopyBrushCol  (source.FFBrushRow,grid.FFBrushRow,source.rowcount,grid);
(*@\\\0000001901*)
  grid.ListToCells(grid.FCell);
  grid.f_fixedcols:=source.fixedcols;
  grid.f_fixedrows:=source.fixedrows;
  grid.FAlwaysEdit:=true;
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
source.FSaveEditCell      :=CopyEditCell  (grid.FEditCell ,source.FEditCell,source.colcount,source.rowcount);
source.FSaveEditCol       :=CopyEditCol   (grid.FEditCol  ,source.FEditCol ,source.colcount);
source.FSaveEditRow       :=CopyEditCol   (grid.FEditRow  ,source.FEditRow ,source.rowcount);
source.FSaveHint          :=CopyStringCell(grid.FHintCell ,source.FHintCell,source.colcount,source.rowcount);
source.FSaveCells         :=CopyStringCell(grid.FCell     ,source.FCell,source.colcount,source.rowcount);
source.FSaveFontCell      :=CopyFontCell  (grid.FFontCell ,source.FFontCell,source.colcount,source.rowcount,source);
source.FSaveFontCol       :=CopyFontCol   (grid.FFontCol  ,source.FFontCol,source.colcount,source);
source.FSaveFixedFontCol  :=CopyFontCol   (grid.FFFontCol ,source.FFFontCol,source.colcount,source);
source.FSaveFontRow       :=CopyFontCol   (grid.FFontRow  ,source.FFontRow,source.rowcount,source);
source.FSaveFixedFontRow  :=CopyFontCol   (grid.FFFontRow ,source.FFFontRow,source.rowcount,source);
{ source.FSaveColorCell     :=CopyColorCell (grid.FColorCell,source.FColorCell,source.colcount,source.rowcount); }
{ source.FSaveColorCol      :=CopyColorCol  (grid.FColorCol ,source.FColorCol,source.colcount); }
{ source.FSaveFixedColorCol :=CopyColorCol  (grid.FFColorCol,source.FFColorCol,source.colcount); }
{ source.FSaveColorRow      :=CopyColorCol  (grid.FColorRow ,source.FColorRow,source.rowcount); }
{ source.FSaveFixedColorRow :=CopyColorCol  (grid.FFColorRow,source.FFColorRow,source.rowcount); }
source.FSaveBrushCell     :=CopyBrushCell (grid.FBrushCell,source.FBrushCell,source.colcount,source.rowcount,source);
source.FSaveBrushCol      :=CopyBrushCol  (grid.FBrushCol ,source.FBrushCol,source.colcount,source);
source.FSaveFixedBrushCol :=CopyBrushCol  (grid.FFBrushCol,source.FFBrushCol,source.colcount,source);
source.FSaveBrushRow      :=CopyBrushCol  (grid.FBrushRow ,source.FBrushRow,source.rowcount,source);
source.FSaveFixedBrushRow :=CopyBrushCol  (grid.FFBrushRow,source.FFBrushRow,source.rowcount,source);
(*@\\\0000000C01*)
    source.ListToCells(source.FCell);
    if GetParentForm(source).Designer<>NIL then
      GetParentForm(source).Designer.Modified;
    end;
  edit_form.Free;
  end;
(*@\\\0000001E01*)
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
(*@///   else if sender=ShowCells then begin *)
else if sender=ShowCells then begin
  if ShowCells.checked then EXIT;
  ShowCells.Checked:=true;
  ShowHints.Checked:=false;
  grid.CellsToList(grid.FHintCell);
  grid.ListToCells(grid.FCell);
  end
(*@\\\*)
(*@///   else if sender=ShowHints then begin *)
else if sender=ShowHints then begin
  if ShowHints.checked then EXIT;
  ShowCells.Checked:=false;
  ShowHints.Checked:=true;
  grid.CellsToList(grid.FCell);
  grid.ListToCells(grid.FHintCell);
  end
(*@\\\*)
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
(*@\\\0000000A01*)
(*@/// procedure TGridComponentEditor.EditItem(Sender: TObject);     // MenuClick edit *)
procedure TGridComponentEditor.EditItem(Sender: TObject);
var
  i,j: integer;
  editable: boolean;
  ACol,ARow: integer;
begin
  ACol:=PopupCell.X;
  ARow:=PopupCell.Y;
  for i:=0 to 4 do
    for j:=0 to 3 do begin
      if sender=Edit_Items[i,j] then begin
        if Edit_Items[i,j].checked then EXIT;
        if j=0 then  (* reset it *)
          case i of
            0: grid.ResetEditCell(ACol,ARow);
            1: grid.ResetEditCol(ACol);
            2: grid.ResetEditRow(ARow);
            end
        else begin
          editable:=(j=2);
          case i of
            0: grid.EditCell[ACol,ARow]:=editable;
            1: grid.EditCol[ACol]:=editable;
            2: grid.EditRow[ARow]:=editable;
            end;
          end;
        end;
      end;
  end;
(*@\\\0000001C01*)
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
(*@\\\0000002901*)
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
(*@\\\0000000701*)
(*@/// procedure TGridComponentEditor.MouseDown(Sender:TObject;..);  // OnPopup *)
procedure TGridComponentEditor.MouseDown(Sender:TObject; Button:TMouseButton; Shift: TSHiftstate; X,Y:Integer);
var
  ACol,ARow: longint;
  AColRow: longint;
  i,j: integer;
  same: boolean;
  Alignment: ^TMyAlign;
  editable: ^boolean;
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
      if i<3 then
        for j:=0 to 2 do
          Edit_Items[i,j].checked:=false;
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
(*@\\\0000000201*)
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
(*@\\\0000001507*)
(*@///       Set editable checks *)
(*@/// EditCell *)
editable:=GetItemCell(ACol,ARow,grid.FEditCell);
Edit_Items[0,0].checked:=editable=NIL;
if editable<>NIL then
  case editable^ of
    false: Edit_Items[0,1].checked:=true;
    true : Edit_Items[0,2].checked:=true;
    end;
(*@\\\000000050C*)
for i:=1 to 2 do begin
  case i of
    1: begin
      list:=grid.FEditCol;
      AColRow:=ACol;
      end;
    2: begin
      list:=grid.FEditRow;
      AColRow:=ARow;
      end;
    end;
(*@///   EditCol *)
editable:=GetItemCol(AColRow,List);
Edit_Items[i,0].checked:=editable=NIL;
if editable<>NIL then
  case editable^ of
    false: Edit_Items[i,1].checked:=true;
    true : Edit_Items[i,2].checked:=true;
    end;
(*@\\\0000000618*)
  end;
(*@\\\0000000D01*)
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
(*@///       Set color/brush checks *)
same:=GetItemCell(ACol,ARow,grid.FbrushCell)=NIL;
color_Items[0,0].checked:=same;
color_Items[0,1].checked:=not same;
same:=GetItemCol(ACol,grid.FbrushCol)=NIL;
color_Items[1,0].checked:=same;
color_Items[1,1].checked:=not same;
same:=GetItemCol(ACol,grid.FFbrushCol)=NIL;
color_Items[2,0].checked:=same;
color_Items[2,1].checked:=not same;
same:=GetItemCol(ARow,grid.FbrushRow)=NIL;
color_Items[3,0].checked:=same;
color_Items[3,1].checked:=not same;
same:=GetItemCol(ARow,grid.FFbrushRow)=NIL;
color_Items[4,0].checked:=same;
color_Items[4,1].checked:=not same;
(*@\\\*)
      temp_point:=grid.clienttoscreen(point(x,y));
      popup_menu.popup(temp_point.x,temp_point.y);
      end;
    end;
  end;
(*@\\\*)
(*@\\\*)

(*@/// To have OnShowHint/OnIdle lists instead of single methods *)
{ These are just a few help tools for the Application.OnShowHint and      }
{ Application.OnIdle methods - Borland didn't thought of the need to      }
{ put more than one method in these places, so I had to do it myself.     }
{ Some nice internals how to work with method pointer are presented here. }

(*@/// TObjectList = class(TList)       // A list which frees it's objects *)
type
  TObjectList = class(TList)
  public
    destructor Destroy; override;

{ Why hasn't Borland made the delete method virtual??? Now I must create      }
{ a new virtual slot with all the problems this may cause just because        }
{ of a missing word... - first cause is the remove method which is absolutely }
{ the same as in TList, but as Delete isn't virtual I need it here again.     }

{ I you want to use this component anywhere else be VERY careful, any call    }
{ as a TList may cause problems                                               }

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
(*@\\\*)

type
  TMethodPointer = procedure of object;
(*@///   TMethod = class(TObject)       // Object with just one methodpointer *)
TMethod = class(TObject)
public
  methodpointer: TMethodPointer;
  end;
(*@\\\*)

const
  ShowHintProcs: TObjectList =NIL;
  IdleProcs: TObjectList     =NIL;

(*@/// TDummyObject = class(TObject)    // A dummy object for the Application events *)
{ A little dummy object which provides the methods to be put in the     }
{ application's method pointers; if you use this you shouldn't access   }
{ Application.OnIdle and Application.OnShowHint directly but always use }
{ the Add/RemoveXXXProc routines                                        }
{ You can add any other Application.OnXXX method here if you need it    }

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
(*@\\\0000000517*)
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
(*@\\\0000000D01*)

const
  Dummy: TDummyObject        =NIL;

(*@/// Compare two method pointers *)
function compare_method(proc1,proc2:TMethodpointer):boolean;

{ A method pointer is just a record of two pointers, one the procedure }
{ pointer itself, then the self pointer which is pushed as the first   }
{ parameter of the procedure                                           }

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
(*@\\\0000000A01*)
(*@/// Include and remove the Methodpointer from the according lists *)
(*@/// procedure AddShowHintProc(proc:TShowHintEvent); *)
procedure AddShowHintProc(proc:TShowHintEvent);
var
  method: TMethod;
begin
  if (dummy=NIL) or (showhintprocs=NIL) then exit;
  method:=TMethod.Create;
  method.methodpointer:=TMethodPointer(proc);
  showhintprocs.add(method);
  Application.OnShowHint:=dummy.ShowHint;
  end;
(*@\\\0000000601*)
(*@/// procedure RemoveShowHintProc(proc:TShowHintEvent); *)
procedure RemoveShowHintProc(proc:TShowHintEvent);
var
  i: integer;
begin
  if (dummy=NIL) or (showhintprocs=NIL) then exit;
  for i:=showhintprocs.count-1 downto 0 do
    if (showhintprocs.items[i]<>NIL) and
       compare_method(TMethod(showhintprocs.items[i]).methodpointer,
                      TMethodpointer(proc))  then
      showhintprocs.delete(i);
  end;
(*@\\\0000000501*)
(*@/// procedure AddIdleProc(proc:TIdleEvent); *)
procedure AddIdleProc(proc:TIdleEvent);
var
  method: TMethod;
begin
  if (dummy=NIL) or (idleprocs=NIL) then exit;
  method:=TMethod.Create;
  method.methodpointer:=TMethodPointer(proc);
  idleprocs.add(method);
  Application.OnIdle:=dummy.DoIdle;
  end;
(*@\\\0000000501*)
(*@/// procedure RemoveIdleProc(proc:TIdleEvent); *)
procedure RemoveIdleProc(proc:TIdleEvent);
var
  i: integer;
begin
  if (dummy=NIL) or (idleprocs=NIL) then exit;
  for i:=idleprocs.count-1 downto 0 do
    if (idleprocs.items[i]<>NIL) and
       compare_method(TMethod(idleprocs.items[i]).methodpointer,
                      TMethodpointer(proc))  then
      idleprocs.delete(i);
  end;
(*@\\\0000000501*)
(*@\\\0000000120*)
(*@\\\0000001601*)

(*@/// procedure DoneUnit;  // The cleanup of the unit *)
procedure DoneUnit; far;
begin
  ShowHintProcs.Free;
  ShowHintProcs:=NIL;
  IdleProcs.Free;
  IdleProcs:=NIL;
  Dummy.Free;
  Dummy:=NIL;
  end;
(*@\\\*)
(*@/// procedure Register;  // To display the grid in the IDE *)
procedure Register;
begin
  RegisterComponents('Custom', [TStringAlignGrid]);
  RegisterComponentEditor(TStringAlignGrid,TGridComponentEditor);
  end;
(*@\\\*)
(*@\\\0000000B01*)
(*@/// initialization *)
var
  t:TShowHintEvent;
(*$ifdef ver80 *)
begin
(*$else *)
initialization
begin
(*$endif *)
  Dummy:=TDummyObject.Create;
  ShowHintProcs:=TObjectList.Create;
  IdleProcs:=TObjectList.Create;
  t:=application.OnShowHint;
  if assigned(t) then      { D1 can't do a assigned of a property }
    AddShowHintProc(t);    { In design mode the OnShowHint is responsible
                             for the hints of the component palette so I
                             need to remember this }
(*@\\\*)
(*@/// finalization *)
(*$ifdef ver80 *)
  AddExitProc(DoneUnit);
(*$else *)
  end;
finalization
  DoneUnit;
(*$endif *)
(*@\\\0000000201*)
end.
(*@\\\0003000F01000011000F01*)
