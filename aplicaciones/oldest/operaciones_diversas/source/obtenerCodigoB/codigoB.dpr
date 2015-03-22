program codigoB;

uses
  Forms,
  VPrincipal in 'VPrincipal.pas' {Principal},
  CCriptografiaCutre in '..\CCriptografiaCutre.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
