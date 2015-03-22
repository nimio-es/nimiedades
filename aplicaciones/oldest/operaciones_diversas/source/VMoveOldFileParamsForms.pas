unit VMoveOldFileParamsForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit;

type
  TMoveOldFilesParamsForm = class(TForm)
    borrarOLDCheckBox: TCheckBox;
    borrarDELCheckBox: TCheckBox;
    Label1: TLabel;
    fechaCorteEdit: TDateEdit;
    aceptarButton: TButton;
    cancelarButton: TButton;
    procedure fechaCorteEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MoveOldFilesParamsForm: TMoveOldFilesParamsForm;

implementation

{$R *.dfm}

// ^^^^^^^
// EVENTOS
// ^^^^^^^

// Sólo se admiten fechas menores al día en curso
// Dependiendo de la "distancia" entre la fecha introducida y la fecha del día de hoy
// se pondrá un color y otro.
// Negro (de un mes para atrás)
// Amarillo (menos/igual mes hasta 15 días)
// Rojo (menos/igual 15 días)
procedure TMoveOldFilesParamsForm.fechaCorteEditChange(Sender: TObject);
var
  today,
  fechaCorte: TDateTime;
  dif: Integer;
  nuevoColor: TColor;
begin
  today := date();
  fechaCorte := TDateEdit( Sender ).Date;
  dif := Trunc( today - fechaCorte );

  nuevoColor := clBlack;
  if (dif <= 30) and (dif > 15) then
    nuevoColor := $004080FF
  else if (dif <= 15) and (dif > 0) then
    nuevoColor := clRed
  else if (dif <= 0) then
    raise Exception.Create('La fecha de corte debe ser, como máximo, el día de ayer.');

  TDateEdit(Sender).Font.Color := nuevoColor;

end;

end.
