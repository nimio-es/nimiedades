program OpDivCIA;

uses
  Forms,
  VInicio in 'VInicio.pas' {Inicio},
  UGlobalData in 'UGlobalData.pas',
  VOpenRecord in 'VOpenRecord.pas' {OpenRecord},
  CCriptografiaCutre in 'CCriptografiaCutre.pas',
  VConfigSystemForm in 'VConfigSystemForm.pas' {ConfigSystemForm},
  CDBMiddleEngine in 'CDBMiddleEngine.pas',
  CCustomDBMiddleEngine in 'CCustomDBMiddleEngine.pas',
  COpDivRecType05 in 'COpDivRecType05.pas',
  VCustomRecordForm in 'VCustomRecordForm.pas' {CustomRecordForm},
  COpDivSystemRecord in 'COpDivSystemRecord.pas',
  VOpDivRecType05 in 'VOpDivRecType05.pas' {OpDivRecType05Form},
  VOpDivRecType06Form in 'VOpDivRecType06Form.pas' {OpDivRecType06Form},
  COpDivRecType06 in 'COpDivRecType06.pas',
  VOpDivRecType07Form in 'VOpDivRecType07Form.pas' {OpDivRecType07Form},
  COpDivRecType07 in 'COpDivRecType07.pas',
  VOpDivRecType08Form in 'VOpDivRecType08Form.pas' {OpDivRecType08Form},
  VOpDivRecType09Form in 'VOpDivRecType09Form.pas' {OpDivRecType09Form},
  CQueryEngine in 'CQueryEngine.pas',
  COpDivRecType09 in 'COpDivRecType09.pas',
  VOpDivRecType12Form in 'VOpDivRecType12Form.pas' {OpDivRecType12Form},
  COpDivRecType12 in 'COpDivRecType12.pas',
  COpDivRecType08 in 'COpDivRecType08.pas',
  VOpDivRecType10Form in 'VOpDivRecType10Form.pas' {OpDivRecType10Form},
  COpDivRecType10 in 'COpDivRecType10.pas',
  VOpDivRecType14Form in 'VOpDivRecType14Form.pas' {OpDivRecType14Form},
  COpDivRecType14 in 'COpDivRecType14.pas',
  VOpDivRecType02Form in 'VOpDivRecType02Form.pas' {OpDivRecType02Form},
  COpDivRecType02 in 'COpDivRecType02.pas',
  VOpDivRecType03Form in 'VOpDivRecType03Form.pas' {OpDivRecType03Form},
  COpDivRecType03 in 'COpDivRecType03.pas',
  COpDivRecType04 in 'COpDivRecType04.pas',
  VOpDivRecType04Form in 'VOpDivRecType04Form.pas' {OpDivRecType04Form},
  CGenSopAgent in 'CGenSopAgent.pas',
  VSelRecSoporteForm in 'VSelRecSoporteForm.pas' {SelRecSoporteForm},
  CSoporte in 'CSoporte.pas',
  VConstSoporte in 'VConstSoporte.pas' {ConstSoporteForm},
  UAuxRefOp in 'UAuxRefOp.pas',
  VGenSopFile in 'VGenSopFile.pas' {GenSopFileForm},
  VOpDivRecTypeDevForm in 'VOpDivRecTypeDevForm.pas' {OpDivRecTypeDevForm},
  COpDivRecTypeDev in 'COpDivRecTypeDev.pas',
  CListadosAgent in 'CListadosAgent.pas',
  VSelListadoForm in 'VSelListadoForm.pas' {SelListadoForm},
  VSelTipoOpListadoForm in 'VSelTipoOpListadoForm.pas' {SelTipoOpListadoForm},
  CListadoTipoOpAgent in 'CListadoTipoOpAgent.pas',
  VShowListadoText in 'VShowListadoText.pas' {ShowListadoTextForm},
  UAuxClaveAut in 'UAuxClaveAut.pas',
  CPrintOpAgent in 'CPrintOpAgent.pas',
  VSearchRecAux in 'VSearchRecAux.pas' {SearchRecAuxForm},
  CPrintSopAgent in 'CPrintSopAgent.pas',
  CMoveOldFilesAgent in 'CMoveOldFilesAgent.pas',
  VMoveOldFileParamsForms in 'VMoveOldFileParamsForms.pas' {MoveOldFilesParamsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TInicio, Inicio);
  Application.Run;
end.
