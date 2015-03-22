unit VOpDivRecType10Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, ToolEdit, CurrEdit, StdCtrls, Mask, ExtCtrls,
  COpDivSystemRecord, COpDivRecType10, Menus, Buttons;

type
  TOpDivRecType10Form = class(TCustomRecordForm)
    Label1: TLabel;
    OrdenanteReembolsoEdit: TMaskEdit;
    DescReembolsoLabel: TLabel;
    Label2: TLabel;
    ConceptoReembolsoEdit: TMaskEdit;
    ConceptoDescLabel: TLabel;
    Label3: TLabel;
    conceptoComplementaEdit: TEdit;
    Label4: TLabel;
    IndicadorResidenciaEdit: TMaskEdit;
    Label5: TLabel;
    Label6: TLabel;
    procedure OrdenanteReembolsoEditExit(Sender: TObject);
    procedure ConceptoReembolsoEditExit(Sender: TObject);
    procedure conceptoComplementaEditExit(Sender: TObject);
    procedure IndicadorResidenciaEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType10Form: TOpDivRecType10Form;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType10Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType10( SystemRecord ) do
    begin
      OrdenanteReembolsoEdit.Text  := OrdenanteReembolso;
      DescReembolsoLabel.Caption   := OrdenanteDescripcion;
      ConceptoReembolsoEdit.Text   := ConceptoReembolso;
      ConceptoDescLabel.Caption    := ConceptoDescripcion;
      IndicadorResidenciaEdit.Text := IndicadorResidencia;
    end;
  end;


(*************
 EVENTOS
 *************)

procedure TOpDivRecType10Form.OrdenanteReembolsoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType10( FSystemRecord ).OrdenanteReembolso := TEdit( Sender ).Text ;
end;

procedure TOpDivRecType10Form.ConceptoReembolsoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType10( FSystemRecord ).ConceptoReembolso := TEdit( Sender ).Text ;
end;

procedure TOpDivRecType10Form.conceptoComplementaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType10( FSystemRecord ).ConceptoComplementa := TEdit( Sender ).Text ;
end;

procedure TOpDivRecType10Form.IndicadorResidenciaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType10( FSystemRecord ).IndicadorResidencia := TEdit( Sender ).Text ;
end;

end.
