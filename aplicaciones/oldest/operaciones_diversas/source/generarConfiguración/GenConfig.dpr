program GenConfig;

uses
  Forms,
  VGenConfigForm in 'VGenConfigForm.pas' {GenConfigForm},
  CCriptografiaCutre in '..\CCriptografiaCutre.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Generación de archivos de configuración';
  Application.CreateForm(TGenConfigForm, GenConfigForm);
  Application.Run;
end.
