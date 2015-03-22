unit CQueryEngine;

(*******************************************************************************
 * CLASE: TQueryEngine.                                                        * 
 * FECHA DE CREACIÓN: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *        Se encarga de realizar consultas sobre los elementos auxiliares.     *
 *                                                                             *
 * FECHA MODIFICACIÓN: 01-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *        A partir de ahora no se empleará la tabla auxiliar de código de      *
 *   devolución, ya que ciertos tipos tendrán semántica diferente. Es necesa-  *
 *   rio, por tanto, que sea la propia clase de Devoluciones quien se encargue *
 *   de gestionar los códigos posibles. Tal como sucede con otros conjuntos de *
 *   valores tipificados.                                                      *
 *******************************************************************************)

interface

  uses
    classes;

  type
    TQueryEngine = class( TObject)
      protected
        FDirData: String;
        FDivisasIso  : TStringList;
        FProvincias  : TStringList;
        FOficinasCIA : TStringList;
        FEntidades   : TStringList;
        FEntidadActiva: String;
        FOficinas    : TStringList;
        FConceptosReembolso: TStringList;

// 01.05.02 -- se prescinde de la tabla externa con los códigos de devolución
//        FConceptosDevolucion: TStringList;

        procedure ReadFileSucursales( const EntCode: String );
      public
        (* constructores y destructores *)
        constructor Create( const DirData: String); virtual;
        destructor Destroy; override;

        //:  para consultar códigos de monedas iso
        function existsDivisaISO( const ISOCode: String ): boolean;
        function getDivisaName( const ISOCode: String ): String;
        function existsProvincia( const ProvCode: String ): boolean;
        function getProvinciaName( const ProvCode: String ): String;
        function existsOfiCaja( const OfiCode: String ): boolean;
        function getOfiCajaName( const OfiCode: String ): String;
        function existsEntidad( const EntCode: String ): boolean;
        function getEntidadName( const EntCode: String ): String;
        function existsSucursal( const EntCode, OfiCode: String ): boolean;
        function getConceptoReembolso( const Codigo: String ): String;
        function existsConceptoReembolso( const Codigo: String ): Boolean;
// 01.05.02 -- se prescinde de la tabla externa de códigos de devolución
//        function getConceptoDevolucion(const Codigo: String): String;
//        function existsConceptoDevolucion(const Codigo:String): Boolean;

        // rutinas que facilitan la búsqueda de elementos
        function searchEntidad(const defValue:String): String;
    end;


  var
    theQueryEngine : TQueryEngine;

implementation

  uses
    SysUtils,
    Controls,
    Dialogs,
    VSearchRecAux;

(*******
  CONSTANTES LOCALES AL MÓDULO
 *******)
  const
    kFileISO     = 'DIVISAS.LST';
    kFileProv    = 'PROVINCIAS.LST';
    kFileOfiCaja = 'OFICAJA.LST';
    kFileEntidades = 'ENTIDADES.LST';
    kFileCodsReembolsos = 'REEMBOLSOS.LST';
// 01.05.02 -- se prescinde de la tabla externa de códigos de devolución
//    kFileCodsDevolucion = 'DEVOLUCION.LST';
    kSubdirSucursales = 'SUCURSALES\';
    kFileExtension = '.LST';

