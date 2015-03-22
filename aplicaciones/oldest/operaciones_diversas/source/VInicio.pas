unit VInicio;

(********************************************************************************
 *                                                                              *
 * FECHA: julio-2001                                                            *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                   *
 * DESCRIPCIÓN:                                                                 *
 *     Conjunto de clases encargadas de gestionar el menú y mostrarlo al usua-  *
 * rio. Las opciones se muestran de diversas formas para que sea el usuario el  *
 * que decida la forma en que hacerlo.                                          *
 *                                                                              *
 * FECHA: 14-05-2002                                                            *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                   *
 * DESCRIPCIÓN:                                                                 *
 *     Se cambian las opciones de "Varios" desde los números 8x a los 7z para   *
 * hacer hueco a las opciones de "Mantenimiento (de registros)". Se incluyen    *
 * dos opciones dentro de este nuevo grupo: 78. Mover registros viejos 79. Recu-*
 * perar registros viejos.                                                      *
 *                                                                              *
 ********************************************************************************)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, Mask, ExtCtrls,
    contnrs,
    CDBMiddleEngine,
    COpDivSystemRecord,
    COpDivRecType02,
    VOpDivRecType02Form,
    COpDivRecType03,
    VOpDivRecType03Form,
    COpDivRecType04,
    VOpDivRecType04Form,
    COpDivRecType05,
    VOpDivRecType05,
    COpDivRecType06,
    VOpDivRecType06Form,
    COpDivRecType07,
    VOpDivRecType07Form,
    COpDivRecType08,
    VOpDivRecType08Form,
    COpDivRecType09,
    VOpDivRecType09Form,
    COpDivRecType10,
    VOpDivRecType10Form,
    COpDivRecType12,
    VOpDivRecType12Form,
    COpDivRecType14,
    VOpDivRecType14Form,
    COpDivRecTypeDEV,
    VOpDivRecTypeDEVForm,
    CGenSopAgent,
    CListadosAgent;

type
  // definiciones adelantadas
  TODTextMenu = class;
  TODTextMenuItem = class;
  TODTextMenuActiveItemQuery   = procedure ( var isActive: boolean; idValue: String )of object;
  TODTextMenuActiveItemExecute = procedure ( idValue: String ) of object;

  //***********************************
  TODTextMenu = class( TObject )
  //***********************************
    protected
      FOwner: TComponent;
      FCaption: String;
      FWidth: Word;
      FAsociatedLabel: TLabel;
      FItems: TObjectList;

      procedure setCaption( const ACaption: String );
      procedure setWidth( aWidth: Word );

    public

      property Caption: String read FCaption write setCaption;
      property Width: Word read FWidth write setWidth;

      constructor Create( AOwner: TComponent ); virtual;
      destructor Destroy; override;

      procedure Hide;
      procedure AddItem( AMenuItem: TODTextMenuItem );
      procedure DrawIt( var Left, Top: Word; RigthStep, DownStep, TopMargin, BottomMargin: word );
      procedure Execute( const CodigoOp: String );
  end;

  //***********************************
  TODTextMenuItem = class( TObject )
  //***********************************
    protected
      FOwner: TComponent;
      FIdValue: String;
      FCodigoOp: String;  // código con el que responde a la operación
      FCaption : String;
      FWidth: Word;
      FAsociatedCodeLabel: TLabel;
      FAsociatedLabel: TLabel;

      FEsActivableNotify: TODTextMenuActiveItemQuery;
      FExecuteActionNotify: TODTextMenuActiveItemExecute;

      procedure setCodigoOp( const ACodigoOp: String );
      procedure setCaption( const ACaption: String );
      procedure setWidth( AWidth: Word );
      function  isActivable: boolean;

      procedure onClickMouse( Sender: Tobject );
