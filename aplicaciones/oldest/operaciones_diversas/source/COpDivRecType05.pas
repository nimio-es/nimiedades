unit COpDivRecType05;

(*******************************************************************************)
(* CLASE: TOpDivRecType05                                                      *)
(* FECHA CREACION: 01-08-2001                                                  *)
(* PROGRAMADOR: Saulo Alvarado Mateos                                          *)
(* DESCRIPCI�N:                                                                *)
(*       Implementaci�n del registro tipo 05 -Actas de protesto (Cobros)       *)
(*                                                                             *)
(* FECHA MODIFICACI�N: 07-05-2002                                              *)
(* PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *)
(* DESCRIPCI�N:                                                                *)
(*       Se ajusta la clase a la nueva forma de impresi�n del registro, tenien-*)
(* do ahora un par de m�todos intermediarios.                                  *)
(*******************************************************************************)

interface

  uses
    classes,
    CCustomDBMiddleEngine,
    COpDivSystemRecord ;

  const
    k05_IDSubsPresentaInicial = '11.01';
    k05_RefInicialSubsPresenta = '11.02';
    k05_FiguraEntidadPresenta = '11.03';
    k05_Diponible            = '12.01';

  type
    TOpDivRecType05 = class( TOpDivSystemRecord )
      protected
        FIDSubsPresentaInicial: String; // Identificaci�n del subsistema de presentaci�n inicial
        FRefInicDelSistema: String;     // Referencia inicial del sistema
        FFigEntPresenta: String;        // Figura de la entidad presentadora
        FLibre: String;                 // Campo libre

        //*****
        // m�todos de soporte a las propiedades
        //*****
        procedure setSubsPresentaInicial( const aString: String );
        procedure setRefInicDelSistema( const aString: String );
        procedure setFigEntPresenta( const aString: String );
        procedure setLibre( const aString: String );

        //:: otros m�todos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property IDSubsPresentaInicial: String read FIDSubsPresentaInicial write setSubsPresentaInicial;
        property RefInicDelSistema: string read FRefInicDelSistema write setRefInicDelSistema;
        property FigEntPresenta: String read FFigEntPresenta write setFigEntPresenta;
        property Libre: String read FLibre write setLibre;

        //** m�todos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function  getDataAsFileRecord: String; override;
// 07.05.02 - a partir de ahora se encarga un m�todo intermedio de imprimir los datos espec�ficos
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;
    end;

implementation

  uses
    SysUtils,
    rxStrUtils,
    CCriptografiaCutre;

(*********
 M�TODOS PRIVADOS
 *********)

  //****** Soporte a las propiedades ******
  procedure TOpDivRecType05.setSubsPresentaInicial( const aString: String );
  const
    klValoresPosibles: set of char = [ '0', '1', '2', '3' ];
    klError = 'se debe indicar un valor v�lido (0,1,2,3)';
  var
    texto: String;
  begin
    texto := trim( aString );
    if not ( texto[1] in klValoresPosibles ) then
    begin
//      raise Exception.Create( klError );
      dataErrorEventCall(k05_IDSubsPresentaInicial, klError);
      Exit;
    end;
    if FIDSubsPresentaInicial <> texto then
    begin
      FIDSubsPresentaInicial := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType05.setRefInicDelSistema( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString ) ;
    if FRefInicDelSistema <> texto then
    begin
      FRefInicDelSistema := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType05.setFigEntPresenta( const aString: String );
  const
    klValoresPosibles: set of char = [ '1', '2'];
    klError = 'se debe indicar un valor v�lido (1,2)';
  var
    texto: String;
  begin
    texto := trim( aString );
    if not ( texto[1] in klValoresPosibles ) then
    begin
//      raise Exception.Create( klError );
      dataErrorEventCall(k05_FiguraEntidadPresenta, klError);
      Exit;
    end;
    if FFigEntPresenta <> texto then
    begin
      FFigEntPresenta := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType05.setLibre( const aString: String );
  var
    texto: string;
  begin
    texto := trim( aString );
    if FLibre <> texto then
    begin
      FLibre := texto;
      changeEventCall();
    end;
  end;

  //***** otros m�todos de soporte
  procedure TOpDivRecType05.initializeData;
  begin
    inherited;
    FRecType := '05';  // el tipo 05
    FOpNat := '1';  // siempre se trata de cobros

    // algunos datos de control sobre los valores
    FOpNatFixed := true;
    FNumCtaDestinoEsObligatoria := false;
    FClaveAutorizaEsObligatoria := false;

    // tambi�n se le van a dar valores iniciales a los datos
    FIDSubsPresentaInicial := '3';
    FRefInicDelSistema := '0000000000000000';
    FFigEntPresenta := '2';
  end;

  function  TOpDivRecType05.getStringForCodeData;
  begin
    Result := inherited getStringForCodeData()
            + kCodeSeparator + FIDSubsPresentaInicial
            + kCodeSeparator + FRefInicDelSistema
            + kCodeSeparator + FFigEntPresenta
            + kCodeSeparator + FLibre
            + kCodeSeparator ;
  end;

