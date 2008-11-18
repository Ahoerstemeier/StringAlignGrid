unit Aligrid;

{ (c) 1995 Andreas Hörstemeier
  this component is public domain
  please check the file readme.txt
  for more detailed info on usage
  and distributing }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids;

type TMyAlign = ( alRight, alLeft, alCenter);

type
  TStringAlignGrid = class(TStringGrid)
  private
    FAlign : TMyAlign;
    FAlignCol : TList;
    FFAlignCol : TList;
    function GetAlign:TMyAlign;
    procedure SetAlign(const Value: TMyAlign);
    function GetAlignCol(ACol:Integer):TMyAlign;
    procedure SetAlignCol(ACol:integer; const Value: TMyAlign);
    function GetFixAlignCol(ACol:Integer):TMyAlign;
    procedure SetFixAlignCol(ACol:integer; const Value: TMyAlign);
    procedure Initialize;
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AlignCol[ACol: Integer]: TMyAlign read GetAlignCol write SetAlignCol;
    property FixAlignCol[ACol: Integer]: TMyAlign read GetFixAlignCol write SetFixAlignCol;
  published
    property Alignment: TMyAlign read GetAlign write SetAlign default alLeft;
  end;

procedure Register;

implementation

constructor TStringAlignGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Initialize;
end;

destructor TStringAlignGrid.Destroy;
var i:integer;
begin
   for i:=0 to FAlignCol.Count-1 do
      if FAlignCol.Items[i] <> NIL then
         Dispose(FAlignCol.Items[i]);
   FAlignCol.Destroy;
   for i:=0 to FFAlignCol.Count-1 do
      if FFAlignCol.Items[i] <> NIL then
         Dispose(FFAlignCol.Items[i]);
   FFAlignCol.Destroy;
   inherited Destroy;
end;

procedure TStringAlignGrid.Initialize;
begin
   FAlignCol := TList.Create;
   FFAlignCol := TList.Create;
   FAlign := alLeft;
end;

function TStringAlignGrid.GetAlignCol(ACol:Integer):TMyAlign;
var v:^tmyalign;
begin
   if ACol+1 > FAlignCol.Count then
      Result := Alignment
   else
      if FAlignCol.Items[ACol] = NIL then
         Result := Alignment
      else begin
         v := FAlignCol.Items[ACol];
         Result := v^
      end;
end;

procedure TStringAlignGrid.SetAlignCol(ACol:integer; const Value: TMyAlign);
var i:integer;
    v:^tmyalign;
begin
   if ACol+1 > FAlignCol.Count then
      for i:= FAlignCol.Count to ACol do
         FAlignCol.Add(NIL);
   if FAlignCol.Items[ACol] <> NIL then begin
      v := FAlignCol.Items[ACol];
      v^ := value
   end else begin
      New(v);
      v^ := value;
      FAlignCol.Items[ACol] := v;
   end;
   Invalidate;
end;

function TStringAlignGrid.GetFixAlignCol(ACol:Integer):TMyAlign;
var v:^tmyalign;
begin
   if ACol+1 > FFAlignCol.Count then
      Result := Alignment
   else
      if FFAlignCol.Items[ACol] = NIL then
         Result := Alignment
      else begin
         v := FFAlignCol.Items[ACol];
         Result := v^
      end;
end;

procedure TStringAlignGrid.SetFixAlignCol(ACol:integer; const Value: TMyAlign);
var i:integer;
    v:^tmyalign;
begin
   if ACol+1 > FFAlignCol.Count then
      for i:= FFAlignCol.Count to ACol do
         FFAlignCol.Add(NIL);
   if FFAlignCol.Items[ACol] <> NIL then begin
      v := FFAlignCol.Items[ACol];
      v^ := value
   end else begin
      New(v);
      v^ := value;
      FFAlignCol.Items[ACol] := v;
   end;
   Invalidate;
end;

function TStringAlignGrid.GetAlign: TMyAlign;
begin
   Result := FAlign;
end;

procedure TStringAlignGrid.SetAlign(const Value: TMyAlign);
begin
   FAlign := Value;
   Invalidate;
end;


procedure TStringAlignGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);

  procedure DrawCellText;
  var
    Text: array[0..255] of Char;
    l : Integer;
    Left : Integer;
    AlignValue : TMyAlign;
  begin
    StrPCopy(Text, Cells[ACol, ARow]);
    l:=Canvas.TextWidth(Cells[ACol, ARow]);
    Left := ARect.Left;
    if ARow >= FixedRows then
       AlignValue := AlignCol[ACol]
    else
       AlignValue := FixAlignCol[ACol];
    if AlignValue in [alCenter] then begin
       l := ((Arect.Right-ARect.Left) - l ) div 2;
       Left := ARect.Left + l - 1;
    end;
    if AlignValue in [alRight] then
       Left := ARect.Right -l - 4 ;
    ExtTextOut(Canvas.Handle, Left+2, Arect.Top + 2,  ETO_CLIPPED or
      ETO_OPAQUE, @Arect, Text, StrLen(Text), nil);
  end;

begin
  if DefaultDrawing then DrawCellText else
     inherited DrawCell(ACol, ARow, ARect, AState);
end;

procedure Register;
begin
  RegisterComponents('Custom', [TStringAlignGrid]);
end;

end.