//      procedure onMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    public

      property CodigoOp: String read FCodigoOp write setCodigoOp ;
      property Caption : String read FCaption  write setCaption;
      property Width: Word read FWidth write setWidth;
      property EsActivableNotify: TODTextMenuActiveItemQuery read FEsActivableNotify write FEsActivableNotify;
      property EsActivable: boolean read isActivable;
      property ExecuteActionNotify: TODTextMenuActiveItemExecute read FExecuteActionNotify write FExecuteActionNotify;

      constructor Create( AOwner: TComponent; aIDValue: String ); virtual;
      destructor Destroy; override;

      procedure Hide;
      procedure DrawIt( Left, Top: word );
      procedure ExecuteIt;
  end;

  //***********************************
  TInicio = class(TForm)
  //***********************************
    MainMenu1: TMainMenu;
    RegistrosMenu: TMenuItem;
    NuevoSubMenu: TMenuItem;
    LeerItemMenu: TMenuItem;
    Tipo05ItemMenu: TMenuItem;
    Tipo06ItemMenu: TMenuItem;
    Tipo07ItemMenu: TMenuItem;
    Tipo08ItemMenu: TMenuItem;
    Tipo09ItemMenu: TMenuItem;
    Tipo10ItemMenu: TMenuItem;
    Tipo11ItemMenu: TMenuItem;
    Tipo12ItemMenu: TMenuItem;
    Tipo13ItemMenu: TMenuItem;
    Tipo14ItemMenu: TMenuItem;
    N1: TMenuItem;
    SalirItemMenu: TMenuItem;
    statusBar: TStatusBar;
    Utiles1: TMenuItem;
    configMenuItem: TMenuItem;
    N2: TMenuItem;
    listMenuItem: TMenuItem;
    SoporteMenuItem: TMenuItem;
    Tipo02ItemMenu: TMenuItem;
    Tipo03ItemMenu: TMenuItem;
    Tipo01ItemMenu: TMenuItem;
    Tipo04ItemMenu: TMenuItem;
    SepDevolucionesItemMenu: TMenuItem;
    DevolucionesItemMenu: TMenuItem;
    EliminarItem: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    OpcionEdit: TMaskEdit;
    N3: TMenuItem;
    mantenimientoMenuItem: TMenuItem;
    moverRegistrosViejosMenuItem: TMenuItem;
    RecuperarRegistrosMovidosMenuItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure SalirItemMenuClick(Sender: TObject);
    procedure LeerItemMenuClick(Sender: TObject);
    procedure configMenuItemClick(Sender: TObject);
    procedure Tipo05ItemMenuClick(Sender: TObject);
    procedure Tipo06ItemMenuClick(Sender: TObject);
    procedure Tipo07ItemMenuClick(Sender: TObject);
    procedure Tipo08ItemMenuClick(Sender: TObject);
    procedure Tipo09ItemMenuClick(Sender: TObject);
    procedure Tipo10ItemMenuClick(Sender: TObject);
    procedure Tipo12ItemMenuClick(Sender: TObject);
    procedure Tipo14ItemMenuClick(Sender: TObject);
    procedure Tipo02ItemMenuClick(Sender: TObject);
    procedure EliminarItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OpcionEditKeyPress(Sender: TObject; var Key: Char);
    procedure Tipo03ItemMenuClick(Sender: TObject);
    procedure SoporteMenuItemClick(Sender: TObject);
    procedure DevolucionesItemMenuClick(Sender: TObject);
    procedure listMenuItemClick(Sender: TObject);
    procedure moverRegistrosViejosMenuItemClick(Sender: TObject);
  private
    (*****
      MÉTODOS AUXLIARES
     *****)
    FTextMenu: TObjectList;

    procedure asociatedMenuItemActivable( var isActive: boolean; idValue: String );
    procedure asociatedMenuItemExecute( idValue: String );
    procedure CreateTextMenu;
    procedure DrawTextMenu;
    procedure ExecuteMenuOption( const Option: String);
    procedure showContextData;
    procedure RedirigirEdicion( dataRecord: TOpDivSystemRecord );

    procedure OpDivRec02( dataRecord: TOpDivRecType02 );
    procedure OpDivRec03( dataRecord: TOpDivRecType03 );
    procedure OpDivRec04( dataRecord: TOpDivRecType04 );
    procedure OpDivRec05( dataRecord: TOpDivRecType05 );
    procedure OpDivRec06( dataRecord: TOpDivRecType06 );
    procedure OpDivRec07( dataRecord: TOpDivRecType07 );
    procedure OpDivRec08( dataRecord: TOpDivRecType08 );
    procedure OpDivRec09( dataRecord: TOpDivRecType09 );
    procedure OpDivRec10( dataRecord: TOpDivRecType10 );
    procedure OpDivRec12( dataRecord: TOpDivRecType12 );
    procedure OpDivRec14( dataRecord: TOpDivRecType14 );
    procedure OpDivRecDEV( dataRecord: TOpDivRecTypeDEV );
    procedure GenSoporte;
    procedure GenListados;

    // 14.05.02 - métodos para soportar las nuevas opcines de mantenimiento
    procedure MantMoveRegs;
    procedure MantRecRegs;

  public
    { Public declarations }
  end;

var
  Inicio: TInicio;

implementation