(*********
 M�TODOS P�BLICOS
 *********)

  //: rellena los datos a partir de una lista de cadenas...
  procedure TOpDivRecType05.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );
    if aStringList.IndexOfName( k05_IDSubsPresentaInicial ) > kNoNameFound then
      FIDSubsPresentaInicial := aStringList.Values[ k05_IDSubsPresentaInicial ];
    if aStringList.IndexOfName( k05_RefInicialSubsPresenta ) > kNoNameFound then
      FRefInicDelSistema := aStringList.Values[ k05_RefInicialSubsPresenta ];
    if aStringList.IndexOfName( k05_FiguraEntidadPresenta ) > kNoNameFound then
      FFigEntPresenta := aStringList.Values[ k05_FiguraEntidadPresenta ];
    if aStringList.IndexOfName( k05_Diponible ) > kNoNameFound then
      FLibre := aStringList.Values[ k05_Diponible ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType05.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );
    aStringList.Values[ k05_IDSubsPresentaInicial ] := FIDSubsPresentaInicial ;
    aStringList.Values[ k05_RefInicialSubsPresenta ] := FRefInicDelSistema ;
    aStringList.Values[ k05_FiguraEntidadPresenta ] := FFigEntPresenta ;
    aStringList.Values[ k05_Diponible ] := FLibre ;
  end;

  //:: se fuerza la comprobaci�n de todos los datos
  procedure TOpDivRecType05.TestData;
  const
    klIdSubsistemaError   = 'Debe indicar un ID. Para el subsistema v�lido.';
    klFiguraEntidadError  = 'Denbe indicar un c�digo correcto para la Figura de la entidad presentadora.';
  begin
    inherited;
    // id del subsistema
    if not ( FIDSubsPresentaInicial[1] in [ '0', '1', '2', '3' ] ) then
    begin
      dataErrorEventCall(k05_IDSubsPresentaInicial, klIDSubsistemaError);
      Exit;
//      raise Exception.Create( klIDSubsistemaError );
    end;
    // figura entidad
    if not ( FFigEntPresenta[1] in ['1','2'] ) then
    begin
//      raise Exception.Create( klFiguraEntidadError );
      dataErrorEventCall(k05_FiguraEntidadPresenta, klFiguraEntidadError);
    end;
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType05.getDataAsFileRecord: String;
  begin
    result := AddCharR( ' ', inherited getDataAsFileRecord()
         + FIDSubsPresentaInicial
         + AddChar( '0', FRefInicDelSistema, 16 )
         + FFigEntPresenta
         + FLibre , 352 );
  end;


// 07.05.02 -- se encargar un par de m�todos de imprimir los datos espec�ficos

  function TOpDivRecType05.printSpecificType: String;
  begin
    Result := 'TIPO: 05 - ACTAS DE PROTESTO';
  end;

//  procedure TOpDivRecType05.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType05.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // para alias debido a que no se desea cambiar todas las referencias
  begin
    anStrList := aDataString;
//    anStrList.Add('TIPO: 05 - ACTAS DE PROTESTO');
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // indicador del subsistema de presentaci�n inicial
    lnPtr := 'IDENTIFICACI�N DEL SUBSISTEMA';
    anStrList.Add(lnPtr);
    lnPtr := 'DE PRESENTACI�N INICIAL........ : ' + FIDSubsPresentaInicial + ' - ' ;
    if      FIDSubsPresentaInicial = '0' then
      lnPtr := lnPtr + 'DESCONOCIDO'
    else if FIDSubsPresentaInicial = '1' then
      lnPtr := lnPtr + 'S.N.C.E. 004'
    else if FIDSubsPresentaInicial = '2' then
      lnPtr := lnPtr + 'S.N.C.E. 007'
    else if FIDSubsPresentaInicial = '3' then
      lnPtr := lnPtr + 'S.N.C.E. 008'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // referencia del subsistema de presentaci�n
    lnPtr := 'REFERENCIA INICIAL DEL';
    anStrList.Add(lnPtr);
    lnPtr := 'SUBSISTEMA DE PRESENTACI�N..... : ' + FRefInicDelSistema ;
    anStrList.Add(lnPtr);
    // figura de la entidad presentadora
    lnPtr := 'FIGURA ENTIDAD PRESENTADORA.... : ' + FFigEntPresenta + ' - ' ;
    if      FFigEntPresenta = '1' then
      lnPtr := lnPtr + 'TERCERA ENTIDAD'
    else if FFigEntPresenta = '2' then
      lnPtr := lnPtr + 'DOMICILIATARIA'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
  end;

end.
