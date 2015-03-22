unit VOpDivRecType05;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, ExtCtrls, Mask, StdCtrls, ToolEdit, CurrEdit, COpDivSystemRecord,
  COpDivRecType05, Menus, Buttons;

type
  TOpDivRecType05Form = class(TCustomRecordForm)
    Label6: TLabel;
    IdSubsistemaPresentaInicEdit: TMaskEdit;
    Label7: TLabel;
    Label8: TLabel;
    RefInicSubsEdit: TMaskEdit;
    Label9: TLabel;
    FigEntidadPresentaEdit: TMaskEdit;
    Label10: TLabel;
    Label11: TLabel;
    LibreEdit: TMemo;
    procedure IdSubsistemaPresentaInicEditExit(Sender: TObject);
    procedure RefInicSubsEditExit(Sender: TObject);
    procedure FigEntidadPresentaEditExit(Sender: TObject);
    procedure LibreEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
    procedure setErrorControlPos(const FieldWithError: String); override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType05Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType05( SystemRecord ) do
    begin
      IdSubsistemaPresentaInicEdit.Text := IDSubsPresentaInicial ;
      RefInicSubsEdit.Text            := RefInicDelSistema ;
      FigEntidadPresentaEdit.Text     := FigEntPresenta;
      LibreEdit.Text                  := Libre;
    end;
  end;

  procedure TOpDivRecType05Form.setErrorControlPos(const FieldWithError: String);
  begin
    inherited setErrorControlPos(FieldWithError);

    if FieldWithError <> k_GenericFieldError then
    begin

      if      FieldWithError = k05_IDSubsPresentaInicial then
        IdSubsistemaPresentaInicEdit.SetFocus()
      else if FieldWithError = k05_RefInicialSubsPresenta then
        RefInicSubsEdit.SetFocus()
      else if FieldWithError = k05_FiguraEntidadPresenta then
        FigEntidadPresentaEdit.SetFocus()
//      else if FieldWithError = k05_DisponibleItem
//        ;

    end;
  end;

(*************
 EVENTOS
 *************)
procedure TOpDivRecType05Form.IdSubsistemaPresentaInicEditExit(
  Sender: TObject);
var
  IdSubsistema: string;
begin
  inherited;

  IDSubsistema := trim( IdSubsistemaPresentaInicEdit.Text );
  if TOpDivRecType05( FSystemRecord ).IDSubsPresentaInicial <> IDSubsistema then
    TOpDivRecType05( FSystemRecord ).IDSubsPresentaInicial := IDSubsistema;
end;

procedure TOpDivRecType05Form.RefInicSubsEditExit(Sender: TObject);
var
  RefIniciaText: String;
begin
  inherited;
  RefIniciaText := trim( RefInicSubsEdit.Text );
  if TOpDivRecType05( FSystemRecord ).RefInicDelSistema <> RefIniciaText then
    TOpDivRecType05( FSystemRecord ).RefInicDelSistema := RefIniciaText ;
end;

procedure TOpDivRecType05Form.FigEntidadPresentaEditExit(Sender: TObject);
var
  texto: String ;
begin
  inherited;
  texto := trim( TMaskEdit( Sender ).EditText );
  if TOpDivRecType05( FSystemRecord ).FigEntPresenta <> texto then
    TOpDivRecType05( FSystemRecord ).FigEntPresenta := texto;
end;

procedure TOpDivRecType05Form.LibreEditExit(Sender: TObject);
var
  texto: String;
begin
  inherited;

  TMemo( Sender ).Text := UpperCase( TMemo( Sender ).Text );
  texto := trim( TMemo( Sender ).Text );
  if TopDivRecType05( FSystemRecord ).Libre <> texto then
    TopDivRecType05( FSystemRecord ).Libre := texto; 
end;

end.