{$R *.DFM}

  uses
    rxStrUtils,
    CCriptografiaCutre,  (* TCutreCriptoEngine *)
    UGlobalData,         (* los datos globales para toda la aplicación *)
    VOpenRecord,         (* TOpenRecord *)
    CMoveOldFilesAgent;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CLASS: TODTextMenu
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  (*****
    MÉTODOS PROTEGIDOS
   *****)

   procedure TODTextMenu.setCaption( const ACaption: String );
   begin
     FCaption := ACaption;
     FAsociatedLabel.Caption := FCaption;
   end;

   procedure TODTextMenu.setWidth( AWidth: Word );
   begin
     FWidth := AWidth;
     FAsociatedLabel.Width := AWidth;
   end;

  (*****
    MÉTODOS PUBLICOS
   *****)
   constructor TODTextMenu.Create( AOwner: TComponent );
   begin
     inherited Create();
     FOwner   := AOwner;
     FCaption := 'Menu...';
     FWidth   := 185;
     FAsociatedLabel := TLabel.Create( AOwner );
     FAsociatedLabel.AutoSize := false;
     FAsociatedLabel.Width := FWidth;
     FAsociatedLabel.Height := 13;
     FAsociatedLabel.Visible := false;
     FAsociatedLabel.Parent  := TWinControl( AOwner );
     FAsociatedLabel.Caption := FCaption;
     FAsociatedLabel.Color   := clNavy;
     FAsociatedLabel.Font.Color := clAqua;
     FAsociatedLabel.Font.Style := [fsBold];

     FItems := TObjectList.Create();
   end;

   destructor  TODTextMenu.Destroy;
   begin
     FAsociatedLabel.Free;
     FItems.Free();
     inherited;
   end;

   procedure TODTextMenu.Hide;
   var
     nItem: Integer;
   begin
     FAsociatedLabel.Hide();
     for nItem := 0 to FItems.Count-1 do
       TODTextMenuItem( FItems[ nItem ] ).Hide();
   end;

   procedure TODTextMenu.AddItem( AMenuItem: TODTextMenuItem );
   begin
     FItems.Add( AMenuItem );
   end;

   procedure TODTextMenu.DrawIt( var Left, Top: Word; RigthStep, DownStep, TopMargin, BottomMargin: word );
   var
     dibujable: boolean;
     nItem: integer;
     previsibleBottom: Word;
   begin
     dibujable := false;
     previsibleBottom := Top + DownStep + 2;
     for nItem := 0 to FItems.Count-1 do
     begin
       if TODTextMenuItem( FItems[nItem] ).EsActivable then
       begin
         dibujable := true;
         previsibleBottom := previsibleBottom + DownStep;
       end;
     end;
     // ¿hay almenos una opción activa
     if dibujable then
     begin
        if ( PrevisibleBottom > BottomMargin ) then
        begin
          if ( BottomMargin - TopMargin ) > ( PrevisibleBottom - Top ) then
          begin
            Left := RigthStep;
            Top  := TopMargin;
          end
        end;
        // se dibuja la cabecera...
        FAsociatedLabel.Left := Left;
        FAsociatedLabel.Top  := Top;
        FAsociatedLabel.Show();
        Top := Top + DownStep + 2;
        // se dibujan el resto de las opciones
        for nItem := 0 to FItems.Count-1 do
          if TODTextMenuItem( FITems[ nItem ] ).EsActivable then
          begin
            TODTextMenuItem( FItems[nItem] ).DrawIt( Left, Top );
            Top := Top + DownStep;
          end;
     end;
   end;

   procedure TODTextMenu.Execute( const CodigoOp: String );
   var
     nItem: integer;
   begin
     for nItem := 0 to FItems.Count-1 do
       if ( TODTextMenuItem( FItems[ nItem ] ).CodigoOp = CodigoOp ) and TODTextMenuItem( FItems[ nItem ] ).EsActivable then
       begin
         TODTextMenuItem( FItems[ nItem ] ).ExecuteIt();
         break;
       end;
   end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CLASS: TODTextMenuItem
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  (*****
    MÉTODOS PROTEGIDOS
   *****)

   procedure TODTextMenuItem.setCodigoOp( const ACodigoOp: String );
   begin
     FCodigoOp := ACodigoOp;
     FAsociatedCodeLabel.Caption := FCodigoOp + '.';
     FAsociatedLabel.Width := FWidth - ( FAsociatedCodeLabel.Width + 1 );
   end;

   procedure TODTextMenuItem.setCaption( const ACaption: String );
   begin
     FCaption := ACaption;
     FAsociatedLabel.Caption := FCaption;
   end;

   procedure TODTextMenuItem.setWidth( AWidth: Word );
   begin
     FWidth := AWidth;
     FAsociatedLabel.Width := FWidth - ( FAsociatedCodeLabel.Width + 1 );
   end;

   function  TODTextMenuItem.isActivable: boolean;
   begin
     Result := true;
     // comprobamos si tiene activo el evento que require controlar su actividad
     if assigned( FEsActivableNotify ) then
       FEsActivableNotify( Result, FIdValue );
     Result := Result and assigned( FExecuteActionNotify );  // pero debe tener asociada una rutina de ejecución
   end;

   procedure TODTextMenuItem.onClickMouse( Sender: TObject );
   begin
     if assigned( FExecuteActionNotify ) then
       FExecuteActionNotify( FIDValue );
   end;

