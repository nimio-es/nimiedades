unit VOpDivRecType04Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VOpDivRecType03Form, ToolEdit, CurrEdit, StdCtrls, Mask,
  ExtCtrls, Menus, COpDivSystemRecord, Buttons;

type
  TOpDivRecType04Form = class(TOpDivRecType03Form)
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType04Form: TOpDivRecType04Form;

implementation

{$R *.dfm}

//*******************
// MÉTODOS PROTEGIDOS
//*******************

  procedure TOpDivRecType04Form.onGeneralChange( SystemRecord: TOpDivSystemRecord);
  begin
    inherited ;
    
    RefInicialLabel.Enabled := TRUE;
    RefInicialEdit.Enabled  := TRUE;
  end;

end.
