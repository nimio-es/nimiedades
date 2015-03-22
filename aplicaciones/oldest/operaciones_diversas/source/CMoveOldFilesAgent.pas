unit CMoveOldFilesAgent;

interface

uses
  CDBMiddleEngine,
  VMoveOldFileParamsForms;

type

  TMoveOldFilesAgent = class( TObject )
    private
      FDialogParamsForm: TMoveOldFilesParamsForm;
      FParams: TMoveRecFilesParams;

      procedure copyParamsToForm;
      procedure copyFormToParams;

      procedure doMoveOldRecs;

    public
      constructor Create; virtual;
      destructor Destroy; override;

      procedure Execute;
  end;

implementation

uses
  Controls,
  UGlobalData;

//   ^^^^^^^^^^^^^^^^
//   MÉTODOS PRIVADOS
//   ^^^^^^^^^^^^^^^^

procedure TMoveOldFilesAgent.copyParamsToForm;
begin
  if assigned( FDialogParamsForm ) then
  begin
    FDialogParamsForm.fechaCorteEdit.Date := FParams.fechaCorte;
    FDialogParamsForm.borrarOLDCheckBox.Checked := FParams.borrarOldFiles;
    FDialogParamsForm.borrarDELCheckBox.Checked := FParams.borrarDelFiles;
    FDialogParamsForm.Refresh();
  end
end;

procedure TMoveOldFilesAgent.copyFormToParams;
begin
  FParams.fechaCorte := FDialogParamsForm.fechaCorteEdit.Date;
  FParams.borrarOldFiles := FDialogParamsForm.borrarOLDCheckBox.Checked;
  FParams.borrarDelFiles := FDialogParamsForm.borrarDELCheckBox.Checked;
end;

procedure TMoveOldFilesAgent.doMoveOldRecs;
begin
  TheDBMiddleEngine.lockGlobalRecords(getStationID());
  try
  finally
    TheDBMiddleEngine.unlockGlobalRecords()
  end
end;

//   ^^^^^^^^^^^^^^^^
//   MÉTODOS PÚBLICOS
//   ^^^^^^^^^^^^^^^^

//   CONSTRUCTORES Y DESTRUCTORES

constructor TMoveOldFIlesAgent.Create;
begin
  inherited;
  FParams := TMoveRecFilesParams.Create();
  FDialogParamsForm := TMoveOldFilesParamsForm.Create(nil);
end;

destructor TMoveOldFilesAgent.Destroy;
begin
  FDialogParamsForm.free();
  FParams.Free();
  inherited;
end;

// OTROS

procedure TMoveOldFilesAgent.Execute;
begin
  copyParamsToForm();
  if FDialogParamsForm.ShowModal() = mrOK then
  begin
    copyFormToParams();
    // ya tenemos los parámetros para mover los registros viejos
    doMoveOldRecs();
  end;
end;

end.