(*   procedure TODTextMenuItem.onMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
   begin
     FAsociatedCodeLabel.Font.Color := clWhite;
     FAsociatedLabel.Font.Color := clWhite;
   end;
*)
  (*****
    MÉTODOS PÚBLICOS
   *****)

  constructor TODTextMenuItem.Create( AOwner: TComponent; aIDValue: String ); 
  begin
    inherited create();
    FOwner    := AOwner;
    FIdValue  := aIDValue;
    FCodigoOp := 'XX';
    FCaption  := 'Opcion';
    FWidth    := 185;
    // la etiqueta del código
    FAsociatedCodeLabel := TLabel.Create( AOwner );
    FAsociatedCodeLabel.Visible := false;
    FAsociatedCodeLabel.Parent := TWinControl( AOwner );
    FAsociatedCodeLabel.Caption := FCodigoOp;
    FAsociatedCodeLabel.Font.Color := clRed;
    FAsociatedCodeLabel.Font.Style := [fsBold];
    FAsociatedCodeLabel.Height := 13;
    FAsociatedCodeLabel.Cursor := crHandPoint;
    FAsociatedCodeLabel.OnClick := onClickMouse;
//    FAsociatedCodeLabel.OnMouseMove := onMouseMove;
    // la etiqueta de descripción
    FAsociatedLabel := TLabel.Create( AOwner );
    FAsociatedLabel.Visible := false;
    FAsociatedLabel.Parent := TWinControl( AOwner );
    FAsociatedLabel.AutoSize := false;
    FAsociatedLabel.Width := FWidth - ( FAsociatedCodeLabel.Width + 1 );
    FAsociatedLabel.Height := 13;
    FAsociatedLabel.Caption := FCaption;
    FAsociatedLabel.Font.Color := $00804000;
    FAsociatedLabel.Cursor := crHandPoint;
    FAsociatedLabel.OnClick := onClickMouse;
