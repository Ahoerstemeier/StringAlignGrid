unit Aligrid;

{ (c) 1995/96 Andreas Hörstemeier  }
{ Version 1.1     1996-07-03       }
{ this component is public domain  }
{ please check the file readme.txt }
{ for more detailed info on usage  }
{ and distributing                 }

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
  Grids;
(*@\\\0000000B03*)

type TMyAlign=(alRight,alLeft,alCenter);

(*@/// TStringAlignGrid=class(TStringGrid) *)
TStringAlignGrid = class(TStringGrid)
private
  FAlign: TMyAlign;
  FAlignCol: TList;
  FFAlignCol: TList;
  FAlignCell: TList;
  function GetAlign: TMyAlign;
  procedure SetAlign(const Value: TMyAlign);
  function GetAlignCol(ACol: integer):TMyAlign;
  procedure SetAlignCol(ACol: integer; const Value: TMyAlign);
  function GetFixAlignCol(ACol: integer):TMyAlign;
  procedure SetFixAlignCol(ACol: integer; const Value: TMyAlign);
  function GetAlignCell(ACol,ARow: integer):TMyAlign;
  procedure SetAlignCell(ACol,ARow: integer; const Value: TMyAlign);
  procedure Initialize;
protected
  procedure DrawCell(ACol,ARow: Longint; ARect: TRect;
    AState: TGridDrawState); override;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  property AlignCell[ACol,ARow:integer]: TMyAlign read GetAlignCell write SetAlignCell;
  property AlignCol[ACol:integer]: TMyAlign read GetAlignCol write SetAlignCol;
  property FixAlignCol[ACol:integer]: TMyAlign read GetFixAlignCol write SetFixAlignCol;
  procedure ResetAlignCell(ACol,ARow:integer);
  procedure ResetAlignCol(ACol:integer);
  procedure ResetFAlignCol(ACol:integer);
  procedure ResetAlignment;
published
  property Alignment: TMyAlign read GetAlign write SetAlign default alLeft;
end;
(*@\\\0000001C01*)

procedure Register;
(*@\\\0000000527*)
(*@/// implementation *)
implementation

(*@/// constructor TStringAlignGrid.Create(AOwner: TComponent); *)
constructor TStringAlignGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Initialize;
  end;
(*@\\\0000000507*)
(*@/// destructor TStringAlignGrid.Destroy; *)
destructor TStringAlignGrid.Destroy;
var
  i,j:integer;
begin
  for i:=0 to FAlignCol.Count-1 do
    if FAlignCol.Items[i] <> NIL then
      Dispose(FAlignCol.Items[i]);
  FAlignCol.Destroy;
  for i:=0 to FFAlignCol.Count-1 do
    if FFAlignCol.Items[i] <> NIL then
      Dispose(FFAlignCol.Items[i]);
  FFAlignCol.Destroy;
  for i:=0 to FAlignCell.Count-1 do
    if FAlignCell.Items[i] <> NIL then begin
      for j:=0 to TList(FAlignCell.Items[i]).Count-1 do
        if TList(FAlignCell.Items[i]).Items[j] <> NIL then
          Dispose(TList(FAlignCell.Items[i]).Items[j]);
      TList(FAlignCell.Items[i]).Destroy;
      end;
  FAlignCell.Destroy;
  inherited Destroy;
  end;
(*@\\\0000000707*)
(*@/// procedure TStringAlignGrid.Initialize; *)
procedure TStringAlignGrid.Initialize;
begin
  FAlignCol:=TList.Create;
  FFAlignCol:=TList.Create;
  FAlignCell:=TList.Create;
  FAlign:=alLeft;
  end;
(*@\\\000000051C*)
(*@/// function TStringAlignGrid.GetAlignCol(ACol:Integer):TMyAlign; *)
function TStringAlignGrid.GetAlignCol(ACol:Integer):TMyAlign;
var
  v:^tmyalign;
begin
  if ACol+1 > FAlignCol.Count then
    GetAlignCol:=Alignment
  else
    if FAlignCol.Items[ACol] = NIL then
      GetAlignCol:=Alignment
    else begin
      v:=FAlignCol.Items[ACol];
      GetAlignCol:=v^
      end;
  end;
(*@\\\0000000E07*)
(*@/// procedure TStringAlignGrid.SetAlignCol(ACol:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlignCol(ACol:integer; const Value: TMyAlign);
var
  i:integer;
  v:^tmyalign;
begin
  if ACol+1 > FAlignCol.Count then
    for i:=FAlignCol.Count to ACol do
      FAlignCol.Add(NIL);
  if FAlignCol.Items[ACol] <> NIL then begin
    v:=FAlignCol.Items[ACol];
    v^:=value
  end else begin
    New(v);
    v^:=value;
    FAlignCol.Items[ACol]:=v;
    end;
  Invalidate;
  end;
(*@\\\0000000201*)
(*@/// function TStringAlignGrid.GetFixAlignCol(ACol:Integer):TMyAlign; *)
function TStringAlignGrid.GetFixAlignCol(ACol:Integer):TMyAlign;
var
  v:^tmyalign;
begin
  if ACol+1 > FFAlignCol.Count then
    GetFixAlignCol:=Alignment
  else
    if FFAlignCol.Items[ACol] = NIL then
      GetFixAlignCol:=Alignment
    else begin
      v:=FFAlignCol.Items[ACol];
      GetFixAlignCol:=v^
      end;
  end;
(*@\\\0000000E07*)
(*@/// procedure TStringAlignGrid.SetFixAlignCol(ACol:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetFixAlignCol(ACol:integer; const Value: TMyAlign);
var
  i:integer;
  v:^tmyalign;
begin
  if ACol+1 > FFAlignCol.Count then
    for i:=FFAlignCol.Count to ACol do
      FFAlignCol.Add(NIL);
  if FFAlignCol.Items[ACol] <> NIL then begin
    v:=FFAlignCol.Items[ACol];
    v^:=value
  end else begin
    New(v);
    v^:=value;
    FFAlignCol.Items[ACol]:=v;
    end;
  Invalidate;
  end;
(*@\\\0000000701*)
(*@/// function TStringAlignGrid.GetAlignCell(ACol,ARow:Integer):TMyAlign; *)
function TStringAlignGrid.GetAlignCell(ACol,ARow:Integer):TMyAlign;
(*@/// function AnyAlignCol(ACol:integer):TMyAlign; *)
function AnyAlignCol(ACol:integer):TMyAlign;
begin
  if ARow >= FixedRows then
    AnyAlignCol:=AlignCol[ACol]
  else
    AnyAlignCol:=FixAlignCol[ACol];
  end;
(*@\\\0000000610*)
var
  v:^tmyalign;
  sublist: TList;
begin
  if ACol+1 > FAlignCell.Count then
    GetAlignCell:=AnyAlignCol(ACol)
  else
    if FAlignCell.Items[ACol] = NIL then
      GetAlignCell:=AnyAlignCol(ACol)
    else begin
      sublist:=TList(FAlignCell.Items[ACol]);
      if ARow+1 > sublist.Count then
        GetAlignCell:=AnyAlignCol(ACol)
      else
        if sublist.Items[ARow] = NIL then
          GetAlignCell:=AnyAlignCol(ACol)
        else begin
          v:=sublist.Items[ARow];
          GetAlignCell:=v^
        end;
    end;
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.SetAlignCell(ACol,ARow:integer; const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlignCell(ACol,ARow:integer; const Value: TMyAlign);
var
  i:integer;
  v:^tmyalign;
  sublist:TList;
begin
  if ACol+1 > FAlignCell.Count then
    for i:=FAlignCell.Count to ACol do
      FAlignCell.Add(NIL);
  if FAlignCell.Items[ACol] = NIL then
    FAlignCell.Items[ACol]:=TList.Create;
  sublist:=TList(FAlignCell.Items[ACol]);
  if ARow+1 > sublist.Count then
    for i:=sublist.Count to ARow do
      sublist.Add(NIL);
  if sublist.items[ARow] <> NIL then begin
    v:=sublist.Items[ARow];
    v^:=value
    end
  else begin
    New(v);
    v^:=value;
    sublist.Items[ARow]:=v;
    end;
  Invalidate;
  end;
(*@\\\*)
(*@/// function TStringAlignGrid.GetAlign: TMyAlign; *)
function TStringAlignGrid.GetAlign: TMyAlign;
begin
  GetAlign:=FAlign;
  end;
(*@\\\000000030B*)
(*@/// procedure TStringAlignGrid.SetAlign(const Value: TMyAlign); *)
procedure TStringAlignGrid.SetAlign(const Value: TMyAlign);
begin
  FAlign:=Value;
  Invalidate;
  end;
(*@\\\000000030B*)
(*@/// procedure TStringAlignGrid.ResetAlignCell(ACol,ARow:integer); *)
procedure TStringAlignGrid.ResetAlignCell(ACol,ARow:integer);
var
  sublist: TList;
begin
  if ACol+1 > FAlignCell.Count then
    EXIT
  else
    if FAlignCell.Items[ACol] = NIL then
      EXIT
    else begin
      sublist:=TList(FAlignCell.Items[ACol]);
      if ARow+1 > sublist.Count then
        EXIT
      else
        if sublist.Items[ARow] <> NIL then begin
          Dispose(sublist.Items[ARow]);
          sublist.Items[ARow]:=NIL;
          Invalidate;
        end;
    end;
  end;
(*@\\\0000001201*)
(*@/// procedure TStringAlignGrid.ResetAlignCol(ACol:integer); *)
procedure TStringAlignGrid.ResetAlignCol(ACol:integer);
begin
  if ACol+1 > FAlignCol.Count then
    EXIT
  else if FAlignCol.Items[ACol] <> NIL then begin
    Dispose(FAlignCol.Items[ACol]);
    FAlignCol.Items[ACol]:=NIL;
    Invalidate;
    end;
  end;
(*@\\\0000000301*)
(*@/// procedure TStringAlignGrid.ResetFAlignCol(ACol:integer); *)
procedure TStringAlignGrid.ResetFAlignCol(ACol:integer);
begin
  if ACol+1 > FFAlignCol.Count then
    EXIT
  else if FFAlignCol.Items[ACol] <> NIL then begin
    Dispose(FFAlignCol.Items[ACol]);
    FFAlignCol.Items[ACol]:=NIL;
    Invalidate;
    end;
  end;
(*@\\\0000000601*)
(*@/// procedure TStringAlignGrid.ResetAlignment; *)
procedure TStringAlignGrid.ResetAlignment;
begin
  FAlign:=alLeft;
  Invalidate;
  end;
(*@\\\000C000101000507000309*)
(*@/// procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; *)
procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
(*@/// procedure DrawCellText; *)
procedure DrawCellText;
var
  Text:array[0..255] of char;
  l:integer;
  Left:integer;
  AlignValue:TMyAlign;
begin
  StrPCopy(Text, Cells[ACol, ARow]);
  l:=Canvas.TextWidth(Cells[ACol, ARow]);

{ if nothing is set use left bounding }
  Left:=ARect.Left;

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
(*@\\\0000000E01*)
begin
  if DefaultDrawing then
    DrawCellText
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
  end;
(*@\\\0000000301*)
(*@\\\0030001201000101001101*)

(*@/// procedure Register; *)
procedure Register;
begin
  RegisterComponents('Custom', [TStringAlignGrid]);
  end;
(*@\\\0000000403*)

end.
(*@\\\0003000A01000011000A01*)
