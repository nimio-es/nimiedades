program GenConfig;

uses
  Forms,
  VGenConfigForm in 'VGenConfigForm.pas' {GenConfigForm},
  CCriptografiaCutre in '..\CCriptografiaCutre.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Generaci�n de archivos de configuraci�n';
  Application.CreateForm(TGenConfigForm, GenConfigForm);
  Application.Run;
end.