//    FAsociatedLabel.OnMouseMove := onMouseMove;
    // las rutinas de comprobación y ejecución
    FEsActivableNotify := nil;
    FExecuteActionNotify := nil;

  end;

  destructor TODTextMenuItem.Destroy;
  begin
    FAsociatedCodeLabel.Free();
    FAsociatedLabel.Free();
    inherited Destroy();
  end;

  procedure TODTextMenuItem.Hide;
  begin
    FAsociatedCodeLabel.Hide();
    FAsociatedLabel.Hide();
  end;

  procedure TODTextMenuItem.DrawIt( Left, Top: word );
  begin
    FAsociatedCodeLabel.Left := Left;
    FAsociatedCodeLabel.Top  := Top;
    FAsociatedLabel.Left     := Left + FAsociatedCodeLabel.Width + 1;
    FAsociatedLabel.Top      := Top;
    FAsociatedCodeLabel.Show();
    FAsociatedLabel.Show();
  end;

  procedure TODTextMenuItem.ExecuteIt;
  begin
    if assigned( FExecuteActionNotify ) then
      FExecuteActionNotify( FIdValue );
  end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CLASS: TInicio
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  (*****
    MÉTODOS PRIVADOS AUXILIARES
   *****)
  procedure TInicio.CreateTextMenu;
  var
    menu: TODTextMenu;
    item: TODTextMenuItem;
  begin
    // creando los datos...
    // el de los tipos...
    menu := TODTextMenu.Create( Self );  // se dibujará en la ventana
    menu.Caption := ' Tipos...';
    // tipo 01
    item := TODTextMenuItem.Create( Self, kCodeOpTipo01 );
    item.CodigoOp := '01';
    item.Caption  := 'Efectos';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 02
    item := TODTextMenuItem.Create( Self, kCodeOpTipo02 );
    item.CodigoOp := '02';
    item.Caption  := 'Cheques';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 03
    item := TODTextMenuItem.Create( Self, kCodeOpTipo03 );
    item.CodigoOp := '03';
    item.Caption  := 'Regulariza. Sistema Interc. (Doc.)';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 04
    item := TODTextMenuItem.Create( Self, kCodeOpTipo04 );
    item.CodigoOp := '04';
    item.Caption  := 'Regulariza. Sistema Interc. (No doc.)';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 05
    item := TODTextMenuItem.Create( Self, kCodeOpTipo05 );
    item.CodigoOp := '05';
    item.Caption  := 'Actas protesto';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 06
    item := TODTextMenuItem.Create( Self, kCodeOpTipo06 );
    item.CodigoOp := '06';
    item.Caption  := 'Comisiones y gastos créditos';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 07
    item := TODTextMenuItem.Create( Self, kCodeOpTipo07 );
    item.CodigoOp := '07';
    item.Caption  := 'Pagos en notaría';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 08
    item := TODTextMenuItem.Create( Self, kCodeOpTipo08 );
    item.CodigoOp := '08';
    item.Caption  := 'Cesiones de efectivo';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 09
    item := TODTextMenuItem.Create( Self, kCodeOpTipo09 );
    item.CodigoOp := '09';
    item.Caption  := 'Compraventa moneda ext.';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 10
    item := TODTextMenuItem.Create( Self, kCodeOpTipo10 );
    item.CodigoOp := '10';
    item.Caption  := 'Reembolso';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 11
    item := TODTextMenuItem.Create( Self, kCodeOpTipo11 );
    item.CodigoOp := '11';
    item.Caption  := 'Regula. desfases tesoreros';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 12
    item := TODTextMenuItem.Create( Self, kCodeOpTipo12 );
    item.CodigoOp := '12';
    item.Caption  := 'Comisiones';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 13
    item := TODTextMenuItem.Create( Self, kCodeOpTipo13 );
    item.CodigoOp := '13';
    item.Caption  := 'Recupera. comisiones';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // tipo 14
    item := TODTextMenuItem.Create( Self, kCodeOpTipo14 );
    item.CodigoOp := '14';
    item.Caption  := 'Otras operaciones';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // Devolucion
    item := TODTextMenuItem.Create( Self, kCodeOpTipoDev );
    item.CodigoOp := '30';
    item.Caption  := 'Devoluciones';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );

    FTextMenu.Add( menu );


    // 14.05.02 - se cambian los números del grupo de opciones varias para hacer
    //            "hueco" al grupo "Mantenimiento".

    // el de varios...
    menu := TODTextMenu.Create( Self );  // se dibujará en la ventana
    menu.Caption := ' Varios...';

    // leer
    item := TODTextMenuItem.Create( Self, 'LEER' );
    item.CodigoOp := '71';
    item.Caption  := 'Leer';
    item.EsActivableNotify := nil;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // eliminar
    item := TODTextMenuItem.Create( Self, 'ELIMINAR' );
    item.CodigoOp := '73';
    item.Caption  := 'Eliminar';
    item.EsActivableNotify := nil;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // listados
    item := TODTextMenuItem.Create( Self, kCodeOpListado );
    item.CodigoOp := '78';
    item.Caption  := 'Listados';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // soporte
    item := TODTextMenuItem.Create( Self, kCodeOpSoporte );
    item.CodigoOp := '79';
    item.Caption  := 'Soportes';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );

    FTextMenu.Add( menu );

    // 14.05.02 - Se añade un nuevo grupo de opciones: "Mantenimiento"

    menu := TODTextMenu.Create( self );
    menu.Caption := 'Mantenimiento...';
    // mover registros viejos
    item := TODTextMenuItem.Create( Self, 'MOVREGS' );
    item.CodigoOp := '88';
    item.Caption := 'Mover registros viejos';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.addItem( item );
    // recuperar registros...
    item := TODTextMenuItem.Create( Self, 'RECREGS' );
    item.CodigoOp := '89';
    item.Caption := 'Recuperar registros';
    item.EsActivableNotify := asociatedMenuItemActivable;
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.addItem( item );

    FTextMenu.Add( menu );

    // el de configuración...
    menu := TODTextMenu.Create( Self );  // se dibujará en la ventana
    menu.Caption := ' Configuración...';
    // configuración
    item := TODTextMenuItem.Create( Self, 'CONFIGURA' );
    item.CodigoOp := '90';
    item.Caption  := 'Configuración';
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );
    // salir
    item := TODTextMenuItem.Create( Self, 'SALIR' );
    item.CodigoOp := '99';
    item.Caption  := 'Salir';
    item.ExecuteActionNotify := asociatedMenuItemExecute;
    menu.AddItem( item );

    FTextMenu.Add( menu );

  end;

  procedure TInicio.DrawTextMenu;
  const
    topIni = 12;
    leftIni = 12;
    rigthStep = 185 + 24;
    downStep  = 16;
  var
    Top, Left: Word;
    nMenu: integer;
  begin
    for nMenu := 0 to FTextMenu.Count-1 do
      TODTextMenu( FTextmenu[ nMenu ] ).Hide();
    Top  := topIni;
    Left := leftIni;
    for nMenu := 0 to FTextMenu.Count-1 do
      TODTextMenu( FTextMenu[ nMenu ] ).DrawIt( Left, Top, rigthStep, downStep, topIni, self.Height - 120 );
  end;

  procedure TInicio.ExecuteMenuOption( const option: string );
  var
    nMenu: word;
  begin
    for nMenu := 0 to FTextMenu.Count-1 do
      TODTextMenu( FTextMenu[ nMenu ] ).Execute( option );
  end;

  // 14.05.02 - se han incluído dos opciones que dependen de los soportes pero que
  //            no pueden usar el mismo Id.
  procedure TInicio.asociatedMenuItemActivable( var isActive: boolean; idValue: String );
  begin
    if (idValue = 'MOVREGS') or (idValue = 'RECREGS') then
      isActive := testDo( kCodeOpSoporte )
    else
      isActive := testDo( idValue );
  end;

  procedure TInicio.asociatedMenuItemExecute( idValue: String );
  begin

    if idValue = kCodeOpTipo02 then OpDivRec02( TOpDivRectype02.Create() )
    else if idValue = kCodeOpTipo03 then OpDivRec03( TOpDivRectype03.Create() )
    else if idValue = kCodeOpTipo04 then OpDivRec04( TOpDivRectype04.Create() )
    else if idValue = kCodeOpTipo05 then OpDivRec05( TOpDivRectype05.Create() )
    else if idValue = kCodeOpTipo06 then OpDivRec06( TOpDivRectype06.Create() )
    else if idValue = kCodeOpTipo07 then OpDivRec07( TOpDivRectype07.Create() )
    else if idValue = kCodeOpTipo08 then OpDivRec08( TOpDivRectype08.Create() )
    else if idValue = kCodeOpTipo09 then OpDivRec09( TOpDivRectype09.Create() )
    else if idValue = kCodeOpTipo10 then OpDivRec10( TOpDivRectype10.Create() )
