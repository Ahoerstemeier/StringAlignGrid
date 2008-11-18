unit aligridr;
  (*$i ah_def.inc *)
(*@/// interface *)
interface

uses
  classes,
  (*$ifdef delphi_ge_6 *)
  designintf,
  (*$else *)
  dsgnintf,
  (*$endif *)
  aligrid,
  aligredi;

procedure Register;
(*@\\\0000000914*)
(*@/// implementation *)
implementation

{$ifdef delphi_1}
  {$R aligrid.d16}
{$else}
  {$R aligrid.d32}
{$endif}

(*@/// procedure Register;  // To display the grid in the IDE *)
procedure Register;
(*$ifdef delphi_ge_6 *)
const
  TInputCategory = 'Input';
  TVisualCategory = 'Visual';
  TLocalizableCategory = 'Localizable';
  THelpCategory = 'Help and Hints';
  TActionCategory = 'Action';
  TMiscellaneousCategory = 'Miscellaneous';
(*$endif *)
begin
  RegisterComponents('Custom', [TStringAlignGrid]);
  RegisterComponentEditor(TStringAlignGrid,TGridComponentEditor);
(*$ifdef delphi_ge_5 *)
  RegisterPropertiesInCategory(TInputCategory, TStringAlignGrid,
    ['OnAfterEdit','OnCancelEdit','OnBeforeEdit','OnValidateEdit',
     'SelectEditText','EditMultiline','Editable','PasteEditableOnly',
     'AllowCutnPaste','AutoEditNextCell','NextCellEdit','AfterLastCellEdit']);
  RegisterPropertiesInCategory(TVisualCategory, TStringAlignGrid,
    ['Alignment','Wordwrap','FixedColor','RedrawWhileScroll',
     'DrawSelection','AutoAdjustLastCol','SelectedCellColor',
     'AlternateColorCol', 'AlternateColorRow',
     'DoAlternateColorCol', 'DoAlternateColorRow',
     'SelectedFontColor']);
  RegisterPropertiesInCategory(TLocalizableCategory, TStringAlignGrid,
    ['HTMLCaption']);
  RegisterPropertiesInCategory(THelpCategory, TStringAlignGrid,
    ['ShowCellHints','OnShowHintCell']);
  RegisterPropertiesInCategory(TActionCategory, TStringAlignGrid,
    ['OnFixedColClick','OnFixedRowClick']);
  RegisterPropertiesInCategory(TMiscellaneousCategory, TStringAlignGrid,
    ['HTMLBorder','OnCompareRow','OnCompareCol',
     'NextCellTab','AfterLastCellTab']);
(*$endif *)
  end;
(*@\\\003E00180100180100171E001731001801001801*)
(*@\\\0000000901*)
end.
(*@\\\0001000011000401*)
