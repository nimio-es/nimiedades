unit VSelRecSoporteForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RXSpin, StdCtrls, Mask, ToolEdit, ComCtrls, ExtCtrls;

type
  TSelRecSoporteForm = class(TForm)
    Label2: TLabel;
    FechaSoporteEdit: TDateEdit;
    soportesListView: TListView;
    Panel2: TPanel;
    Panel1: TPanel;
    newButton: TButton;
    modifyButton: TButton;
    delSoporteButton: TButton;
    genSopButton: TButton;
    TerminarBtn: TButton;
    StatusBar1: TStatusBar;
    vinculadosListView: TListView;
    prnSopButton: TButton;
    procedure TerminarBtnClick(Sender: TObject);
    procedure FechaSoporteEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure soportesListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
  protected
    FOnChangeFechaSoporte: TNotifyEvent;
    FOnChangeSelected: TNotifyEvent;

    procedure changeFechaSoporte;
    procedure changeSelectedSoporte;

    procedure setFechaSoporte( aDate: TDateTime );
    function  getFechaSoporte: TDateTime;
    procedure setOnChangeFechaSoporte( aEventHandler: TNotifyEvent );
  public
    property FechaSoporte: TDateTime read getFechaSoporte write setFechaSoporte;
    property OnChangeFechaSoporte: TNotifyEvent read FOnChangeFechaSoporte write setOnChangeFechaSoporte;
    property OnChangeSelected: TNotifyEvent read FOnChangeSelected write FOnChangeSelected;
  end;

implementation

{$R *.dfm}

(*****
  MÉTODOS PRIVADOS
 *****)

  procedure TSelRecSoporteForm.changeFechaSoporte;
  begin
    if assigned( FOnChangeFechaSoporte ) then
      FOnChangeFechaSoporte( Self );
  end;

  procedure TSelRecSoporteForm.changeSelectedSoporte;
  begin
    if assigned( FOnChangeSelected ) then
      FOnChangeSelected( self );
  end;

  //**** soporte a las propiedades ****
  procedure TSelRecSoporteForm.setFechaSoporte( aDate: TDateTime );
  begin
    FechaSoporteEdit.Date := aDate;
    changeFechaSoporte();
  end;

  function TSelRecSoporteForm.getFechaSoporte: TDateTime;
  begin
    Result := FechaSoporteEdit.Date;
  end;

  procedure TSelRecSoporteForm.setOnChangeFechaSoporte( aEventHandler: TNotifyEvent );
  begin
    FOnChangeFechaSoporte := aEventHandler ;
    changeFechaSoporte();
  end;

  (*********
    EVENTOS
   *********)

procedure TSelRecSoporteForm.FormCreate(Sender: TObject);
begin
  FOnChangeFechaSoporte := nil;
  FOnChangeSelected := nil;
end;

procedure TSelRecSoporteForm.FechaSoporteEditChange(Sender: TObject);
begin
  changeFechaSoporte();
end;

procedure TSelRecSoporteForm.TerminarBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSelRecSoporteForm.soportesListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
//  modifyButton.Enabled := Selected; (por el momento no se puede modificar)
  delSoporteButton.Enabled := Selected;
  genSopButton.Enabled := Selected;
  prnSopButton.Enabled := Selected;
  changeSelectedSoporte();
end;

end.