//    else if idValue = kCodeOpTipo11 then OpDivRec11( TOpDivRectype11.Create() )
    else if idValue = kCodeOpTipo12 then OpDivRec12( TOpDivRectype12.Create() )
//    else if idValue = kCodeOpTipo13 then OpDivRec13( TOpDivRectype13.Create() )
    else if idValue = kCodeOpTipo14 then OpDivRec14( TOpDivRectype14.Create() )
    else if idValue = kCodeOpTipoDev then OpDivRecDEV( TOpDivRecTypeDEV.Create() )
    else if idValue = kCodeOpSoporte then GenSoporte()
    else if idValue = kCodeOpListado then GenListados()
    else if idValue = 'CONFIGURA'  then begin configure(); showContextData ; end
    else if idValue = 'LEER' then
    begin
      with TOpenRecord.Create( Self ) do
        try
          if Execute(TRUE) then
          begin
            RedirigirEdicion( TOpDivSystemRecord( TheDBMiddleEngine.readRecord( RecordSelected ) ) );
          end; // -- if (OpenrRecord).Execute
        finally
          Free;
        end;
    end
    else if idValue = 'ELIMINAR' then
    begin
      with TOpenRecord.Create( Self ) do
        try
          Caption := 'Eliminar...';
          if Execute(FALSE) then
          begin
            TheDBMiddleEngine.deleteRecord( RecordSelected ) ;
          end; // -- if (OpenrRecord).Execute
        finally
          Free;
        end;
    end
    // 14.05.02 - se añaden las opciones para el mantenimiento de los regisotrs
    else if idValue = 'MOVREGS' then
      MantMoveRegs()
    else if idValue = 'RECREGS' then
      MantRecRegs()
    else if idValue = 'SALIR' then
      Self.Close();

  end;

  procedure TInicio.showContextData;
  begin
    // se indica en la barra de estado algunos datos de la estación
    statusBar.Panels[0].Text := ' ID: ' + getStationID;
    statusBar.Panels[1].Text := ' Leer: ' + getCanRead;

    // se indican en el menú las operaciones soportadas
    Tipo01ItemMenu.Visible := testDo( kCodeOpTipo01 );
    Tipo02ItemMenu.Visible := testDo( kCodeOpTipo02 );
    Tipo03ItemMenu.Visible := testDo( kCodeOpTipo03 );
    Tipo04ItemMenu.Visible := testDo( kCodeOpTipo04 );
    Tipo05ItemMenu.Visible := testDo( kCodeOpTipo05 );
    Tipo06ItemMenu.Visible := testDo( kCodeOpTipo06 );
    Tipo07ItemMenu.Visible := testDo( kCodeOpTipo07 );
    Tipo08ItemMenu.Visible := testDo( kCodeOpTipo08 );
    Tipo09ItemMenu.Visible := testDo( kCodeOpTipo09 );
    Tipo10ItemMenu.Visible := testDo( kCodeOpTipo10 );
    Tipo11ItemMenu.Visible := testDo( kCodeOpTipo11 );
    Tipo12ItemMenu.Visible := testDo( kCodeOpTipo12 );
    Tipo13ItemMenu.Visible := testDo( kCodeOpTipo13 );
    Tipo14ItemMenu.Visible := testDo( kCodeOpTipo14 );
    SepDevolucionesItemMenu.Visible := testDo( kCodeOpTipoDev );
    DevolucionesItemMenu.Visible := testDo( kCodeOpTipoDev );
    listMenuItem.Visible   := testDo( kCodeOpListado );
    SoporteMenuItem.Visible := testDo( kCodeOpSoporte );

    // 14.05.02 - se ha incluído un submenú "mantenimiento" que se activará si el usuario tiene permiso para
    //            manejar los soportes (ya que los registros que se mueven se basan en la clusterización por
    //            soportes).
    mantenimientoMenuItem.Visible := testDo( kCodeOpSoporte );

    DrawTextMenu();

  end; // -- TInicio.showContextData

  procedure TInicio.RedirigirEdicion( dataRecord: TOpDivSystemRecord );
  begin

    // 13.05.02 - indicamos que el terminal está trabajando con un registro anterior
    TheDBMiddleEngine.lockTerminal( getStationID(), dataRecord.RecType );

    try
      if dataRecord.RecType = '01' then
      else if dataRecord.RecType = '02' then
        OpDivRec02( TOpDivRecType02( dataRecord ) )
      else if dataRecord.RecType = '03' then
        OpDivRec03( TOpDivRecType03( dataRecord ) )
      else if dataRecord.RecType = '04' then
        OpDivRec04( TOpDivRecType04( dataRecord ) )
      else if dataRecord.RecType = '05' then
        OpDivRec05( TopDivRecType05( dataRecord ) )
      else if dataRecord.RecType = '06' then
        OpDivRec06( TopDivRecType06( dataRecord ) )
      else if dataRecord.RecType = '07' then
        OpDivRec07( TopDivRecType07( dataRecord ) )
      else if dataRecord.RecType = '08' then
        OpDivRec08( TopDivRecType08( dataRecord ) )
      else if dataRecord.RecType = '09' then
        OpDivRec09( TopDivRecType09( dataRecord ) )
      else if dataRecord.RecType = '10' then
        OpDivRec10( TopDivRecType10( dataRecord ) )
      else if dataRecord.RecType = '11' then
      else if dataRecord.RecType = '12' then
        OpDivRec12( TopDivRecType12( dataRecord ) )
      else if dataRecord.RecType = '13' then
      else if dataRecord.RecType = '14' then
        OpDivRec14( TopDivRecType14( dataRecord ) )
      else if dataRecord.RecType = 'DEV' then
        OpDivRecDEV( TOpDivRecTypeDEV( dataRecord ) );

    // 13.05.02 - debemos asegurarno que se "desbloquea" el terminal
    finally
      TheDBMiddleEngine.unlockTerminal( getStationID() );
    end

  end;

  procedure TInicio.OpDivRec02( dataRecord: TOpDivRecType02 );
  begin
  with TOpDivRecType02Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec03( dataRecord: TOpDivRecType03 );
  begin
    with TOpDivRecType03Form.Create( Self ) do
      try
        SystemRecord := dataRecord;
        showModal();
      finally
        free();
      end;
  end;

  procedure TInicio.OpDivRec04( dataRecord: TOpDivRecType04 );
  begin
    with TOpDivRecType04Form.Create( Self ) do
      try
        SystemRecord := dataRecord;
        showModal();
      finally
        free();
      end;
  end;

  procedure TInicio.OpDivRec05( dataRecord: TOpDivRecType05 );
  begin
  with TOpDivRecType05Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec06( dataRecord: TOpDivRecType06 );
  begin
  with TOpDivRecType06Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec07( dataRecord: TOpDivRecType07 );
  begin
  with TOpDivRecType07Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec08( dataRecord: TOpDivRecType08 );
  begin
  with TOpDivRecType08Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec09( dataRecord: TOpDivRecType09 );
  begin
  with TOpDivRecType09Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec10( dataRecord: TOpDivRecType10 );
  begin
  with TOpDivRecType10Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec12( dataRecord: TOpDivRecType12 );
  begin
  with TOpDivRecType12Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRec14( dataRecord: TOpDivRecType14 );
  begin
  with TOpDivRecType14Form.Create( self ) do
    try
      SystemRecord := dataRecord;
      ShowModal;
    finally
      Free;
    end;
  end;

  procedure TInicio.OpDivRecDEV( dataRecord: TOpDivRecTypeDEV );
  begin
    with TOpDivRecTypeDEVForm.Create( self ) do
      try
        SystemRecord := dataRecord;
        ShowModal();
      finally
        Free();
      end;
  end;

  procedure TInicio.GenSoporte;
  var
    GenSopAgent: TGenSopAgent;
  begin
    GenSopAgent := TGenSopAgent.Create();
    GenSopAgent.Execute();
    GenSopAgent.Free();
  end;

  procedure TInicio.GenListados;
  begin
    with TListadosAgent.Create() do
      try
        Execute();
      finally
        Free();
      end
  end;


  // 14.05.02 - método para el soporte de las opciones de mantenimiento
  procedure TInicio.MantMoveRegs;
  begin
    with TMoveOldFilesAgent.Create() do
      try
        Execute()
      finally
        Free()
      end
  end;

  procedure TInicio.MantRecRegs;
  begin
  end;