(*******
  MÉTODOS PROTEGIDOS
 *******)

  procedure TQueryEngine.ReadFileSucursales( const EntCode: String );
  const
    klErrorFileNotFound = 'El archivo de sucursales asociado a la entidad no existe en la BB.DD.';
  var
    theFileName : String;
  begin
    if FEntidadActiva <> EntCode then
    begin
      theFileName := FDirData + kSubdirSucursales + EntCode + kFileExtension;
      if not FileExists( theFileName ) then
       raise Exception.Create( klErrorFileNotFound + #13 + 'Entidad: ' + EntCode );

      FOficinas.Clear();
      FOficinas.LoadFromFile( theFileName );
      FEntidadActiva := EntCode;
    end
  end;

(*******
  MÉTODOS PÚBLICOS
 *******)

  //::: CONSTRUCTORES Y DESTRUCTORES
  constructor TQueryEngine.Create( const DirData: String );
  begin
    inherited Create;
    FDirData := DirData;

    if not FileExists( FDirData + kFileISO ) then
    begin
      MessageDlg( 'El fichero de códigos ISO de divisas no existe.' + #13 + FDirData + kFileISO, mtError, [mbCancel], 0 );
      Halt;
    end;
    FDivisasISO := TStringList.Create();
    FDivisasISO.LoadFromFile( FDirData + kFileISO );
    if not FileExists( FDirData + kFileProv ) then
    begin
      MessageDlg( 'El fichero de provincias no existe.' + #13 + FDirData + kFileProv, mtError, [mbCancel], 0 );
      Halt;
    end;
    FProvincias := TStringList.Create();
    FProvincias.LoadFromFile( FDirData + kFileProv );
    if not FileExists( FDirData + kFileOfiCaja ) then
    begin
      MessageDlg('El fichero de oficinas de la caja no existe.' + #13 + FDirData + kFileOfiCaja, mtError, [mbCancel], 0 );
      Halt;
    end;
    FOficinasCIA := TStringList.Create();
    FOficinasCIA.LoadFromFile( FDirData + kFileOfiCaja );
    if not FileExists( FDirData + kFileEntidades ) then
    begin
      MessageDlg('El fichero de entidades externas no existe.' + #13 + FDirData + kFileEntidades, mtError, [mbCancel], 0);
      Halt;
    end;
    FEntidades := TStringList.Create();
    FEntidades.LoadFromFile( FDirData + kFileEntidades );
    FEntidadActiva := '';  // En principio no hay ninguna entidad que se haya leído para comprobar sus oficinas
    FOficinas := TStringList.Create();

    if not FileExists( FDirData + kFileCodsReembolsos ) then
    begin
      MessageDlg( 'El fichero con los Códigos de reembolsos no existe.' + #13 + FDirData + kFileCodsReembolsos, mtError, [mbCancel], 0);
      Halt;
    end;
    FConceptosReembolso := TStringList.Create();
    FConceptosReembolso.LoadFromFile( FDirData + kFileCodsReembolsos );

// 01.05.02 -- se prescinde de la tabla externa de códigos de devolución
//
//    if not FileExists( FDirData + kFileCodsDevolucion ) then
//    begin
//      MessageDlg('El fichero con los Códigos de devolución no existe.' + #13 + FDirData + kFileCodsDevolucion, mtError, [mbCancel], 0 );
//      Halt;
//    end;
//    FConceptosDevolucion := TStringList.Create();
//    FConceptosDevolucion.LoadFromFile(FDirData + kFileCodsDevolucion);
  end;

  destructor TQueryEngine.Destroy;
  begin
    FDivisasISO.Free();
    FProvincias.free();
    FOficinasCIA.free();
    FEntidades.free();
    FOficinas.free();
    FConceptosReembolso.free();

    inherited;
  end;

  //::: SOPORTE DE LAS DIVISAS
  function TQueryEngine.existsDivisaISO( const ISOCode: String ): boolean;
  begin
    result := ( FDivisasISO.IndexOfName( ISOCode ) >= 0 );
  end;

  function TQueryEngine.getDivisaName( const ISOCode: String ): String;
  const
    klErrorNotFound = 'La divisa señalada no existe en la BB.DD.';
  begin
    if not existsDivisaISO( ISOCode ) then
      raise Exception.Create( klErrorNotFound );

    result := FDivisasISO.Values[ ISOCode ];
  end;

  function TQueryEngine.existsProvincia( const ProvCode: String ): boolean;
  begin
    result := ( FProvincias.IndexOfName( ProvCode ) >= 0 );
  end;

  function TQueryEngine.getProvinciaName( const ProvCode: String ): String;
  const
    klErrorNotFound = 'La provincia señalada no existe en la BB.DD.' ;
  begin
    if not existsProvincia( ProvCode ) then
      raise Exception.Create( klErrorNotFound );

    result := FProvincias.Values[ ProvCode ];
  end;

  function TQueryEngine.existsOfiCaja( const OfiCode: String ): boolean;
  begin
    result := ( FOficinasCIA.IndexOfName( OfiCode ) >= 0 );
  end;

  function TQueryEngine.getOfiCajaName( const OfiCode: String ): String;
  const
    klErrorNotFound = 'La oficina de La Caja señalada no existe en la BB.DD.' ;
  begin
    if not existsOfiCaja( OfiCode ) then
      raise Exception.Create( klErrorNotFound );

    result := FOficinasCIA.Values[ OfiCode ];
  end;

  function TQueryEngine.existsEntidad( const EntCode: String ): boolean;
  begin
    result := ( FEntidades.IndexOfName( EntCode ) >= 0 );
  end;

  function TQueryEngine.getEntidadName( const EntCode: String ): String;
  const
    klErrorNotFound = 'La entidad señalada no existe en la BB.DD.' ;
  begin
    if not existsEntidad( EntCode ) then
      raise Exception.Create( klErrorNotFound );

    result := FEntidades.Values[ EntCode ];
    // nos anticipamos a la jugada...
    ReadFileSucursales( EntCode );
  end;

  function TQueryEngine.existsSucursal( const EntCode, OfiCode: String ): boolean;
  begin
    ReadFileSucursales( EntCode );
    result := ( FOficinas.IndexOf( OfiCode ) >= 0 );
  end;

  function TQueryEngine.getConceptoReembolso( const Codigo:String ): String;
  const
    klErrorNotFound = 'El código señalado no existe en la BB.DD.';
  begin
    if not existsConceptoReembolso( Codigo ) then
      raise Exception.Create( klErrorNotFound );

    result := FConceptosReembolso.Values[Codigo];
  end;

  function TQueryEngine.existsConceptoReembolso( const Codigo:String ): Boolean;
  begin
    Result := ( FConceptosReembolso.IndexOfName(Codigo) >= 0 );
  end;

// 01.05.02 -- se prescinde de la tabla externa de códigos de devoluciones
//
//  function TQueryEngine.getConceptoDevolucion(const Codigo:String): String;
//  const
//    klErrorNoExiste = 'El código señalado no existe en la BB.DD.';
//  begin
//    if not existsConceptoDevolucion(Codigo) then
//      raise Exception.Create(klErrorNoExiste);
//
//    Result := FConceptosDevolucion.Values[Codigo];
//  end;
//
//  function TQueryEngine.existsConceptoDevolucion(const Codigo:String): Boolean;
//  begin
//    Result := (FConceptosDevolucion.IndexOfName(Codigo) >= 0);
//  end;


  // rutinas que facilitan la búsqueda de elementos
  function TQueryEngine.searchEntidad(const defValue: String): String;
  var
    searchForm: TSearchRecAuxForm;
  begin
    Result := defValue;
    searchForm := TSearchRecAuxForm.Create(nil);
    try
      // se le pasa una lista con todos los elementos para que los descomponga y
      // los muestre.
      searchForm.showElements(FEntidades);
      if searchForm.ShowModal() = mrOk then
        Result := searchForm.getSelectedValue();
    finally
      searchForm.Free();
    end
  end;

end.

