unit VOpDivRecType14Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, ToolEdit, CurrEdit, StdCtrls, Mask, ExtCtrls,
  COpDivSystemRecord, COpDivRecType14, Menus, Buttons ;

type
  TOpDivRecType14Form = class(TCustomRecordForm)
    RegularizacionCUCCheckBox: TCheckBox;
    Label1: TLabel;
    conceptoComplementaEdit: TEdit;
    procedure RegularizacionCUCCheckBoxClick(Sender: TObject);
    procedure conceptoComplementaEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType14Form: TOpDivRecType14Form;

implementation

{$R *.DFM}


(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType14Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType14( SystemRecord ) do
    begin
      // 02.05.02 - A partir de ahora el campo de regularización siempre irá a cero.
      //            Sin embargo, para mantener compatibilidad descendente con los
      //            registros existentes, se mostrará dicha entrada cuando el registro
      //            sea anterior a la fecha de cambio.
      RegularizacionCUCCheckBox.Visible := (DateCreation < EncodeDate(2002, 05, 07));

      RegularizacionCUCCheckBox.Checked := RegularizacionCUC;
      conceptoComplementaEdit.Text      := ConceptoComplmenta;

    end;
  end;


(*************
 EVENTOS
 *************)

procedure TOpDivRecType14Form.RegularizacionCUCCheckBoxClick(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType14( FSystemRecord ).RegularizacionCUC := TCheckBox( Sender ).Checked ;
end;

procedure TOpDivRecType14Form.conceptoComplementaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType14( FSystemRecord ).ConceptoComplmenta := TEdit( Sender ).Text;
end;

end.