(**************
 EVENTOS
 **************)
procedure TInicio.FormCreate(Sender: TObject);
begin
  FTextMenu := TObjectList.Create();
  CreateTextMenu();
  showContextData;
end; // -- OnCreate

procedure TInicio.FormDestroy(Sender: TObject);
begin
  FTextMenu.Free();
end;

procedure TInicio.SalirItemMenuClick(Sender: TObject);
begin
  Self.Close ;
end;

procedure TInicio.LeerItemMenuClick(Sender: TObject);
begin
  with TOpenRecord.Create( Self ) do
    try
      if Execute(TRUE) then
      begin
        RedirigirEdicion( TOpDivSystemRecord( TheDBMiddleEngine.readRecord( RecordSelected ) ) );
      end; // -- if (OpenrRecord).Execute
    finally
      Free;
    end;
end;

procedure TInicio.configMenuItemClick(Sender: TObject);
begin
  // se procede a lanzar la configuración del sistema
  configure;
  // después de la nueva configuración se procede a reevaluar los datos que se muestran
  showContextData ;
end;

procedure TInicio.Tipo02ItemMenuClick(Sender: TObject);
begin
  OpDivRec02( TOpDivRectype02.Create() );
end;

procedure TInicio.Tipo03ItemMenuClick(Sender: TObject);
begin
  OpDivRec03( TOpDivRecType03.Create() );
end;

procedure TInicio.Tipo05ItemMenuClick(Sender: TObject);
begin
  // se crea un formulario de tipo 5 y se le pasa un objeto nuevo recién creado para que trabaje con él
  OpDivRec05( TOpDivrecType05.Create() );
end;

procedure TInicio.Tipo06ItemMenuClick(Sender: TObject);
begin
  // se crea un formulario de tipo 6 y se le pasa un objeto nuevo recién creado para que trabaje con él
  OpDivRec06( TOpDivrecType06.Create() );
end;

procedure TInicio.Tipo07ItemMenuClick(Sender: TObject);
begin
  OpDivRec07( TOpDivrecType07.Create() );
end;

procedure TInicio.Tipo08ItemMenuClick(Sender: TObject);
begin
  OpDivRec08( TOpDivrecType08.Create() );
end;

procedure TInicio.Tipo09ItemMenuClick(Sender: TObject);
begin
  OpDivRec09( TOpDivrecType09.Create() );
end;

procedure TInicio.Tipo10ItemMenuClick(Sender: TObject);
begin
  OpDivRec10( TOpDivrecType10.Create() );
end;

procedure TInicio.Tipo12ItemMenuClick(Sender: TObject);
begin
  OpDivRec12( TOpDivrecType12.Create() );
end;

procedure TInicio.Tipo14ItemMenuClick(Sender: TObject);
begin
  OpDivRec14( TOpDivrecType14.Create() );
end;

procedure TInicio.DevolucionesItemMenuClick(Sender: TObject);
begin
  OpDivRecDEV( TOpDivRecTypeDEV.Create() );
end;

procedure TInicio.EliminarItemClick(Sender: TObject);
var
  selRecord: TOpenRecord;
begin
  selRecord := TOpenRecord.Create(Self);

  try
    selRecord.Caption := 'Eliminar...';
//    selRecord.panelFiltro.Hide();
//    selRecord.panelFiltro.Height := 0;
//    selRecord.mostrarVinculadosCheckBox.Enabled := FALSE;

    if selRecord.Execute(FALSE) then
      TheDBMiddleEngine.deleteRecord( selRecord.RecordSelected );
  finally
    selRecord.Free();
  end;

end;

procedure TInicio.FormResize(Sender: TObject);
begin
  DrawTextMenu();
  Self.Update();
  Self.Refresh();
end;

procedure TInicio.OpcionEditKeyPress(Sender: TObject; var Key: Char);
var
  opcion: String[2];
begin
  if Key = #13 then
  begin
    opcion := AddChar( '0', trim( OpcionEdit.Text ), 2 );
    ExecuteMenuOption( opcion );
    OpcionEdit.Text := opcion;
    OpcionEdit.SelectAll();
    key := #0;
  end;
end;

procedure TInicio.SoporteMenuItemClick(Sender: TObject);
begin
  GenSoporte();
end;

procedure TInicio.listMenuItemClick(Sender: TObject);
begin
  GenListados();
end;

procedure TInicio.moverRegistrosViejosMenuItemClick(Sender: TObject);
begin
  MantMoveRegs();
end;

end.
